# exit on error
set -e

# TODO set to boot to command-line

# install vim
apt-get install vim

# install nginx
apt-get install nginx

# install certbot (with nginx extension)
apt-get install certbot
apt-get install python-certbot-nginx

# install rust
curl https://sh.rustup.rs -sSf | sh

# install docker
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker pi

# install pip
apt install python3-pip

# install docker-compose
pip3 -v install docker-compose

# install shynet
#TODO

# install latest system-stats-dashboard release
wget -O system-stats-dashboard.zip https://github.com/rotoclone/system-stats-dashboard/releases/latest/download/raspberrypi.zip
unzip system-stats-dashboard.zip -d /home/pi/system-stats-dashboard
chmod +x /home/pi/system-stats-dashboard/system-stats-dashboard
rm -f system-stats-dashboard.zip

# install latest blog-server release
wget -O blog-server.zip https://github.com/rotoclone/blog-server/releases/latest/download/raspberrypi.zip
unzip blog-server.zip -d /home/pi/blog-server
chmod +x /home/pi/blog-server/blog-server
rm -f blog-server.zip

# set up system-stats-dashboard systemd service
wget -O systemstatsdashboard.service https://github.com/rotoclone/raspberry-pi-stuff/raw/master/systemd/systemstatsdashboard.service
mv systemstatsdashboard.service /etc/systemd/system/

# set up blog-server systemd service
wget -O blogserver.service https://github.com/rotoclone/raspberry-pi-stuff/raw/master/systemd/blogserver.service
mv blogserver.service /etc/systemd/system/

# set up nginx
wget -O rotoclone.zone.conf https://github.com/rotoclone/raspberry-pi-stuff/raw/master/nginx/rotoclone.zone.conf
mv rotoclone.zone.conf /etc/nginx/conf.d/

# run certbot so it sets up the auto-renew stuff
certbot --nginx -d rotoclone.zone -d www.rotoclone.zone

# enable services
systemctl daemon-reload
systemctl enable ssh
systemctl enable nginx
systemctl enable docker
systemctl enable systemstatsdashboard
systemctl enable blogserver

echo "Success! Rebooting..."
reboot
