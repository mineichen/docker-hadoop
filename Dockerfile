FROM java:8-jdk-alpine

ENV HADOOP_VERSION 2.6.0
ENV HADOOP_HOME /usr/local/hadoop

ENV HADOOP_COMMON_HOME ${HADOOP_HOME}
ENV HADOOP_YARN_HOME ${HADOOP_HOME}
ENV HADOOP_HDFS_HOME ${HADOOP_HOME}
ENV HADOOP_MAPRED_HOME ${HADOOP_HOME}
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/etc/hadoop

RUN set -xe \
  && apk add --no-cache --virtual .build-deps \
                gnupg \
                bash \
                curl \
                openssh \
  && export GNUPGHOME="$(mktemp -d)" \
  && mkdir -p /usr/local/hadoop \
  && mkdir -p /root/build \
  && mkdir /hdfs/ \
  && cd /root/build \
  && curl -fSL http://mirror.switch.ch/mirror/apache/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz \
  		-o hadoop.tar.gz \
  && curl -fSL https://dist.apache.org/repos/dist/release/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz.asc \
  		-o hadoop.tar.gz.asc \
  && curl -fSL https://dist.apache.org/repos/dist/release/hadoop/common/KEYS \
  		-o hadoop.tar.gz.mds \
  && gpg --import hadoop.tar.gz.mds \ 
  && gpg --batch --verify hadoop.tar.gz.asc hadoop.tar.gz \
  && tar -zxf hadoop.tar.gz \
  && mv hadoop-$HADOOP_VERSION/* /usr/local/hadoop/ \
  && cd / \
  && rm -rf /root/build \
  && addgroup -S supergroup \
  && adduser -S -D -G supergroup hdfs \
  && adduser -S -D -G supergroup oozie \
  && adduser -S -D -G supergroup spark \
  && adduser -S -D -G supergroup hue \
  && adduser -S -D -G supergroup hive \
  && chown -R hdfs:supergroup /hdfs

