SERVICE_NAME=systemstatsdashboard
BINARY_NAME=system-stats-dashboard
GIT_DIR=/home/pi/git/${BINARY_NAME}
TARGET_DIR=/home/pi/${BINARY_NAME}

systemctl stop $SERVICE_NAME
rm -rf $TARGET_DIR
mkdir $TARGET_DIR
cp ${GIT_DIR}/target/release/${BINARY_NAME} ${TARGET_DIR}/
cp ${GIT_DIR}/Rocket.toml ${TARGET_DIR}/
cp -r ${GIT_DIR}/templates ${TARGET_DIR}/
systemctl start $SERVICE_NAME
