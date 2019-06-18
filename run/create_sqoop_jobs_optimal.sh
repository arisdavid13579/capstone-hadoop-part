#!/bin/bash

echo ' Opening Metastore'
echo "########## Create Jobs ##########" > ${0%/*}/sqoop_output
echo  >> output
echo " Closing old store" >> ${0%/*}/sqoop_output
sqoop-metastore --shutdown &>> ${0%/*}/sqoop_output
sleep 3
echo  >> ${0%/*}/sqoop_output
echo " Openenig new store" >> ${0%/*}/sqoop_output
echo  >> ${0%/*}/sqoop_output
echo
sqoop-metastore &>> ${0%/*}/sqoop_output &
sleep 2

echo ' Cleaning up database and staging space'
echo
hdfs dfs -rm -r -f /Credit_Card_System/CDW_SAPP_D_TIME
hdfs dfs -rm -r -f /Credit_Card_System/CDW_SAPP_D_BRANCH
hdfs dfs -rm -r -f /Credit_Card_System/CDW_SAPP_D_CUSTOMER
hdfs dfs -rm -r -f /Credit_Card_System/CDW_SAPP_F_CREDIT_CARD
hive -e "DROP DATABASE  IF EXISTS CDW_SAPP CASCADE;"


bash  ${0%/*/*}/optimized/sqoop/sqoop_jobs.sh

sleep 1

echo
echo ' Shutting Down Metastore'
sqoop-metastore --shutdown
