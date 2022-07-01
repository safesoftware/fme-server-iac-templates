#!/bin/bash
cd /
apt-get update
sleep 10
apt-get install -y git binutils make postgresql-client
git clone https://github.com/aws/efs-utils
cd efs-utils
make deb
apt-get install -y ./build/amazon-efs-utils*deb
cd /mnt
mkdir efs
cd efs
mkdir fs1
chmod 777 fs1
mount -t efs -o tls ${efs}:/ fs1
cd fs1
folder=/mnt/efs/fs1/fmeserver
if [ ! -d "$folder" ]; then
    mkdir fmeserver
    chmod 777 fmeserver
fi
cd /opt/fmeserver/Config
cp ./values.yml ./values_og.yml
sed -i '\|^repositoryserverrootdir| s|".*"|"/mnt/efs/fs1/fmeserver"|' ./values.yml
dns=$(curl http://169.254.169.254/latest/meta-data/public-hostname)
sed -i "/^nodename/ s/\".*\"/\"$dns\"/" ./values.yml
sed -i "/^hostname/ s/\".*\"/\"$dns\"/" ./values.yml
sed -i "/^redishosts/ s/\".*\"/\"$dns\"/" ./values.yml
sed -i "/^fmeserverhostnamelocal/ s/\".*\"/\"$dns\"/" ./values.yml
sed -i "/^webserverhostname/ s/\".*\"/\"$dns\"/" ./values.yml
sed -i '\|^pgsqlconnectionstring| s|".*"|"jdbc:postgresql://${rds}/fmeserver"|' ./values.yml
cd confd
./confd -onetime -backend file -file ../values.yml -confdir .
cd /opt/fmeserver/Server/database/postgresql
file=/opt/fmeserver/Server/database/postgresql/createSchemaLog.txt
if [ ! -f "$file" ]; then
    export PGPASSWORD='postgres'; psql -U postgres -d postgres -h ${rdsAddress} -p ${rdsPort} -c "CREATE USER fmeserver WITH PASSWORD 'fmeserver';" &> createUserLog.txt
    export PGPASSWORD='postgres'; psql -U postgres -d postgres -h ${rdsAddress} -p ${rdsPort} -f postgresql_createDB.sql &> createDBLog.txt
    export PGPASSWORD='fmeserver'; psql -U fmeserver -d fmeserver -h ${rdsAddress} -p ${rdsPort} -f postgresql_createSchema.sql &> createSchemaLog.txt
fi
cd /opt/fmeserver/Utilities/tomcat/webapps/fmerest/WEB-INF/conf
sed -i 's/FME_SERVER_PORT_POOL=0/FME_SERVER_PORT_POOL=7200-7300/' propertiesFile.properties
cd /opt/fmeserver/Utilities/tomcat/webapps/fmedatadownload/WEB-INF/conf
sed -i 's/FME_SERVER_PORT_POOL=0/FME_SERVER_PORT_POOL=7200-7300/' propertiesFile.properties
cd /opt/fmeserver/Utilities/tomcat/webapps/fmedatastreaming/WEB-INF/conf
sed -i 's/FME_SERVER_PORT_POOL=0/FME_SERVER_PORT_POOL=7200-7300/' propertiesFile.properties
cd /opt/fmeserver/Utilities/tomcat/webapps/fmejobsubmitter/WEB-INF/conf
sed -i 's/FME_SERVER_PORT_POOL=0/FME_SERVER_PORT_POOL=7200-7300/' propertiesFile.properties
cd /opt/fmeserver/Utilities/tomcat/webapps/fmenotification/WEB-INF/conf
sed -i 's/FME_SERVER_PORT_POOL=0/FME_SERVER_PORT_POOL=7200-7300/' propertiesFile.properties
cd /mnt
folder=/mnt/efs/fs1/key
if [ ! -d "$folder" ]; then
    cp -R -v -i ./resources ./efs/fs1/fmeserver
    cp -R ./repositories ./efs/fs1/fmeserver
    cp -R ./localization ./efs/fs1/fmeserver
    cp -R ./licenses ./efs/fs1/fmeserver
    cp -R ./key ./efs/fs1/fmeserver
    chmod -R 777 ./efs/fs1/fmeserver
fi
cd /opt/fmeserver/Server
sed -i 's/FME_SERVER_PORT_POOL=0/FME_SERVER_PORT_POOL=7200-7300/' fmeServerConfig.txt
./startServer.sh