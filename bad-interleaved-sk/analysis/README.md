### Redshift INTERLEAVED SORTKEY
Redshift INTERLEAVED SORTKEY allows data to be sorted on equal measures on multiple columns allowing less number of blocks to be scanned at runtime even if the columns appear independently of each other.
However, the way INTERLEAVED SORTKEY tables are built makes it not useful when the column(s) domain values are not stable (keep changing with every load).

### Demonstration
Crete table to load sampled NYC taxi dataset for different months.
INTERLEAVED SORTKEY is defined on the columns that include trip_pickup_datetime which changes for every month.
```sql
create table nyc_yellow_taxi_data (
   vendor_name varchar(10)
  ,trip_pickup_datetime datetime
  ,trip_dropoff_datetime datetime
  ,passenger_count smallint
  ,trip_distance real
  ,start_lon real
  ,start_lat real
  ,rate_code real
  ,store_and_forward varchar(5)
  ,end_lon real
  ,end_lat real
  ,payment_type varchar(20)
  ,fare_amt real
  ,surcharge real
  ,mta_tax real
  ,tip_amt real
  ,tolls_amt real
  ,total_amt real
)
INTERLEAVED SORTKEY (trip_pickup_datetime,start_lat,start_lon);
);
```
Run the COPY to load Jan 2009 data.
```sql
COPY nyc_yellow_taxi_data
FROM '<s3 complete path to the object containing Jan 2009>'
IAM_ROLE '<arn of IAM Role attached to the cluster>'
DELIMITER ','
STATUPDATE ON
COMPUPDATE OFF
IGNOREHEADER 1
TIMEFORMAT 'auto'
;
```
Check the stats of the table.
```sql
select "table" as table, table_id, tbl_rows, unsorted, stats_off, size from SVV_TABLE_INFO where "table"='nyc_yellow_taxi_data';
```
|table         | table_id | tbl_rows | unsorted | stats_off | size |
|----------------------|----------|----------|----------|-----------|------|
|nyc_yellow_taxi_data |   100188 |     9998 |     0.00 |      0.00 |   84|

Check SVV_INTERLEAVED_COLUMNS with the table_id from the above query.
```sql
select tbl, col, interleaved_skew, last_reindex FROM SVV_INTERLEAVED_COLUMNS where tbl=<tableid> order by col;
```
|tbl   | col | interleaved_skew | last_reindex |
|--------|-----|------------------|--------------|
|100168 |   1 |             1.33 | |
|100168 |   5 |             1.64 | |
|100168 |   6 |             1.54 | |

** Analysis: **
Redshift established a mapping and distributed data into different buckets for available combinations (trip_pickup_datetime,start_lat,start_lon) from the records available in the specified file.
And the table is 100% sorted.

COPY command to load data Feb 2009 into the table
```sql
COPY nyc_yellow_taxi_data
FROM '<s3 complete path to the object containing Feb 2009>'
IAM_ROLE '<arn of IAM Role attached to the cluster>'
DELIMITER ','
STATUPDATE ON
COMPUPDATE OFF
IGNOREHEADER 1
TIMEFORMAT 'auto'
;
```
Check table stats after loading Feb 2009 data

```sql
select "table" as table, table_id, unsorted, stats_off, size from SVV_TABLE_INFO where "table"='nyc_yellow_taxi_data';
```
|table         | table_id | tbl_rows | unsorted | stats_off | size |
|----------------------|----------|----------|----------|-----------|------|
|nyc_yellow_taxi_data |   100188 |    19996 |    50.00 |      0.00 |   84|

Check SVV_INTERLEAVED_COLUMNS
```sql
select tbl, col, interleaved_skew, last_reindex FROM SVV_INTERLEAVED_COLUMNS where tbl=<tableid> order by col;
```
|tbl   | col | interleaved_skew | last_reindex |
|--------|-----|------------------|--------------|
|100188 |   1 |           512.61 | |
|100188 |   5 |             2.97 | |
|100188 |   6 |             3.94 | |

** Analysis: **
All of the Feb 2009 data was loaded in the "others" bucket because the records loaded don't match to any of the existing combinations recognized by mapping established while loading Jan 2009.

The same will continue to happen when loading Mar 2009 and Apr 2009 data.
```sql
-- COPY command to Mar 2009 load data into the table
COPY nyc_yellow_taxi_data
FROM '<s3 complete path to the object containing Mar 2009>'
IAM_ROLE '<arn of IAM Role attached to the cluster>'
DELIMITER ','
STATUPDATE ON
COMPUPDATE OFF
IGNOREHEADER 1
TIMEFORMAT 'auto'
;

-- COPY command to Apr 2009 load data into the table
COPY nyc_yellow_taxi_data
FROM '<s3 complete path to the object containing Apr 2009>'
IAM_ROLE '<arn of IAM Role attached to the cluster>'
DELIMITER ','
STATUPDATE ON
COMPUPDATE OFF
IGNOREHEADER 1
TIMEFORMAT 'auto'
;
```

Check table stats after loading Mar and Apr 2009 data
```sql
select "table" as table, table_id, tbl_rows, unsorted, stats_off, size from SVV_TABLE_INFO where "table"='nyc_yellow_taxi_data';
```
|table         | table_id | tbl_rows | unsorted | stats_off | size |
|----------------------|----------|----------|----------|-----------|------|
|nyc_yellow_taxi_data |   100188 |    39992 |    75.00 |      0.00 |   84|

Check SVV_INTERLEAVED_COLUMNS with the table_id from the above query.
```sql
select tbl, col, interleaved_skew, last_reindex FROM SVV_INTERLEAVED_COLUMNS where tbl=<tableid> order by col;
```
|tbl   | col | interleaved_skew | last_reindex |
|--------|-----|------------------|--------------|
|100188 |   1 |           768.31 | |
|100188 |   6 |             2.51 | |

** Analysis: **
The records loaded for Mar and Apr 2009 have also been loaded into "others" bucket and hence % data in unsorted region is 75%.

### VACUUM REINDEX
To consolidate the data in the sorted region VACUUM REINDEX the table.
```sql
VACUUM REINDEX nyc_yellow_taxi_data;
```
Check the stats of the table.
```sql
select "table" as table, table_id, tbl_rows, unsorted, stats_off, size from SVV_TABLE_INFO where "table"='nyc_yellow_taxi_data';
```
|table         | table_id | tbl_rows | unsorted | stats_off | size |
|----------------------|----------|----------|----------|-----------|------|
|nyc_yellow_taxi_data |   100188 |    49990 |     0.00 |      0.00 |   84|

Check SVV_INTERLEAVED_COLUMNS with the table_id from the above query.
```sql
select tbl, col, interleaved_skew, last_reindex FROM SVV_INTERLEAVED_COLUMNS where tbl=<tableid> order by col;
```
tbl   | col | interleaved_skew | last_reindex
--------+-----+------------------+--------------
|100188 |   1 |             1.47 | 2018-02-25 13:10:04.845083|
|100188 |   5 |             1.50 | 2018-02-25 13:10:04.845083|
|100188 |   6 |             1.45 | 2018-02-25 13:10:04.845083|

** Analysis: **
VACUUM REINDEX on the table built a new mapping using all the existing active records and redistributed the data into 1024 buckets.
The process on tables involving billions of records will be an expensive operation.

### Conclusion
It is not a good practice to have a column whose value is likely to change with every load to be used as a candidate for INTERLEAVED SORTKEY as the data with every new load ends up in "others" bucket/unsorted region requiring VACUUM REINDEX (expensive operation) to consolidate data.
Example: Timestatmps or ID fields such as OrderID, TransactionID that keep changing.
