#!/bin/bash
cd /
apt-get update
apt-get install -y zip unzip
apt-get install -y git binutils make
apt-get install -y postgresql-client
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
printf "FEATURE_FMEServerDatabase_INSTALL=No\n" > install.cfg
printf "FMESERVERHOSTNAME=${eip}\n" >> install.cfg
printf "FMESERVERSHAREDDATA=/mnt/efs/fs1/fmeserver\n" >> install.cfg
printf "DATABASETYPE=PostGreSQL\n" >> install.cfg
printf "DATABASEHOST=${rdsAddress}\n" >> install.cfg
printf "DATABASEPORT=${rdsPort}\n" >> install.cfg
printf "DATABASEUSER=fmeserver\n" >> install.cfg
printf "DATABASEPASSWORD=fmeserver" >> install.cfg
mkdir fmeserver
chmod 777 fmeserver
chown fmeserver /mnt/efs/fs1/fmeserver
wget https://downloads.safe.com/fme/2021/fme-server-2021.1.3-b21631-linux~ubuntu.20.04.run
mkdir /usr/share/desktop-directories/
chmod +x ./fme-server-2021.1.3-b21631-linux~ubuntu.20.04.run
./fme-server-2021.1.3-b21631-linux~ubuntu.20.04.run -- --file install.cfg
cd /opt/fmeserver/Server/database/postgresql
export PGPASSWORD='postgres'; psql -U postgres -d postgres -h ${rdsAddress} -p ${rdsPort} -c "CREATE USER fmeserver WITH PASSWORD 'fmeserver';" &> createUserLog.txt
export PGPASSWORD='postgres'; psql -U postgres -d postgres -h ${rdsAddress} -p ${rdsPort} -f postgresql_createDB.sql &> createDBLog.txt
export PGPASSWORD='fmeserver'; psql -U fmeserver -d fmeserver -h ${rdsAddress} -p ${rdsPort} -f postgresql_createSchema.sql &> createSchemaLog.txt
cd /opt/fmeserver/Server
./startServer.sh