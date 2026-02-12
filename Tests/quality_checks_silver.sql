/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date and time ranges.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after loading data into the Silver Layer.
    - Review and resolve any inconsistencies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'silver.crm_cust_info'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
-- Check for nulls and or duplicates in the primary key
-- Expectation is Non

-- ====================================================================
-- Checking 'Encounters'
-- ====================================================================
-- Check for nulls and or duplicates in the primary key
-- Expectation is Non
SELECT 
Id,
COUNT(*)
FROM bronze.encounters
GROUP BY Id
HAVING COUNT(*) > 1 OR Id = NULL
--Normalization and standardisation of time
SELECT
CAST([Start] AS datetime) as Start_datetime,
CAST([Stop] AS datetime) as Stop_datetime
FROM bronze.encounters

--Check validity of start and stop time
--Stop before start (expectation is non)
SELECT 
    * 
FROM bronze.encounters 
WHERE start >= stop
-- check for invalid future datetime
SELECT
*
FROM bronze.encounters
WHERE Start > GETDATE()
-- Checking for Nulls in foreign keys
-- Expectation is Non
SELECT 
Patient,
Organization,
Payer
FROM bronze.encounters
GROUP BY 
Patient,
Organization,
Payer
HAVING Payer = NULL OR Patient = NULL OR Organization = NULL
--Check for unwanted spaces
--Expectation is Non
SELECT DISTINCT
Encounter_Class
FROM bronze.encounters
WHERE Encounter_Class != UPPER(TRIM(Encounter_Class))
-- Integrity and validity checks of code
SELECT
Code
FROM bronze.encounters
WHERE Code NOT LIKE '%[0-9]%' OR Code != UPPER(TRIM(Code))
OR LEN(Code) < 6 OR LEN(Code) > 18 OR Code IS NULL
 -- Check for nulls and negative costs
SELECT 
Base_Encounter_cost,
Total_claim_cost,
Payer_coverage
FROM bronze.encounters
WHERE Base_Encounter_cost < 0 OR Base_Encounter_cost IS NULL OR Base_Encounter_cost NOT LIKE '%[0-9]%'
OR    Total_claim_cost < 0 OR Total_claim_cost IS NULL OR Total_claim_cost NOT LIKE '%[0-9]%'
OR    Payer_coverage < 0 OR Payer_coverage IS NULL OR Payer_coverage NOT LIKE '%[0-9]%'

-- ====================================================================
-- Checking 'Patients'
-- ====================================================================
--Check for Nulls and duplicates in primary key
SELECT
Id,
COUNT(*)
FROM bronze.patients
GROUP BY Id 
HAVING  Id = NULL OR COUNT(*) > 1
--Check for patients without encouters
--Expectation is non
SELECT
p.*
FROM bronze.patients p
LEFT JOIN bronze.encounters e
ON p.Id = e.Patient
WHERE e.Patient IS NULL
--Check validity of birthdate and deathdate
--Death before birth (expectation is non)
SELECT 
    * 
FROM bronze.patients
WHERE Birthdate > Deathdate
-- Identify Out-of-Range Dates
-- Expectation: Birthdates between 1920-01-01 and Today
SELECT DISTINCT 
Birthdate
FROM bronze.patients
WHERE Birthdate < '1920-01-01'
   OR Birthdate > GETDATE()
-- Data Standardization & Consistency
SELECT DISTINCT
Prefix
FROM  bronze.patients

--Check for nulls (expectation is non)
SELECT
First,
Last
FROM bronze.patients
WHERE First IS NULL OR Last IS NULL
-- Data Standardization & Consistency 
--Expectation - Non
SELECT
Prefix,
First,
Last,
Suffix,
Maiden
FROM bronze.patients
WHERE Prefix!= UPPER(TRIM(Prefix))
  OR Last != UPPER(TRIM(Last)) 
  OR First!= UPPER(TRIM(First))
  OR Suffix!= UPPER(TRIM(Suffix))
  OR Maiden!= UPPER(TRIM(Maiden))
--Data normalization and consistency checks
SELECT
First,
Last,
Maiden 
FROM bronze.patients
WHERE First NOT LIKE '%[^0-9]%'
OR First NOT LIKE '%[^A-Z]%'
OR Last NOT LIKE '%[^0-9]%'
OR Last NOT LIKE '%[^A-Z]%'
OR Maiden NOT LIKE '%[^0-9]%'
OR Maiden NOT LIKE '%[^A-Z]%'
-- Data Standardization & Consistency
SELECT 
Maritalstatus,
Race,
Ethnicity,
Gender
FROM  bronze.patients
WHERE Maritalstatus != UPPER(TRIM(Maritalstatus))
OR Race != UPPER(TRIM(Race))
OR Ethnicity != UPPER(TRIM(Ethnicity))
OR Gender != UPPER(TRIM(Gender))
-- Data Normalization and consistency
SELECT DISTINCT
Maritalstatus,
CASE WHEN Maritalstatus = 'S' THEN 'Single'
     WHEN Maritalstatus = 'M' THEN 'Married'
     ELSE 'n/a'
END as Maritalstatus
FROM  bronze.patients
-- Data Standardization & Consistency of Race and Ethimicity
SELECT DISTINCT
Race,
CASE WHEN UPPER(TRIM(Race)) = 'asian' THEN 'Asian'
     WHEN UPPER(TRIM(Race)) = 'black' THEN 'Black'
     WHEN UPPER(TRIM(Race)) = 'white' THEN 'White'
     WHEN UPPER(TRIM(Race)) = 'hawaiian' THEN 'Hawaiian'
     WHEN UPPER(TRIM(Race)) = 'native' THEN 'Native'
     WHEN UPPER(TRIM(Race)) = 'other' THEN 'Other'
     ELSE 'n/a'
