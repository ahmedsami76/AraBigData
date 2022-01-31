FROM library/openjdk:8

WORKDIR /usr/local

COPY hdpbootstrap.sh .
COPY ./src  ./src

ENV JAVA_HOME="/usr/local/java"
ENV PATH="/usr/local/java/bin:${PATH}"
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop
ENV HADOOP_MAPRED_HOME=/usr/local/hadoop
ENV HADOOP_COMMON_HOME=/usr/local/hadoop
ENV HADOOP_HDFS_HOME=/usr/local/hadoop
ENV YARN_HOME=/usr/local/hadoop
ENV PATH="/usr/local/hadoop/bin:${PATH}"
ENV PATH="/usr/local/hadoop/sbin::${PATH}"
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
ENV HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"

RUN chmod +x hdpbootstrap.sh
RUN chmod +x ./src/start-hadoop.sh
RUN bash hdpbootstrap.sh

ENTRYPOINT [ "/bin/bash","-c" ]
CMD [ "./src/start-hadoop.sh" ]