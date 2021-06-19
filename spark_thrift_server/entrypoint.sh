#!/bin/bash

/spark/bin/spark-submit --master ${SPARK_MASTER} \
    --class ${SPARK_APPLICATION_MAIN_CLASS} \
    --hiveconf hive.server2.authentication=NOSASL \
    --executor-memory 4G \
    --total-executor-cores 4 \
    --packages="io.delta:delta-core_2.12:1.0.0,org.apache.hadoop:hadoop-aws:3.2.0" \
    --conf spark.hadoop.fs.s3a.access.key=${MINIO_ACCESS_KEY} \
    --conf spark.hadoop.fs.s3a.secret.key=${MINIO_SECRET_KEY} \
    --conf spark.hadoop.fs.s3a.endpoint=minio:9000 \
    --conf spark.hadoop.fs.s3a.connection.ssl.enabled=false \
    --conf spark.hadoop.fs.impl=org.apache.hadoop.fs.s3a.S3AFileSystem \
    --conf spark.sql.warehouse.dir=s3a://storage/warehouse \
    --conf spark.hadoop.fs.s3a.path.style.access=true \
    --conf spark.hive.metastore.uris=thrift://172.30.0.4:9083 \
    /