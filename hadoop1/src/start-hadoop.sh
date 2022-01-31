#!/bin/bash
# Starting Hadoop services
#
service ssh start 
start-all.sh 
hdfs dfs -chmod -R 1777 /
bash 
