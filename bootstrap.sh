# exit on error
set -e

# TODO set to boot to command-line
# TODO enable SSH

# install vim
apt-get install vim

# install nginx
apt-get install nginx

# install certbot (with nginx extension)
apt-get install certbot
apt-get install python-certbot-nginx

# install rust
curl https://sh.rustup.rs -sSf | sh

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

# TODO download .service files and copy them to /etc/systemd/system
# TODO download nginx config files and copy them to the correct locations

# enable services
systemctl daemon-reload
systemctl enable nginx
systemctl enable systemstatsdashboard
systemctl enable blogserver

# run certbot so it sets up the auto-renew stuff
certbot --nginx -d rotoclone.zone -d www.rotoclone.zone

echo "Success! Rebooting..."
reboot
