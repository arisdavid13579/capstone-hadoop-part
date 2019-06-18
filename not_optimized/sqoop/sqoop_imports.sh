#!bin/bash

########## Credit Card table

sqoop import \
--connect jdbc:mysql://localhost/cdw_sapp \
--driver com.mysql.jdbc.Driver \
-m 1 \
--query \
"SELECT \
CREDIT_CARD_NO AS CUST_CC_NO, \
CONCAT (YEAR, IF(MONTH BETWEEN 1 AND 9, CONCAT (0, MONTH), MONTH), IF(DAY BETWEEN 1 AND 9, CONCAT (0, DAY), DAY)) AS TIMEID, \
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
--fields-terminated-by '\t'


########## Branch table

sqoop import \
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
WHERE \$CONDITIONS" \
--target-dir /Credit_Card_System/CDW_SAPP_D_BRANCH/ \
--fields-terminated-by '\t'


########## Customer table

sqoop import \
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
--fields-terminated-by '\t'

########## Time table

sqoop import \
--connect jdbc:mysql://localhost/cdw_sapp \
--driver com.mysql.jdbc.Driver \
-m 1 \
--query \
"SELECT distinct CAST(CONCAT(YEAR, LPAD(MONTH, 2,'0'), LPAD(DAY, 2,'0')) AS UNSIGNED) as TIMEID , DAY, MONTH, \
CASE \
WHEN (MONTH between 1 and 3) THEN 'FIRST' \
WHEN (MONTH between 4 and 6) THEN 'SECOND' \
WHEN (MONTH between 7 and 9) THEN 'THIRD' \
WHEN (MONTH between 9 and 12) THEN 'FOURTH' \
END AS 'QUARTER', \
YEAR FROM cdw_sapp.cdw_sapp_creditcard WHERE \$CONDITIONS \
ORDER BY 1" \
--target-dir /Credit_Card_System/CDW_SAPP_D_TIME/ \
--fields-terminated-by '\t'