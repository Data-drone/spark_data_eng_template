FROM openjdk:8u242-jre

RUN mkdir /tmp/hive
RUN chmod 777 /tmp/hive

WORKDIR /opt

ENV HADOOP_VERSION=3.2.0
ENV METASTORE_VERSION=2.3.7

ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV HIVE_HOME=/opt/apache-hive-${METASTORE_VERSION}-bin

# RUN curl -L https://www-us.apache.org/dist/hive/hive-standalone-metastore-${METASTORE_VERSION}/hive-standalone-metastore-${METASTORE_VERSION}-bin.tar.gz | tar zxf - && \
RUN curl -L https://archive.apache.org/dist/hive/hive-${METASTORE_VERSION}/apache-hive-${METASTORE_VERSION}-bin.tar.gz | tar zxf - && \
    curl -L https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar zxf - && \
    curl https://jdbc.postgresql.org/download/postgresql-42.2.20.jar --output postgresql-42.2.20.jar && \
    cp postgresql-42.2.20.jar ${HIVE_HOME}/lib/ && \
    rm -rf  postgresql-42.2.20.jar

COPY conf/hive-site.xml ${HIVE_HOME}/conf
COPY entrypoint.sh /entrypoint.sh
COPY metastore.sh /metastore.sh
COPY healthcheck.sh /healthcheck_metastore.sh


RUN groupadd -r hive --gid=1000 && \
    useradd -r -g hive --uid=1000 -d ${HIVE_HOME} hive && \
    chown hive:hive -R ${HIVE_HOME} && \
    chown hive:hive /entrypoint.sh && chmod +x /entrypoint.sh && \
    chown hive:hive /metastore.sh && chmod +x /metastore.sh && \
    chown hive:hive /healthcheck_metastore.sh && chmod +x /healthcheck_metastore.sh 


RUN apt-get update && apt-get install -y procps net-tools

RUN mkdir /opt/auxjars && \
    chmod 777 /opt/auxjars && \
    curl https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.2.0/hadoop-aws-3.2.0.jar --output /opt/auxjars/hadoop-aws-3.2.0.jar 

USER hive
EXPOSE 9083
EXPOSE 10000
EXPOSE 10002

#ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]