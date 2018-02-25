-- COPY command to load Jan 2009 data into the table
COPY nyc_yellow_taxi_data
FROM 's3://indu-s-bhagavatula-us-east-1/git/redshift/bad-interleaved-sk/cleansed-sampled/yellow_tripdata_2009-01.csv'
IAM_ROLE 'arn:aws:iam::724196782322:role/rs-s3access'
DELIMITER ','
STATUPDATE ON
COMPUPDATE OFF
IGNOREHEADER 1
TIMEFORMAT 'auto'
;

-- Check table stats
select "table" as table, table_id, tbl_rows, unsorted, stats_off, size from SVV_TABLE_INFO where "table"='nyc_yellow_taxi_data';
-- Check SVV_INTERLEAVED_COLUMNS
select tbl, col, interleaved_skew, last_reindex FROM SVV_INTERLEAVED_COLUMNS where tbl=<tableid> order by col;
