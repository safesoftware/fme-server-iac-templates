#!/bin/bash
cd /
apt-get update
apt-get install -y zip unzip
apt-get install -y git binutils make
git clone https://github.com/aws/efs-utils
cd efs-utils
make deb
apt-get install -y ./build/amazon-efs-utils*deb
cd /mnt
mkdir efs
cd efs
mkdir fs1
mount -t efs -o tls ${efs}:/ fs1
chmod 777 fs1
cd fs1
printf "FEATURE_FMEServerDatabase_INSTALL=No\n" > install_engine.cfg
printf "FEATURE_Services_INSTALL=No\n" >> install_engine.cfg
printf "FEATURE_ServerConsole_INSTALL=No\n" >> install_engine.cfg
printf "FEATURE_FMEServerDatabase_INSTALL=No\n" >> install_engine.cfg
dns=$(curl http://169.254.169.254/latest/meta-data/public-hostname)
printf "NODENAME=%s\n" $dns >> install_engine.cfg
printf "FMESERVERHOSTNAME=${eip}\n" >> install_engine.cfg
printf "FMESERVERSHAREDDATA=/mnt/efs/fs1/fmeserver\n" >> install_engine.cfg
printf "DATABASETYPE=PostGreSQL\n" >> install_engine.cfg
printf "DATABASEHOST=${rdsAddress}\n" >> install_engine.cfg
printf "DATABASEPORT=${rdsPort}\n" >> install_engine.cfg
printf "DATABASEUSER=fmeserver\n" >> install_engine.cfg
printf "DATABASEPASSWORD=fmeserver" >> install_engine.cfg
sleep 600
chmod +x ./fme-server-2021.1.3-b21631-linux~ubuntu.20.04.run
ls
chown fmeserver /mnt/efs/fs1/fmeserver
mkdir /usr/share/desktop-directories/
mkdir /opt/fmeserver/
chmod 777 /opt/fmeserver/
./fme-server-2021.1.3-b21631-linux~ubuntu.20.04.run -- --file install_engine.cfg
cd /opt/fmeserver/Server
sed -i '/^TEMPLATE_START_ENGINE=/ s/$/ -ENGINE_TYPE DYNAMIC/' processMonitorConfigEngines.txt
./startEngines.sh