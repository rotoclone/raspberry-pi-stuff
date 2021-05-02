##
# Other steps to do not in this script:
# * set to boot to command-line
# * disable nopasswd for pi user (`sudo visudo /etc/sudoers.d/010_pi-nopasswd`)
##

# exit on error
set -e

BASE_DIR=/home/pi
GIT_DIR=${BASE_DIR}/git

cd ${BASE_DIR}
mkdir ${GIT_DIR}

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
#echo "Installing protobuf..."
#apt-get install protobuf-compiler
#echo "Done"

#echo "Increasing swapfile size...
#TODO update /etc/dphys-swapfile
#/etc/init.d/dphys-swapfile restart
#echo "Done"

#echo "Building prisma..."
#cd ${GIT_DIR}
#git clone https://github.com/prisma/prisma-engines.git
#cd prisma-engines
#git checkout 2.19.0
#source ./.envrc
#cargo build --release
#cd ${BASE_DIR}
#echo "Done"

#echo "Resetting swapfile size...
#TODO update /etc/dphys-swapfile
#/etc/init.d/dphys-swapfile restart
#echo "Done"

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

#echo "Installing umami..."
#cd ${GIT_DIR}
#git clone https://github.com/mikecao/umami.git
#sudo -u pi bash -c "psql -c \"CREATE DATABASE umamidb;\""
#sudo -u pi bash -c "psql -d umamidb -f sql/schema.postgresql.sql"
##mysql --user=root --execute="CREATE DATABASE umamidb;"
##mysql --user=root --execute="CREATE USER 'dbuser'@'localhost' IDENTIFIED BY 'dbpassword'; GRANT ALL PRIVILEGES ON umamidb.* TO 'dbuser'@'localhost'; FLUSH PRIVILEGES;"
##mysql --user=root umamidb < sql/schema.mysql.sql
#cd umami
#git checkout v1.16.0
#wget -O .env https://github.com/rotoclone/raspberry-pi-stuff/raw/master/umami/.env
#wget -O prisma/.env https://github.com/rotoclone/raspberry-pi-stuff/raw/master/umami/prisma.env
#npm install
#npm run build
#cd ${BASE_DIR}
#echo "Done"

#echo "Setting up umami systemd service..."
#mkdir /var/log/umami
#wget -O /etc/logrotate.d/umami https://github.com/rotoclone/raspberry-pi-stuff/raw/master/logrotate/umami
#wget -O /etc/systemd/system/umami.service https://github.com/rotoclone/raspberry-pi-stuff/raw/master/systemd/umami.service
#echo "Done"
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

## begin goatcounter stuff
echo "Installing goatcounter..."
wget -O goatcounter.gz https://github.com/zgoat/goatcounter/releases/download/v2.0.4/goatcounter-v2.0.4-linux-arm.gz
gunzip goatcounter.gz
chmod +x /home/pi/goatcounter
rm -f goatcounter.gz
# using postgres provides better performance, but goatcounter requires postgres 12, which isn't available for raspberry pi yet
#sudo -u pi bash -c "psql -c \"CREATE DATABASE goatcounter;\""
#sudo -u pi bash -c "psql -c \"alter database goatcounter set seq_page_cost=.5;\""
echo "Done"

echo "Setting up goatcounter systemd service..."
mkdir /var/log/goatcounter
wget -O /etc/logrotate.d/goatcounter https://github.com/rotoclone/raspberry-pi-stuff/raw/master/logrotate/goatcounter
wget -O /etc/systemd/system/goatcounter.service https://github.com/rotoclone/raspberry-pi-stuff/raw/master/systemd/goatcounter.service
echo "Done"
## end goatcounter stuff

## begin commento stuff
echo "Installing go..."
apt install build-essential golang go-dep
echo "Done"

echo "Installing yarn..."
npm install --global yarn
echo "Done"

#echo "Installing commento..."
#sudo -u pi bash -c "psql -c \"CREATE DATABASE commento;\""
#cd ${GIT_DIR}
#git clone https://gitlab.com/commento/commento.git
#cd commento
#make prod
#cd ${BASE_DIR}
#echo "Done"

#echo "Setting up commento systemd service..."
#mkdir /var/log/commento
#wget -O /etc/logrotate.d/commento https://github.com/rotoclone/raspberry-pi-stuff/raw/master/logrotate/commento
#wget -O /etc/systemd/system/commento.service https://github.com/rotoclone/raspberry-pi-stuff/raw/master/systemd/commento.service
#echo "Done"

echo "Installing commento++..."
sudo -u pi bash -c "psql -c \"CREATE DATABASE commento;\""
cd ${GIT_DIR}
git clone https://github.com/souramoo/commentoplusplus.git
cd commento
make prod
cd ${BASE_DIR}
echo "Done"

echo "Setting up commento++ systemd service..."
mkdir /var/log/commentoplusplus
wget -O /etc/logrotate.d/commentoplusplus https://github.com/rotoclone/raspberry-pi-stuff/raw/master/logrotate/commentoplusplus
wget -O /etc/systemd/system/commentoplusplus.service https://github.com/rotoclone/raspberry-pi-stuff/raw/master/systemd/commentoplusplus.service
echo "Don't forget to set up /etc/commento.env! (https://docs.commento.io/configuration/backend/)"
echo "Done"

echo "Installing postfix..."
apt install postfix libsasl2-modules
echo "Don't forget to set up /etc/postfix/sasl/sasl_passwd! (https://medium.com/swlh/setting-up-gmail-and-other-email-on-a-raspberry-pi-6f7e3ad3d0e)"
cp /etc/postfix/main.cf /etc/postfix/main.cf.dist
wget -O /etc/postfix/main.cf https://github.com/rotoclone/raspberry-pi-stuff/raw/master/postfix/main.cf
systemctl restart postfix
echo "Done"
## end commento stuff

echo "Installing system-stats-dashboard..."
wget -O system-stats-dashboard.zip https://github.com/rotoclone/system-stats-dashboard/releases/latest/download/raspberrypi.zip
unzip system-stats-dashboard.zip -d /home/pi/system-stats-dashboard
chmod +x /home/pi/system-stats-dashboard/system-stats-dashboard
rm -f system-stats-dashboard.zip
echo "Done"

echo "Cloning rotoclone-zone-content..."
cd ${GIT_DIR}
git clone https://github.com/rotoclone/rotoclone-zone-content.git
cd ${BASE_DIR}
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
certbot --nginx -d rotoclone.zone -d www.rotoclone.zone -d analytics.rotoclone.zone -d comments.rotoclone.zone
echo "Done"

echo "Enabling services..."
systemctl daemon-reload
systemctl enable ssh
systemctl enable nginx
systemctl enable fail2ban
#systemctl enable docker
systemctl enable postgresql
#systemctl enable umami
systemctl enable goatcounter
#systemctl enable commento
systemctl enable commentoplusplus
systemctl enable systemstatsdashboard
systemctl enable rotoclonezone
echo "Done"

echo "Disabling wifi..."
echo "dtoverlay=disable-wifi" | sudo tee -a /boot/config.txt
echo "Done"

echo "Success! Rebooting..."
reboot
