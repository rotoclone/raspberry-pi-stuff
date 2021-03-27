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

# TODO download and unzip latest system-stats-dashboard release
# TODO download and unzip latest blog-server release
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
