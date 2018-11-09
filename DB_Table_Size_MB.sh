#!/bin/bash

# To find the Database Size
SELECT 
	table_schema AS Database_Name
	,ROUND(SUM(data_length + index_length) / 1024 / 1024, 1) AS SizeInMB
FROM information_schema.tables
GROUP BY table_schema;

# To find the Table Size
SELECT 
	table_name AS TableName
	,ROUND(((data_length + index_length) / 1024 / 1024), 2) AS SizeInMB
FROM information_schema.TABLES
WHERE table_schema = 'Database_NAME'
AND table_name = 'Table_Name';

