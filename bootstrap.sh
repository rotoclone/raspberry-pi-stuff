# exit on error
set -e

BASE_DIR=/home/pi
GIT_DIR=${BASE_DIR}/git

cd ${BASE_DIR}
mkdir ${GIT_DIR}

# TODO set to boot to command-line

echo "Updating packages..."
apt-get update
apt-get upgrade
echo "Done"

echo "Installing vim..."
apt-get install vim
echo "Done"

echo "Installing nginx..."
apt-get install nginx
echo "Done"

echo "Installing fail2ban..."
apt-get install fail2ban
echo "Done"

echo "Setting up fail2ban..."
wget -O /etc/fail2ban/jail.local https://github.com/rotoclone/raspberry-pi-stuff/raw/master/fail2ban/jail.local
wget -O /etc/fail2ban/filter.d/nginx-noscript.conf https://github.com/rotoclone/raspberry-pi-stuff/raw/master/fail2ban/nginx-noscript.conf
wget -O /etc/fail2ban/filter.d/nginx-nohome.conf https://github.com/rotoclone/raspberry-pi-stuff/raw/master/fail2ban/nginx-nohome.conf
wget -O /etc/fail2ban/filter.d/nginx-noproxy.conf https://github.com/rotoclone/raspberry-pi-stuff/raw/master/fail2ban/nginx-noproxy.conf
wget -O /etc/fail2ban/filter.d/nginx-dos.conf https://github.com/rotoclone/raspberry-pi-stuff/raw/master/fail2ban/nginx-dos.conf
systemctl restart fail2ban
echo "Done"

echo "Installing certbot..."
apt-get install certbot
apt-get install python-certbot-nginx
echo "Done"

echo "Installing rust..."
curl https://sh.rustup.rs -sSf | sh
echo "Done"

#echo "Installing docker..."
#curl -sSL https://get.docker.com | sh
#usermod -aG docker pi
#wget -O /etc/docker/daemon.json https://github.com/rotoclone/raspberry-pi-stuff/raw/master/docker/daemon.json
#echo "Done"

## begin umami stuff
echo "Installing protobuf..."
apt-get install protobuf-compiler
echo "Done"

echo "Increasing swapfile size...
#TODO update /etc/dphys-swapfile
/etc/init.d/dphys-swapfile restart
echo "Done"

echo "Building prisma..."
cd ${GIT_DIR}
git clone https://github.com/prisma/prisma-engines.git
cd prisma-engines
git checkout 2.19.0
source ./.envrc
cargo build --release
cd ${BASE_DIR}
echo "Done"

echo "Resetting swapfile size...
#TODO update /etc/dphys-swapfile
/etc/init.d/dphys-swapfile restart
echo "Done"

echo "Installing nodejs..."
curl -sL https://deb.nodesource.com/setup_15.x | sudo -E bash -
apt-get install -y nodejs
echo "Done"

echo "Installing postgresql..."
apt-get install postgresql
sudo -u postgres bash -c "psql -c \"CREATE USER pi PASSWORD 'dbpassword' CREATEDB CREATEROLE;\""
createdb pi
echo "Done"

#echo "Installing mysql..."
#apt-get install mariadb-server
#echo "Done"

echo "Installing umami..."
cd ${GIT_DIR}
git clone https://github.com/mikecao/umami.git
sudo -u pi bash -c "psql -c \"CREATE DATABASE umamidb;\""
sudo -u pi bash -c "psql -d umamidb -f sql/schema.postgresql.sql"
#mysql --user=root --execute="CREATE DATABASE umamidb;"
#mysql --user=root --execute="CREATE USER 'dbuser'@'localhost' IDENTIFIED BY 'dbpassword'; GRANT ALL PRIVILEGES ON umamidb.* TO 'dbuser'@'localhost'; FLUSH PRIVILEGES;"
#mysql --user=root umamidb < sql/schema.mysql.sql
cd umami
git checkout v1.16.0
wget -O .env https://github.com/rotoclone/raspberry-pi-stuff/raw/master/umami/.env
wget -O prisma/.env https://github.com/rotoclone/raspberry-pi-stuff/raw/master/umami/prisma.env
npm install
npm run build
cd ${BASE_DIR}
echo "Done"

