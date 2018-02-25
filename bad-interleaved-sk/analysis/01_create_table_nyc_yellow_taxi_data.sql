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
