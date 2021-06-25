FROM openjdk:8u242-jre

RUN apt-get update && apt-get -y upgrade && \
        apt install -y net-tools gettext-base

WORKDIR /opt

ENV HADOOP_VERSION=3.2.0
ENV METASTORE_VERSION=3.0.0

ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV HIVE_HOME=/opt/apache-hive-metastore-${METASTORE_VERSION}-bin

RUN curl -L https://www-us.apache.org/dist/hive/hive-standalone-metastore-${METASTORE_VERSION}/hive-standalone-metastore-${METASTORE_VERSION}-bin.tar.gz | tar zxf - && \
    curl -L https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar zxf - && \
    curl https://jdbc.postgresql.org/download/postgresql-42.2.20.jar --output postgresql-42.2.20.jar && \
    cp postgresql-42.2.20.jar ${HIVE_HOME}/lib/ && \
    rm -rf  postgresql-42.2.20.jar

COPY conf/metastore-site.xml.j2 ${HIVE_HOME}/conf
COPY conf/configure.sh ${HIVE_HOME}/conf

RUN chmod u+x ${HIVE_HOME}/conf/configure.sh

COPY scripts/entrypoint.sh /entrypoint.sh

RUN groupadd -r hive --gid=1000 && \
    useradd -r -g hive --uid=1000 -d ${HIVE_HOME} hive && \
    chown hive:hive -R ${HIVE_HOME} && \
    chown hive:hive /entrypoint.sh && chmod +x /entrypoint.sh

RUN rm ${HIVE_HOME}/conf/metastore-site.xml

USER hive
EXPOSE 9083

ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]