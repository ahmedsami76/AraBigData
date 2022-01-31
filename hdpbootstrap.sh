#!/bin/bash
# bootstrapping Hadoop
#
apt update
apt -y upgrade
apt -y install wget curl rsync openssh-server openssh-client
apt update --allow-unauthenticated --allow-insecure-repositories
#
cd /usr/local
wget 'https://files-cdn.liferay.com/mirrors/download.oracle.com/otn-pub/java/jdk/8u221-b11/jdk-8u221-linux-x64.tar.gz'
tar -xzvf jdk-8u221-linux-x64.tar.gz
mv jdk1.8.0_221/ java 
#
export JAVA_HOME=/usr/local/java
export PATH=:$PATH:/usr/local/java/bin
#
update-alternatives --install "/usr/bin/java" "java" "/usr/local/java/bin/java" 1
update-alternatives --install "/usr/bin/javac" "javac" "/usr/local/java/bin/javac" 1
update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/local/java/bin/javaws" 1
#
update-alternatives --set java /usr/local/java/bin/java
update-alternatives --set javac /usr/local/java/bin/javac
update-alternatives --set javaws /usr/local/java/bin/javaws
#
ufw disable
#
service ssh restart
#
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod og-wx ~/.ssh/authorized_keys
#
apt update 
#
cd /usr/local
wget 'https://dlcdn.apache.org/hadoop/common/hadoop-3.3.1/hadoop-3.3.1.tar.gz'
tar xzvf hadoop-3.3.1.tar.gz
mv hadoop-3.3.1 hadoop
chmod -R 777 /usr/local/hadoop
#
echo 'net.ipv6.conf.all.disable_ipv6=1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.default.disable_ipv6=1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.lo.disable_ipv6=1' >> /etc/sysctl.conf
echo "export HADOOP_HOME=/usr/local/hadoop" >> ~/.bashrc
echo "export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop" >> ~/.bashrc
echo "export HADOOP_MAPRED_HOME=/usr/local/hadoop" >> ~/.bashrc
echo "export HADOOP_COMMON_HOME=/usr/local/hadoop" >> ~/.bashrc
echo "export HADOOP_HDFS_HOME=/usr/local/hadoop" >> ~/.bashrc
echo "export YARN_HOME=/usr/local/hadoop" >> ~/.bashrc
echo "export PATH=$PATH:/usr/local/hadoop/bin"  >> ~/.bashrc
echo "export PATH=$PATH:/usr/local/hadoop/sbin" >> ~/.bashrc
echo "export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native" >> ~/.bashrc
echo "export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib" >> ~/.bashrc
#
cd /usr/local/hadoop/etc/hadoop
#
echo 'export HADOOP_OPTS=-Djava.net.preferIPv4Stack=true' >> hadoop-env.sh
echo 'export JAVA_HOME=/usr/local/java' >> hadoop-env.sh
echo 'export HADOOP_HOME_WARN_SUPPRESS="TRUE"' >> hadoop-env.sh
echo 'export HADOOP_ROOT_LOGGER="WARN,DRFA' >> hadoop-env.sh
#
# also add the following when installing in docker container for root user
echo 'export HDFS_NAMENODE_USER="root"' >> hadoop-env.sh
echo 'export HDFS_DATANODE_USER="root"' >> hadoop-env.sh
echo 'export HDFS_SECONDARYNAMENODE_USER="root"' >> hadoop-env.sh
echo 'export YARN_RESOURCEMANAGER_USER="root"' >> hadoop-env.sh
echo 'export YARN_NODEMANAGER_USER="root"' >> hadoop-env.sh
#
#stop-all.sh
#rm -Rf /app/hadoop/tmp/*
#rm -Rf /usr/local/hadoop/yarn_data/hdfs/namenode/*
#rm -Rf /usr/local/hadoop/yarn_data/hdfs/datanode/*
#
#hdfs namenode -format -force
#start-all.sh