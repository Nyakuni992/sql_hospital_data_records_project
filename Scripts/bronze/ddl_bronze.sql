/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  By running this script, you are re-definning the DDL structure of 'bronze' Tables
===============================================================================
*/
USE Hospital_db
--Create tables

IF OBJECT_ID ('bronze.patients', 'U') IS NOT NULL
	DROP TABLE bronze.patients;
GO

CREATE TABLE bronze.patients (
Id UNIQUEIDENTIFIER PRIMARY KEY,
Birthdate DATE,
Deathdate DATE,
Prefix NVARCHAR(50),
First NVARCHAR(50),
Last NVARCHAR(50),
Suffix NVARCHAR(50),
Maiden NVARCHAR(50),
Maritalstatus NVARCHAR(50),
Race NVARCHAR(50),
Ethnicity NVARCHAR(50),
Gender NVARCHAR(50),
Birthplace NVARCHAR(50),
Address NVARCHAR(50),
City NVARCHAR(50),
State NVARCHAR(50),
County NVARCHAR(50),
Zip NVARCHAR(5),
Lat FLOAT,
Lon FLOAT

); 

GO

IF OBJECT_ID ('bronze.encounters ', 'U') IS NOT NULL
	DROP TABLE bronze.encounters ;
GO

CREATE TABLE bronze.encounters (
Id UNIQUEIDENTIFIER PRIMARY KEY,
Start NVARCHAR(50),
Stop NVARCHAR(50),
Patient UNIQUEIDENTIFIER,
Organization UNIQUEIDENTIFIER,
Payer UNIQUEIDENTIFIER,
Encounter_Class NVARCHAR(50),
Code NVARCHAR(50),
Description NVARCHAR(500),
Base_Encounter_cost FLOAT,
Total_claim_cost FLOAT,
Payer_coverage FLOAT,
Reason_code NVARCHAR(50),
Reason_description NVARCHAR(500)

);

GO

IF OBJECT_ID ('bronze.payers ', 'U') IS NOT NULL
	DROP TABLE bronze.payers ;
GO

CREATE TABLE bronze.payers (
Id UNIQUEIDENTIFIER PRIMARY KEY,
Name NVARCHAR(50),
Address NVARCHAR(50),
City NVARCHAR(50),
State_headquatered NVARCHAR(50),
Zip NVARCHAR(5),
Phone NVARCHAR(50)

);

GO

IF OBJECT_ID ('bronze.procedures ', 'U') IS NOT NULL
	DROP TABLE bronze.procedures ;

GO

CREATE TABLE bronze.procedures (
Start DATETIME,
Stop DATETIME,
Patient UNIQUEIDENTIFIER,
Encounter UNIQUEIDENTIFIER,
Code NVARCHAR(50),
Description NVARCHAR(500),
Base_cost INT,
Reasoncode NVARCHAR(50),
Reasondescription NVARCHAR(500)
);

GO

IF OBJECT_ID ('bronze.organizations ', 'U') IS NOT NULL
	DROP TABLE bronze.organizations ;

GO
CREATE TABLE bronze.organizations (
Id UNIQUEIDENTIFIER PRIMARY KEY,
Name NVARCHAR(50),
Address NVARCHAR(50),
City NVARCHAR(50),
State NVARCHAR(50),
Zip NVARCHAR(5),
Lat DECIMAL(10,5),
Lon DECIMAL(10,5)

);
