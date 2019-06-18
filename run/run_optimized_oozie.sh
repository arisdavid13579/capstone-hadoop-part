#!/bin/bash

## Upload necessary files to HDFS
echo ' Uploading files to HDFS'
echo
hdfs dfs -mkdir -p /case_study /case_study/optimized

hdfs dfs -put -f ${0%/*/*}/hive /case_study
hdfs dfs -put -f ${0%/*/*}/optimized/oozie /case_study/optimized

## Open Metastore
echo ' Opening metastore'
echo
sqoop-metastore --shutdown &> ${0%/*}/sqoop_output 
sleep 2
sqoop-metastore &>> ${0%/*}/sqoop_output &

## Run Oozie Coordinator
echo ' Preparing oozie job'
oozie job -oozie http://localhost:11000/oozie  -config  ${0%/*/*}/optimized/oozie/job_properties.properties  -run