echo "Setting up umami systemd service..."
mkdir /var/log/umami
wget -O /etc/logrotate.d/umami https://github.com/rotoclone/raspberry-pi-stuff/raw/master/logrotate/umami
wget -O /etc/systemd/system/umami.service https://github.com/rotoclone/raspberry-pi-stuff/raw/master/systemd/umami.service
echo "Done"
## end umami stuff

## begin shynet stuff
#echo "Installing pip..."
#apt install python3-pip
#echo "Done"

#echo "Installing docker-compose..."
#pip3 -v install docker-compose
#echo "Done"

#echo "Installing shynet..."
#cd ${GIT_DIR}
#git clone https://github.com/milesmcc/shynet.git
#wget -O shynet/.env https://github.com/rotoclone/raspberry-pi-stuff/raw/master/shynet/.env
#wget -O shynet/nginx.conf https://github.com/rotoclone/raspberry-pi-stuff/raw/master/shynet/nginx.conf
#wget -O shynet/docker-compose.yml https://github.com/rotoclone/raspberry-pi-stuff/raw/master/shynet/docker-compose.yml
#wget -O shynet/Dockerfile https://github.com/rotoclone/raspberry-pi-stuff/raw/master/shynet/Dockerfile
#cd shynet
#/usr/bin/docker build -t armshynet . --network=host
#/home/pi/.local/bin/docker-compose up -d
#cd ${BASE_DIR}
#docker exec -it shynet_main ./manage.py registeradmin rotoclone@example.com
#docker exec -it shynet_main ./manage.py hostname analytics.rotoclone.zone
#echo "Done"
## end shynet stuff

echo "Installing system-stats-dashboard..."
wget -O system-stats-dashboard.zip https://github.com/rotoclone/system-stats-dashboard/releases/latest/download/raspberrypi.zip
unzip system-stats-dashboard.zip -d /home/pi/system-stats-dashboard
chmod +x /home/pi/system-stats-dashboard/system-stats-dashboard
rm -f system-stats-dashboard.zip
echo "Done"

echo "Installing rotoclone-zone..."
wget -O rotoclone-zone.zip https://github.com/rotoclone/rotoclone-zone/releases/latest/download/raspberrypi.zip
unzip rotoclone-zone.zip -d /home/pi/rotoclone-zone
chmod +x /home/pi/rotoclone-zone/rotoclone-zone
rm -f rotoclone-zone.zip
echo "Done"

echo "Setting up system-stats-dashboard systemd service..."
mkdir /var/log/system-stats-dashboard
wget -O /etc/logrotate.d/system-stats-dashboard https://github.com/rotoclone/raspberry-pi-stuff/raw/master/logrotate/system-stats-dashboard
wget -O /etc/systemd/system/systemstatsdashboard.service https://github.com/rotoclone/raspberry-pi-stuff/raw/master/systemd/systemstatsdashboard.service
echo "Done"

echo "Setting up rotoclone-zone systemd service..."
mkdir /var/log/rotoclone-zone
wget -O /etc/logrotate.d/rotoclone-zone https://github.com/rotoclone/raspberry-pi-stuff/raw/master/logrotate/rotoclone-zone
wget -O /etc/systemd/system/rotoclonezone.service https://github.com/rotoclone/raspberry-pi-stuff/raw/master/systemd/rotoclonezone.service
echo "Done"

echo "Setting up nginx config..."
wget -O /etc/nginx/conf.d/rotoclone.zone.conf https://github.com/rotoclone/raspberry-pi-stuff/raw/master/nginx/rotoclone.zone.conf
wget -O /etc/nginx/nginx.conf https://github.com/rotoclone/raspberry-pi-stuff/raw/master/nginx/nginx.conf
echo "Done"

# run certbot so it sets up the auto-renew stuff
echo "Running certbot..."
certbot --nginx -d rotoclone.zone -d www.rotoclone.zone -d analytics.rotoclone.zone
echo "Done"

echo "Enabling services..."
systemctl daemon-reload
systemctl enable ssh
systemctl enable nginx
systemctl enable fail2ban
#systemctl enable docker
systemctl enable systemstatsdashboard
systemctl enable rotoclonezone
systemctl enable postgresql
systemctl enable umami
echo "Done"

echo "Success! Rebooting..."
reboot
