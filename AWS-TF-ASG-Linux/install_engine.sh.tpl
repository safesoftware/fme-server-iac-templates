#!/bin/bash
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
cd /opt/fmeserver/Config
cp ./values.yml ./values_og.yml
sed -i '/^enginetype/ s/".*"/"DYNAMIC"/' ./values.yml
sed -i '\|^repositoryserverrootdir| s|".*"|"/mnt/efs/fs1/fmeserver"|' ./values.yml
dns=$(curl http://169.254.169.254/latest/meta-data/public-hostname)
sed -i "/^nodename/ s/\".*\"/\"$dns\"/" ./values.yml
sed -i '/^fmeserverhostnamelocal/ s/".*"/"${eip}"/' ./values.yml
sed -i ',^pgsqlconnectionstring, s,".*","jdbc:postgresql://${rds}:fmeserver",' ./values.yml
cd confd
./confd -onetime -backend file -file ../values.yml -confdir .
cd /opt/fmeserver/Server
./startEngines.sh