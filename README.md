# spark_data_eng_template
The datalake portion of my opensource ml platform

Copy of the `.env.template`, rename to .env and change parameters as required

## TODO

- Still need to work out why we need to define the ipaddress for HiveMetastore
- Look into users and permissions
  -- We created a database/schema using jovyan user a table was then written into it using root user. After that was not able to access the table

## Thrift Issues

Thrift runs as a Spark Application that means that it will reserve a portion of the resources on the cluster for itself restricting other applications from using it.

Get the Spark Thrift Server started for odbc connections integrated as part of it
-- issues with SASL
    -- added hiveconf hive.server2.authentication=NOSASL

This is due to thrift sasl and python interdepencies. thift libs are not well maintained and some don't work properly with python3.

See: https://github.com/dropbox/PyHive/issues/380 for some reference
Note that windows has extra thrift sasl issues on top of the ones linux users see.
 

```python

from pyhive import hive

# run a query with nonsasl
cursor = hive.connect(host='spark-thrift-server', auth='NOSASL').cursor()
cursor.execute("""SHOW DATABASES""")
print(cursor.fetchall())

```

```python

from sqlalchemy import *
from sqlalchemy.engine import create_engine
from sqlalchemy.schema import *
from sqlalchemy import text

engine = create_engine('hive://spark-thrift-server:10000/default?auth=NOSASL')
result = engine.execute(f'show databases')
for row in result:
    print(row)

```
For notebook environments need to:

```bash
conda install sasl
```
in order to make sure that sasl installs correctly