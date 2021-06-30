FROM datadrone/spark-submit:3.1.1-hadoop3.2-rapids

COPY entrypoint.sh /entrypoint.sh

COPY log4j.properties /spark/conf/log4j.properties

CMD ["/bin/bash", "/entrypoint.sh"]
