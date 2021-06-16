# spark_data_eng_template
The datalake portion of my opensource ml platform


## Todo

# Known Issues
## Thrift Issues
Get the Spark Thrift Server started for odbc connections integrated as part of it
-- issues with SASL
    -- added hiveconf hive.server2.authentication=NOSASL

This is due to thrift sasl and python interdepencies. thift libs are not well maintained and some don't work properly with python3.

See: https://github.com/dropbox/PyHive/issues/380 for some reference
Note that windows has extra thrift sasl issues on top of the ones linux users see.
 

```python

from pyhive import hive

# run a query with nonsasl
cursor = hive.connect(host='172.30.0.8', auth='NOSASL').cursor()
cursor.execute("""SHOW DATABASES""")
print(cursor.fetchall())

```


