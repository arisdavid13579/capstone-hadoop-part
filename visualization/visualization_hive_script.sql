-- Question 1
SELECT cdw_sapp_d_branch.branch_zip, SUM(cdw_sapp_f_credit_card.transaction_value) AS transaction_value
FROM cdw_sapp.cdw_sapp_d_branch JOIN cdw_sapp.cdw_sapp_f_credit_card
ON cdw_sapp_d_branch.branch_code = cdw_sapp_f_credit_card.branch_code
GROUP BY cdw_sapp_d_branch.branch_zip
ORDER BY transaction_value DESC
LIMIT 20;


-- Question 2
SELECT 
CASE quarter 
WHEN 'FIRST' THEN 1 
WHEN 'SECOND' THEN 2 
WHEN 'THIRD' THEN 3 
WHEN 'FOURTH' THEN 4 
END 
AS `quarter`, 
SUM(cdw_sapp_f_credit_card.transaction_value) AS transaction_value, 
cdw_sapp_f_credit_card.transaction_type 
FROM cdw_sapp.cdw_sapp_d_time
JOIN cdw_sapp.cdw_sapp_f_credit_card 
ON cdw_sapp_d_time.timeid = cdw_sapp_f_credit_card.timeid 
GROUP BY cdw_sapp_f_credit_card.transaction_type, quarter 
ORDER BY cdw_sapp_f_credit_card.transaction_type, quarter;