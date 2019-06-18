import pyodbc
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
conn  = pyodbc.connect("DSN=hive" , autocommit=True)
query = "select \
CASE quarter \
WHEN 'FIRST' THEN 1 \
WHEN 'SECOND' THEN 2 \
WHEN 'THIRD' THEN 3 \
WHEN 'FOURTH' THEN 4 \
END \
as `quarter`, \
sum(c.transaction_value) as transaction_value, \
c.transaction_type \
from cdw_sapp.cdw_sapp_d_time t \
join cdw_sapp.cdw_sapp_f_credit_card c \
on t.timeid = c.timeid \
group by c.transaction_type, quarter \
order by c.transaction_type, quarter;"
data = pd.read_sql(query,conn)
barWidth = 1

q1Vals = data['transaction_value'][data['quarter']==1]
q2Vals = data['transaction_value'][data['quarter']==2]
q3Vals = data['transaction_value'][data['quarter']==3]
q4Vals = data['transaction_value'][data['quarter']==4]
totalVals = [sum(q1Vals),sum(q2Vals),sum(q3Vals),sum(q4Vals) ]

billsData = data['transaction_value'][0:4]
educationData = data['transaction_value'][4:8]
entertainmentData = data['transaction_value'][8:12]
gasData = data['transaction_value'][12:16]
groceryData = data['transaction_value'][16:20]
healthcareData = data['transaction_value'][20:24]
testData = data['transaction_value'][24:28]
 
billsPosition = [5, 15, 25, 35]
educationcationPosition = [x + barWidth for x in billsPosition]
entertainmentPosition = [x + barWidth for x in educationcationPosition]
gasPosition = [x + barWidth for x in entertainmentPosition]
groceryPosition = [x + barWidth for x in gasPosition]
healthcarePosition = [x + barWidth for x in groceryPosition]
testPosition = [x + barWidth for x in healthcarePosition]
 
plt.bar(billsPosition, billsData, color='#f4ad42', width=barWidth, edgecolor='white', label='Bills')
plt.bar(educationcationPosition, educationData, color='#caf441', width=barWidth, edgecolor='white', label='Education')
plt.bar(entertainmentPosition, entertainmentData, color='#41f467', width=barWidth, edgecolor='white', label='Entertainment') 
plt.bar(gasPosition, gasData, color='#1dcee5', width=barWidth, edgecolor='white', label='Gas')
plt.bar(groceryPosition, groceryData, color='#1114c1', width=barWidth, edgecolor='white', label='Grocery')
plt.bar(healthcarePosition, healthcareData, color='#900fbf', width=barWidth, edgecolor='white', label='Healthcare')
plt.bar(testPosition, testData, color='#cc106e', width=barWidth, edgecolor='white', label='Test')
 
plt.xlabel('Quarter', fontweight='bold')
plt.xticks([type + 3*barWidth for type in billsPosition], ['First', 'Second', 'Third', 'Fourth'])
plt.ylabel('Transaction Value [USD]', fontweight='bold')
plt.ylim(75000, 95000)


annotatitionWidth = 3.3
annotatitionLength = 1.5
leftBar = billsPosition[0]
bracketLocation = 90000
lineWidth = 1.0

def showTotals(ax, total, annotatitionWidth, annotatitionLength, leftBar, bracketLocation = None , lineWidth = 1.0):
    if bracketLocation == None:
        bracketLocation = np.max(data['transaction_value']) + 800
    total_string = str(total).split('.')
    if len(total_string[0])>3:
        total_string[0]= total_string[0][:-3] + ',' + total_string[0][-3:]
    
    ax.annotate("Total:\n" + '$' +  ','.join(total_string),
        xy=(leftBar+3* barWidth, bracketLocation),
        xycoords='data',
        xytext=(leftBar+3* barWidth,bracketLocation + 2000),
        textcoords='data',
        ha='center',
        va='bottom',
        arrowprops=dict(arrowstyle = '-[, widthB=' + str(annotatitionWidth) + ', lengthB=' + str(annotatitionLength) + '',
                lw=float(lineWidth)))
                
for n in range(0,4):
    np.round(totalVals,2)
    showTotals(plt.gca(),  int(np.round(totalVals[n])), annotatitionWidth, annotatitionLength,billsPosition[n])
    

plt.legend(loc='upper right', bbox_to_anchor=(1.37,1.03))
plt.title('Transaction Totals by Type and Quarter\n',fontweight='bold')
plt.savefig('query2_python.png', dpi=800, bbox_inches='tight')
plt.show()