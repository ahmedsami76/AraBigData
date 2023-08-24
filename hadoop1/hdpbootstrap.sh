#!/bin/bash
# bootstrapping Hadoop
#
apt-get update
apt-get -y upgrade
apt-get -y install wget curl rsync openssh-server openssh-client
apt-get update --allow-unauthenticated --allow-insecure-repositories
#
cd /usr/local
#
update-alternatives --install "/usr/bin/java" "java" "/usr/local/openjdk-8/bin/java" 1
update-alternatives --install "/usr/bin/javac" "javac" "/usr/local/openjdk-8/bin/javac" 1
update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/local/openjdk-8/bin/javaws" 1
#
update-alternatives --set java /usr/local/openjdk-8/bin/java
update-alternatives --set javac /usr/local/openjdk-8/bin/javac
update-alternatives --set javaws /usr/local/jaopenjdk-8va/bin/javaws
#
ufw disable
#
service ssh restart
#
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod og-wx ~/.ssh/authorized_keys
#
apt-get update 
#
cd /usr/local
wget 'https://dlcdn.apache.org/hadoop/common/hadoop-3.3.1/hadoop-3.3.1.tar.gz'
tar xzvf hadoop-3.3.1.tar.gz
mv hadoop-3.3.1 hadoop
chmod -R 777 /usr/local/hadoop
chmod +x /usr/local/hduser
echo 'net.ipv6.conf.all.disable_ipv6=1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.default.disable_ipv6=1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.lo.disable_ipv6=1' >> /etc/sysctl.conf
#
cd /usr/local/hadoop/etc/hadoop
#
echo 'export HADOOP_OPTS=-Djava.net.preferIPv4Stack=true' >> hadoop-env.sh
echo 'export JAVA_HOME=/usr/local/openjdk-8' >> hadoop-env.sh
echo 'export HADOOP_HOME_WARN_SUPPRESS="TRUE"' >> hadoop-env.sh
echo 'export HADOOP_ROOT_LOGGER="WARN,DRFA"' >> hadoop-env.sh
#
# also add the following when installing in docker container for root user
echo 'export HDFS_NAMENODE_USER="root"' >> hadoop-env.sh
echo 'export HDFS_DATANODE_USER="root"' >> hadoop-env.sh
echo 'export HDFS_SECONDARYNAMENODE_USER="root"' >> hadoop-env.sh
echo 'export YARN_RESOURCEMANAGER_USER="root"' >> hadoop-env.sh
echo 'export YARN_NODEMANAGER_USER="root"' >> hadoop-env.sh

cd /usr/local
cp -f ./src/* /usr/local/hadoop/etc/hadoop/
#
mkdir -p /app/hadoop/tmp
chmod -R 777 /app/hadoop/tmp
#
mkdir -p /usr/local/hadoop/yarn_data/hdfs/namenode
mkdir -p /usr/local/hadoop/yarn_data/hdfs/datanode
chmod -R 777 /usr/local/hadoop/yarn_data/hdfs/namenode
chmod -R 777 /usr/local/hadoop/yarn_data/hdfs/datanode
#
source ~/.bashrc

stop-all.sh
rm -Rf /app/hadoop/tmp/*
rm -Rf /usr/local/hadoop/yarn_data/hdfs/namenode/*
rm -Rf /usr/local/hadoop/yarn_data/hdfs/datanode/*
#
hdfs namenode -format -force