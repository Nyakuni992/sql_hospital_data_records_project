--Explore all objects in the data base
SELECT 
  * 
  FROM INFORMATION_SCHEMA.TABLES

--Explore all columns in the data base
SELECT 
  * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_patients'
