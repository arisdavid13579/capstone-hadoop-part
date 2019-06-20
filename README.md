# Data Warehousing Capstone Project

This repository is a copy of the Hadoop part of the final project assigned to me during as part of my Data Engineering training bootcamp. 

### ETL from MySQL to warehouse.

The bulk of the project was to transfer data from a relational database (MySQL) into a data warehouse (in Hadoop).
Sqoop was used to Extract the data from the database and also to Transform into a format better suited for a data warehouse. once Sqoop loaded the data into HDFS, hive was used to transfer it to the data warehouse.

### Automating the process

Oozie workflows were then used to automate the ETL process and allow it to run periodically (set to every 20 minutes).

## How to run:

The project runs on one of HortonWorks distributions of Hadoop. It is an image that must run in a VM. For the project to work, the Hadoop image must have installed Sqoop, Hive, and Oozie. The image must also have the required MySQL database installed on the Linux (CentOS) installation that houses Hadoop. A .sql file with the database can be found in this repository.

The HortonWorks distribution is a large file so it is not included with the repository. Later I will include a link to the VM image and maybe instructions on how to create your own.

Assuming that a proper installation of Hadoop is running on a VM, the project can be run by first copying the contents of the repository into the Linux VM (not into HDFS) and first running the create_sqoop_jobs_optimal.sh script inside the run folder and then running the run_optimized_oozie.sh script inside the same folder. For this to work, the Hadoop image must also have a Sqoop metastore installed, so make sure one is installed. 

##### More information can be found inside the operation_manual.pdf file. 