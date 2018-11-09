#!/bin/bash

SELECT
	COUNT(*) AS TotalTableCount
	,table_schema
	,CONCAT(ROUND(SUM(table_rows)/1000000,2),'M') AS TotalRowCount
	,CONCAT(ROUND(SUM(data_length)/(1024*1024*1024),2),'G') AS TotalTableSize
	,CONCAT(ROUND(SUM(index_length)/(1024*1024*1024),2),'G') AS TotalTableIndex
	,CONCAT(ROUND(SUM(data_length+index_length)/(1024*1024*1024),2),'G') TotalSize	
FROM information_schema.TABLES
GROUP BY ENGINE
ORDER BY SUM(data_length+index_length) 
DESC LIMIT 10;

#To find largest database in server

SELECT
	COUNT(*) AS TotalTableCount
	,table_schema
	,CONCAT(ROUND(SUM(table_rows)/1000000,2),'M') AS TotalRowCount
	,CONCAT(ROUND(SUM(data_length)/(1024*1024*1024),2),'G') AS TotalTableSize
	,CONCAT(ROUND(SUM(index_length)/(1024*1024*1024),2),'G') AS TotalTableIndex
	,CONCAT(ROUND(SUM(data_length+index_length)/(1024*1024*1024),2),'G') TotalSize	
FROM information_schema.TABLES
GROUP BY table_schema
ORDER BY SUM(data_length+index_length) 
DESC LIMIT 10;