#coding:utf-8
import csv

f = open('../../Result/make_semantic_result/semantic_score_csjnrd.txt', 'w')

for n in range(1,11):
	f2 = open('../../../../Error-Correction/NRD/NRD_xa'+ str(n) +'.csv', 'rb')
	print "read [NRD_xa" + str(n) + ".csv]"
	dataReader = csv.reader(f2)
	for row in dataReader:
	    linedata = []
	    for data in row:
	        linedata.append(data)
	    # 指定した要素ならば表示
	    if linedata[2] != "0" or linedata[3] !="1.0":
	    	f.write(linedata[0] +","+ linedata[1] +"\t" + linedata[3] + "\n")