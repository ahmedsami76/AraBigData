FROM ubuntu:latest as stage0

LABEL maintainer="ahmed.sami@yahoo.com"
LABEL desc="A test multi-stage Dockerfile to build Hadoop 3 image"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        wget sudo openssh-server openssh-client \
    && apt-get -y upgrade 

FROM stage0 AS stage1 

ARG user=hduser

ARG home=/home/$user

RUN useradd --create-home -s /bin/bash $user \
        && echo $user:ubuntu | chpasswd \
        && adduser $user sudo \
        && groupadd hadoop \
        && usermod -a -G hadoop $user

RUN echo '$user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN sudo echo root:"H@doop2022" | chpasswd


FROM stage1 AS stage2 

USER $user 

WORKDIR /usr/local


ADD 'https://files-cdn.liferay.com/mirrors/download.oracle.com/otn-pub/java/jdk/8u221-b11/jdk-8u221-linux-x64.tar.gz' /usr/local
RUN sudo tar -xzvf jdk-8u221-linux-x64.tar.gz
RUN sudo mv jdk1.8.0_221/ java 

USER $user 
ENV JAVA_HOME="/usr/local/java" 
ENV PATH="/usr/local/java/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
RUN echo "PATH=/usr/local/java/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games" > /etc/environment

USER $user 
RUN sudo update-alternatives --install "/usr/bin/java" "java" "/usr/local/java/bin/java" 1
RUN sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/local/java/bin/javac" 1
RUN sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/local/java/bin/javaws" 1
 
RUN sudo update-alternatives --set java /usr/local/java/bin/java
RUN sudo update-alternatives --set javac /usr/local/java/bin/javac
RUN sudo update-alternatives --set javaws /usr/local/java/bin/javaws

RUN sudo apt-get update && apt-get install -y ssh rsync
RUN sudo services ssh restart 

RUN sudo -u hduser ssh-keygen -q -t rsa -N '' -f /home/hduser/.ssh/id_rsa
RUN sudo -u hduser cat /home/hduser/.ssh/id_rsa.pub >> /home/hduser/.ssh/authorized_keys
RUN sudo chmod og-wx /home/hduser/.ssh/authorized_keys
RUN sudo apt-get update

#######

FROM stage2 AS stage3

WORKDIR /usr/local
ADD 'https://dlcdn.apache.org/hadoop/common/hadoop-3.3.1/hadoop-3.3.1.tar.gz' /usr/local/
RUN sudo tar xzvf hadoop-3.3.1.tar.gz
RUN sudo mv hadoop-3.3.1 hadoop

RUN sudo chown -R hduser:hadoop /usr/local/hadoop
RUN sudo chmod -R 777 /usr/local/hadoop

USER $user

ENTRYPOINT [ "/bin/bash", "-c" ]

