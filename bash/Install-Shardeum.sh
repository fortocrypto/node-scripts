#!/bin/bash

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install curl git npm -y
apt remove npm -y
rm -Rf $HOME/.npm
apt install npm -y
npm cache clean -f
npm install -g n
n stable
npm install -g npm@latest
sudo apt install docker.io -y
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
cd $SDD_NM_HOME/.Shardeum
get_ip() {
local ip
if command -v ip >/dev/null; then
ip=$(ip addr show $(ip route | awk '/default/ {print $5}') | awk '/inet/ {print $2}' | cut -d/ -f1 | head -n1)
elif command -v netstat >/dev/null; then
# Get the default route interface
interface=$(netstat -rn | awk '/default/{print $4}' | head -n1)
# Get the IP address for the default interface
ip=$(ifconfig "$interface" | awk '/inet /{print $2}')
else
echo "Error: neither 'ip' nor 'ifconfig' command found. Submit a bug for your OS."
return 1
fi
echo $ip
}

get_external_ip() {
external_ip=''
external_ip=$(curl -s https://api.ipify.org)
if [[ -z "$external_ip" ]]; then
external_ip=$(curl -s http://checkip.dyndns.org | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
fi
if [[ -z "$external_ip" ]]; then
external_ip=$(curl -s http://ipecho.net/plain)
fi
if [[ -z "$external_ip" ]]; then
external_ip=$(curl -s https://icanhazip.com/)
fi
if [[ -z "$external_ip" ]]; then
external_ip=$(curl --header  "Host: icanhazip.com" -s 104.18.114.97)
fi
if [[ -z "$external_ip" ]]; then
external_ip=$(get_ip)
if [ $? -eq 0 ]; then
echo "The IP address is: $IP"
else
external_ip="localhost"
fi
fi
echo $external_ip
}

RUNDASHBOARD=${RUNDASHBOARD:-y}
DASHPASS=$password
DASHPORT=${DASHPORT:-8080}
SHMEXT=${SHMEXT:-9001}
SHMINT=${SHMINT:-10001}
NODEHOME=${NODEHOME:-$SDD_NM_HOME/.Shardeum/.shardeum}
APPSEEDLIST="archiver-sphinx.shardeum.org"
APPMONITOR="monitor-sphinx.shardeum.org"
if [ -d "$NODEHOME" ]; then
if [ "$NODEHOME" != "$(pwd)" ]; then
echo "Removing existing directory $NODEHOME..."
rm -rf "$NODEHOME"
else
echo "Cannot delete current working directory. Please move to another directory and try again."
fi
fi
git clone https://gitlab.com/shardeum/validator/dashboard.git ${NODEHOME} &&
cd ${NODEHOME} &&
chmod a+x ./*.sh
SERVERIP=$(get_external_ip)
LOCALLANIP=$(get_ip)
cd ${NODEHOME} &&
touch ./.env
cat >./.env <<EOL
APP_IP=auto
APP_SEEDLIST=${APPSEEDLIST}
APP_MONITOR=${APPMONITOR}
DASHPASS=${DASHPASS}
DASHPORT=${DASHPORT}
SERVERIP=${SERVERIP}
LOCALLANIP=${LOCALLANIP}
SHMEXT=${SHMEXT}
SHMINT=${SHMINT}
EOL
./cleanup.sh
cd ${NODEHOME} &&
docker-safe build --no-cache -t local-dashboard -f Dockerfile --build-arg RUNDASHBOARD=${RUNDASHBOARD} .
echo "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
cd ${NODEHOME}
if [[ "$(uname)" == "Darwin" ]]; then
sed "s/- '8080:8080'/- '$DASHPORT:$DASHPORT'/" docker-compose.tmpl > docker-compose.yml
sed -i '' "s/- '9001-9010:9001-9010'/- '$SHMEXT:$SHMEXT'/" docker-compose.yml
sed -i '' "s/- '10001-10010:10001-10010'/- '$SHMINT:$SHMINT'/" docker-compose.yml
else
sed "s/- '8080:8080'/- '$DASHPORT:$DASHPORT'/" docker-compose.tmpl > docker-compose.yml
sed -i "s/- '9001-9010:9001-9010'/- '$SHMEXT:$SHMEXT'/" docker-compose.yml
sed -i "s/- '10001-10010:10001-10010'/- '$SHMINT:$SHMINT'/" docker-compose.yml
fi
echo "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
./docker-up.sh
echo "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
}

install
