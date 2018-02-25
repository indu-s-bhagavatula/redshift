## Modules
Without any changes this module can be run on a single node dc1.large and dc2.large cluster.
Need to have a SQL client to connect to the cluster to run the statements on the cluster.

### [dataprep](dataprep)
Python module to download, sample NYC dataset files and push them to the desired S3 bucket. The files saved on S3 bucket can be used to ingest data into Redshift cluster.  

### [analysis](analysis)
Example and observations on an INTERLEAVED SORTKEY table with a timestamp column that keeps changing with every using the data set prepared by sampling NYC Taxi dataset.
