#!/bin/bash

## Upload necessary files to HDFS
echo " Uploading files to HDFS"
echo
hdfs dfs -mkdir -p /case_study /case_study/not_optimized

hdfs dfs -put -f ${0%/*/*}/hive /case_study
hdfs dfs -put -f ${0%/*/*}/not_optimized/oozie /case_study/not_optimized


## Run Oozie Coordinator
echo " Preparing oozie job"
echo
oozie job -oozie http://localhost:11000/oozie  -config  ${0%/*/*}/not_optimized/oozie/non_optimal_job_properties.properties  -run
