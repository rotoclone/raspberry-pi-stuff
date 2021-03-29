# exit on error
set -e

mkdir ~/setup
cd ~/setup

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
usermod -aG docker pi
wget -O /etc/docker/daemon.json https://github.com/rotoclone/raspberry-pi-stuff/raw/master/docker/daemon.json
echo "Done"

## begin umami stuff
echo "Installing protobuf..."
apt-get install protobuf-compiler
echo "Done"

echo "Increasing swapfile size...
#TODO update /etc/dphys-swapfile
/etc/init.d/dphys-swapfile restart
echo "Done"

echo "Building prisma..."
git clone https://github.com/prisma/prisma-engines.git
cd prisma-engines
source ./.envrc
cargo build --release
cd ..
echo "Done"

echo "Installing umami..."
git clone https://github.com/mikecao/umami.git
#TODO add prisma/.env
#TODO update dockerfile
#TODO update docker-compose
cp prisma-engines/target/release/query-engine umami/prisma-binaries/
cp prisma-engines/target/release/introspection-engine umami/prisma-binaries/
cp prisma-engines/target/release/migration-engine umami/prisma-binaries/
cp prisma-engines/target/release/prisma-fmt umami/prisma-binaries/
cd umami
/usr/bin/docker build -t armumami . --network=host
/home/pi/.local/bin/docker-compose up -d
cd ..
echo "Done"
## end umami stuff

## begin shynet stuff
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
wget -O shynet/docker-compose.yml https://github.com/rotoclone/raspberry-pi-stuff/raw/master/shynet/docker-compose.yml
wget -O shynet/Dockerfile https://github.com/rotoclone/raspberry-pi-stuff/raw/master/shynet/Dockerfile
cd shynet
/usr/bin/docker build -t armshynet . --network=host
/home/pi/.local/bin/docker-compose up -d
cd ..
docker exec -it shynet_main ./manage.py registeradmin rotoclone@example.com
docker exec -it shynet_main ./manage.py hostname analytics.rotoclone.zone
echo "Done"
## end shynet stuff

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
systemctl enable docker
systemctl enable systemstatsdashboard
systemctl enable blogserver
echo "Done"

echo "Success! Rebooting..."
reboot
