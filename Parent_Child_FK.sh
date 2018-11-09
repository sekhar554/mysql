#!/bin/bash

#Find the list of Foreign Keys with the source and destination table information of a MySQL Database.

SELECT
  referenced_table_name AS ParentTable
  ,table_name AS ChildTable
  ,constraint_name AS ConstraintName
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE referenced_table_name IS NOT NULL
ORDER BY referenced_table_name;


#Find Table Dependency in Foreign Key Constraint.
SELECT 
     Constraint_Type
    ,Constraint_Name
    ,Table_Schema
    ,Table_Name
FROM information_schema.table_constraints
WHERE Constraint_Type = 'FOREIGN KEY'
    AND Table_Name = 'Any_Table'
    AND Table_Schema ='db_Name';


#mysql> SELECT       Constraint_Type     ,Constraint_Name     ,Table_Schema     ,Table_Name FROM information_schema.table_constraints WHERE Constraint_Type = 'FOREIGN KEY'     AND Table_Name = 'users'     AND Table_Schema ='APP';
#+-----------------+-----------------+--------------+------------+
#| Constraint_Type | Constraint_Name | Table_Schema | Table_Name |
#+-----------------+-----------------+--------------+------------+
#| FOREIGN KEY     | fk_city_id      | APP          | users      |
#| FOREIGN KEY     | fk_country_id   | APP          | users      |
#| FOREIGN KEY     | fk_state_id     | APP          | users      |
#+-----------------+-----------------+--------------+------------+
#3 rows in set (0.00 sec)