END Race
FROM bronze.patients
--Data standardization and consistency
SELECT DISTINCT
Ethnicity,
CASE WHEN UPPER(TRIM(Ethnicity)) = 'nonhispanic' THEN 'Non Hispanic'
     WHEN UPPER(TRIM(Ethnicity)) = 'hispanic' THEN 'Hispanic'
     ELSE 'n/a'
END Ethnicity

FROM bronze.patients
 -- Normalize gender values to readable format
SELECT DISTINCT
Gender,
CASE WHEN Gender = 'F' THEN 'Female'
     WHEN Gender = 'M' THEN 'Male'
     ELSE 'n/a'
END as Gender
FROM  bronze.patients
-- Data Standardization 
--Expectation - Non
SELECT
Birthplace,
Address,
City,
State,
County  
FROM bronze.patients
WHERE Birthplace != UPPER(TRIM(Birthplace)) 
  OR  Address != TRIM(Address) 
  OR  City != TRIM(City)       
  OR  State != TRIM(State)     
  OR  County != TRIM(County) 
--Lon and Lat validity checks
SELECT
Lon,
Lat
FROM bronze.patients
WHERE Lon NOT LIKE '%[0-9]%'
 OR   Lat NOT LIKE '%[0-9]%'

-- ====================================================================
-- Checking 'Procedures'
-- ====================================================================
--Check for nulls in procedure duration
-- Expectation is non
SELECT 
Start,
Stop
FROM bronze.procedures
WHERE Start IS NULL
OR    Stop IS NULL
--Check validity of start and stop time
--Stop before start (expectation is non)
SELECT 
    * 
FROM bronze.procedures 
WHERE Start > Stop
--Future procedures
--Expectation is non
SELECT
*
FROM bronze.procedures
WHERE Start > GETDATE()
--Check for nulls and duplicates in patient ID
--Expectation is non
SELECT 
Patient,
Encounter
FROM bronze.procedures
WHERE Patient IS NULL
OR    Encounter IS NULL
--Check for duplicates in procedures done per patient
--expectation is non
SELECT 
Start,
Stop,
Patient,
Encounter,
Code,
COUNT(*) duplicates
FROM bronze.procedures
GROUP BY Start, Stop, Patient,Encounter, Code
HAVING COUNT(*) > 1
--Checking for procedures without patients
--Expectation is non
SELECT
P.*
FROM bronze.procedures p
LEFT JOIN bronze.patients pt
ON p.Patient = pt.Id
WHERE pt.Id IS NULL
--Checking for procedures without encounters
--Expectation is non
SELECT
p.*
FROM bronze.procedures p
LEFT JOIN bronze.encounters e
ON p.Encounter = e.Id
WHERE e.Id IS NULL
--Check for procedures before birth
--Expectation is non
SELECT
*
FROM bronze.procedures p
LEFT JOIN bronze.patients pt
ON pt.Id = p.Patient
WHERE p.Start < pt.Birthdate
--Identify likely Invalid or Unmapped codes
SELECT * 
FROM bronze.procedures
WHERE Code LIKE '%[^0-9]%' 
OR LEN(Code) < 6 OR LEN(Code) > 18
--Data Standardisation and consistency (expectation is non)
SELECT 
Code,
Description 
FROM bronze.procedures
WHERE Code != TRIM(Code) OR Description != TRIM(Description)
-- Check for NULLs or Negative Values in Cost
-- Expectation: No Results
SELECT
Base_cost 
FROM bronze.procedures
WHERE Base_cost < 0 OR Base_cost IS NULL
--Identify likely Invalid or Unmapped Reasoncode
SELECT * 
FROM bronze.procedures
WHERE Reasoncode LIKE '%[^0-9]%' 
OR LEN(Reasoncode) < 6
--Data Standardisation and consistency (expectation is non)
SELECT 
Reasoncode,
Reasondescription 
FROM bronze.procedures
WHERE Reasoncode != TRIM(Reasoncode) OR Reasondescription != TRIM(Reasondescription)

-- ====================================================================
-- Checking 'Payers'
-- ====================================================================
--check for nulls and duplicates in primary key
--Expectation is non
SELECT 
Id,
COUNT(*)
FROM bronze.payers
GROUP BY Id
HAVING Id IS NULL OR COUNT(*) > 1

--Standardization and Normalization
SELECT
Name,
Address,
City,
 State_headquatered
FROM bronze.payers
WHERE Name != UPPER(TRIM(Name))
OR    Address != UPPER(TRIM(Address))
OR    City != UPPER(TRIM(City))
OR    State_headquatered != UPPER(TRIM( State_headquatered))

-- Data Standardization & Consistency
SELECT 
Name,
CASE WHEN UPPER(TRIM(Name)) IN ('NO_INSURANCE') THEN 'Self Pay' ELSE Name
END Payer_name
FROM bronze.payers
--Normalization and validation of Zip code
SELECT 
Zip,
CASE WHEN Zip IS NOT NULL
     AND LEN(Zip) < 5
     AND Zip NOT LIKE '%[^0-9]%' THEN RIGHT('00000' + Zip, 5)
     ELSE Zip
     END AS Zip_code
FROM bronze.payers
-- Check for validity in phone number
--Expectation is non
SELECT 
Phone,
LEN(Phone) Phone_len
FROM bronze.payers
WHERE Phone IS NOT NULL AND LEN(Phone) < 11

-- ====================================================================
-- Checking 'Organization'
-- ====================================================================
--Standardisation and consistency
SELECT
Name,
Address,
City
FROM bronze.organizations
WHERE Name != UPPER(TRIM(Name))
OR    Address != UPPER(TRIM(Address))
OR    City    != UPPER(TRIM(City))


