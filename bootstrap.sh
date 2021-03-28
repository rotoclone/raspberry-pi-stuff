# exit on error
set -e

# TODO set to boot to command-line

echo "Installing vim..."
apt-get install vim
echo "Done"

echo "Installing nginx..."
apt-get install nginx
echo "Done"

echo "Installing certbot..."
apt-get install certbot
apt-get install python-certbot-nginx
echo "Done"

echo "Installing rust..."
curl https://sh.rustup.rs -sSf | sh
echo "Done"

echo "Installing docker..."
curl -sSL https://get.docker.com | sh
#usermod -aG docker pi
echo "Done"

echo "Installing pip..."
apt install python3-pip
echo "Done"

echo "Installing docker-compose..."
pip3 -v install docker-compose
echo "Done"

echo "Installing shynet..."
git clone https://github.com/milesmcc/shynet.git
wget -O shynet/.env https://github.com/rotoclone/raspberry-pi-stuff/raw/master/shynet/.env
wget -O shynet/nginx.conf https://github.com/rotoclone/raspberry-pi-stuff/raw/master/shynet/nginx.conf
/home/pi/.local/bin/docker-compose #TODO
rm -rf shynet
echo "Done"

echo "Installing system-stats-dashboard..."
wget -O system-stats-dashboard.zip https://github.com/rotoclone/system-stats-dashboard/releases/latest/download/raspberrypi.zip
unzip system-stats-dashboard.zip -d /home/pi/system-stats-dashboard
chmod +x /home/pi/system-stats-dashboard/system-stats-dashboard
rm -f system-stats-dashboard.zip
echo "Done"

echo "Installing blog-server..."
wget -O blog-server.zip https://github.com/rotoclone/blog-server/releases/latest/download/raspberrypi.zip
unzip blog-server.zip -d /home/pi/blog-server
chmod +x /home/pi/blog-server/blog-server
rm -f blog-server.zip
echo "Done"

echo "Setting up system-stats-dashboard systemd service..."
wget -O systemstatsdashboard.service https://github.com/rotoclone/raspberry-pi-stuff/raw/master/systemd/systemstatsdashboard.service
mv systemstatsdashboard.service /etc/systemd/system/
echo "Done"

echo "Setting up blog-server systemd service..."
wget -O blogserver.service https://github.com/rotoclone/raspberry-pi-stuff/raw/master/systemd/blogserver.service
mv blogserver.service /etc/systemd/system/
echo "Done"

echo "Setting up nginx config..."
wget -O rotoclone.zone.conf https://github.com/rotoclone/raspberry-pi-stuff/raw/master/nginx/rotoclone.zone.conf
mv rotoclone.zone.conf /etc/nginx/conf.d/
echo "Done"

# run certbot so it sets up the auto-renew stuff
echo "Running certbot..."
certbot --nginx -d rotoclone.zone -d www.rotoclone.zone
echo "Done"

echo "Enabling services..."
systemctl daemon-reload
systemctl enable ssh
systemctl enable nginx
systemctl enable docker
systemctl enable systemstatsdashboard
systemctl enable blogserver
echo "Done"

echo "Success! Rebooting..."
reboot
