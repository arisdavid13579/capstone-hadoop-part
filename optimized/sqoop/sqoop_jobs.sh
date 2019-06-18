#!bin/bash

########## BRANCH TABLE

# Delete old job if exists
echo
echo ' Deleting previous branch table job'
sqoop job \
--meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop \
--delete updatebranchtable

# Create new job
echo
echo ' Creating new branch table job'
sqoop job \
--meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop \
--create updatebranchtable \
-- import \
--connect jdbc:mysql://localhost/cdw_sapp \
--driver com.mysql.jdbc.Driver \
-m 1 \
--query \
"SELECT \
BRANCH_CODE, \
BRANCH_NAME, \
BRANCH_STREET, \
BRANCH_CITY, \
BRANCH_STATE, \
IF (BRANCH_ZIP IS NULL, 999999, BRANCH_ZIP) AS BRANCH_ZIP, \
CONCAT('(',LEFT(BRANCH_PHONE,3),')',SUBSTRING(BRANCH_PHONE,4,3),'-',RIGHT(BRANCH_PHONE,4)) AS BRANCH_PHONE, \
LAST_UPDATED \
FROM \
cdw_sapp.cdw_sapp_branch \
WHERE \
\$CONDITIONS" \
--target-dir /Credit_Card_System/CDW_SAPP_D_BRANCH/ \
--append \
--incremental lastmodified \
--check-column LAST_UPDATED \
--last-value '0000-00-00 00:00:00' \
--fields-terminated-by '\t'

########## CREDIT CARD TABLE

# Delete old job if exists
echo
echo ' Deleting previous credit card table job'
sqoop job \
--meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop \
--delete updatecreditcardtable

# Create new job
echo
echo ' Creating new credit card table job'
sqoop job \
--meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop \
--create  updatecreditcardtable \
-- import \
--connect jdbc:mysql://localhost/cdw_sapp \
--driver com.mysql.jdbc.Driver \
-m 1 \
--query \
"SELECT \
CREDIT_CARD_NO AS CUST_CC_NO, \
CONCAT (YEAR, IF(MONTH<=9, CONCAT (0, MONTH), MONTH), IF(DAY<=9, CONCAT (0, DAY), DAY)) AS TIMEID, \
CUST_SSN, \
BRANCH_CODE, \
TRANSACTION_TYPE, \
TRANSACTION_VALUE, \
TRANSACTION_ID, \
LAST_UPDATED \
FROM \
cdw_sapp.cdw_sapp_creditcard \
WHERE \$CONDITIONS" \
--target-dir /Credit_Card_System/CDW_SAPP_F_CREDIT_CARD/ \
--append \
--incremental lastmodified \
--check-column LAST_UPDATED \
--last-value '0000-00-00 00:00:00' \
--fields-terminated-by '\t'

########## CUSTOMER TABLE

# Delete old job if exists
echo
echo ' Deleting previous customer table job'
sqoop job \
--meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop \
--delete updatecustomertable

# Create new job
echo
echo ' Creating new customer table job'
sqoop job  \
--meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop \
--create updatecustomertable \
-- import \
--connect jdbc:mysql://localhost/cdw_sapp \
--driver com.mysql.jdbc.Driver \
-m 1 \
--query \
"SELECT \
SSN AS CUST_SSN, \
CONCAT(UPPER(SUBSTRING(FIRST_NAME,1,1)),LOWER(SUBSTRING(FIRST_NAME,2))) AS CUST_F_NAME, \
LOWER(MIDDLE_NAME) AS CUST_M_NAME, \
CONCAT(UPPER(SUBSTRING(LAST_NAME,1,1)),LOWER(SUBSTRING(LAST_NAME,2)))  AS CUST_L_NAME, \
CREDIT_CARD_NO AS CUST_CC_NO, \
CONCAT(STREET_NAME,', ',APT_NO) AS CUST_STREET, \
CUST_CITY, \
CUST_STATE, \
CUST_COUNTRY, \
CUST_ZIP, \
CONCAT (  LEFT(CUST_PHONE,3) , '-' , RIGHT(CUST_PHONE,4) ) AS CUST_PHONE, \
CUST_EMAIL, \
LAST_UPDATED \
FROM \
cdw_sapp.cdw_sapp_customer \
WHERE \$CONDITIONS" \
--target-dir /Credit_Card_System/CDW_SAPP_D_CUSTOMER/ \
--append \
--incremental lastmodified \
--check-column LAST_UPDATED \
--last-value '0000-00-00 00:00:00' \
--fields-terminated-by '\t'

########## TIME TABLE

# Delete old job if exists
echo
echo ' Deleting previous time table job'

sqoop job \
--meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop \
--delete updatetimetable

# Create new job
echo
echo ' Creating new time table job'

sqoop job \
--meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop \
--create updatetimetable \
-- import \
--connect jdbc:mysql://localhost/cdw_sapp \
--driver com.mysql.jdbc.Driver \
-m 1 \
--query \
"SELECT \
DISTINCT CAST(CONCAT(YEAR, LPAD(MONTH, 2,'0'), LPAD(DAY, 2,'0')) AS UNSIGNED), \
DAY, MONTH, \
CASE \
WHEN (MONTH <= 3) THEN 'FIRST' \
WHEN (MONTH <= 6) THEN 'SECOND' \
WHEN (MONTH <= 9) THEN 'THIRD' \
WHEN (MONTH <= 12) THEN 'FOURTH' \
END, \
YEAR FROM cdw_sapp.cdw_sapp_creditcard \
WHERE \$CONDITIONS \
ORDER BY 1" \
--target-dir /Credit_Card_System/CDW_SAPP_D_TIME/ \
--incremental append \
--check-column "CAST(CONCAT(YEAR, LPAD(MONTH, 2,'0'), LPAD(DAY, 2,'0')) AS UNSIGNED)" \
--last-value '0' \
--fields-terminated-by '\t'
# Using aliases to specify the column name as TIMEID gives errors. 