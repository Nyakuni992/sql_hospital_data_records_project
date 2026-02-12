/*
==================================================================================
DDL Script: Create Silver Tables
==================================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  By running this script, you are re-definnning the DDL structure of 'bronze' Tables.
==================================================================================
*/
USE Hospital_db
--Create tables

IF OBJECT_ID ('silver.patients', 'U') IS NOT NULL
	DROP TABLE silver.patients;
GO

CREATE TABLE silver.patients (
Id NVARCHAR(50),
Birth_date DATE,
Death_date DATE,
Prefix NVARCHAR(50),
First NVARCHAR(50),
Last NVARCHAR(50),
Suffix NVARCHAR(50),
Maiden NVARCHAR(50),
Marital_status NVARCHAR(50),
Race NVARCHAR(50),
Ethnicity NVARCHAR(50),
Gender NVARCHAR(50),
Birth_place NVARCHAR(50),
Address NVARCHAR(50),
City NVARCHAR(50),
State NVARCHAR(50),
County NVARCHAR(50),
Zip NVARCHAR(5),
Lat FLOAT,
Lon FLOAT,
hdb_create_date DATETIME2 DEFAULT GETDATE()

);

GO

IF OBJECT_ID ('silver.encounters ', 'U') IS NOT NULL
	DROP TABLE silver.encounters ;
GO

CREATE TABLE silver.encounters (
Id UNIQUEIDENTIFIER PRIMARY KEY,
Start DATETIME,
Stop DATETIME,
Patient NVARCHAR(50),
Organization NVARCHAR(50),
Payer NVARCHAR(50),
Encounter_class NVARCHAR(50),
Code NVARCHAR(50),
Description NVARCHAR(500),
Base_encounter_cost DECIMAL(10,2),
Total_claim_cost DECIMAL(10,2),
Payer_coverage DECIMAL(10,2),
Reason_code NVARCHAR(50),
Reason_description NVARCHAR(500),
hdb_create_date DATETIME2 DEFAULT GETDATE()

);

GO

IF OBJECT_ID ('silver.payers ', 'U') IS NOT NULL
	DROP TABLE silver.payers ;
GO

CREATE TABLE silver.payers (
Id NVARCHAR(50),
Name NVARCHAR(50),
Address NVARCHAR(50),
City NVARCHAR(50),
State_headquatered NVARCHAR(50),
Zip INT,
Phone NVARCHAR(50),
hdb_create_date DATETIME2 DEFAULT GETDATE()

);

GO

IF OBJECT_ID ('silver.procedures ', 'U') IS NOT NULL
	DROP TABLE silver.procedures ;

GO

CREATE TABLE silver.procedures (
Start DATETIME,
Stop DATETIME,
Patient NVARCHAR(50),
Encounter NVARCHAR(50),
Code NVARCHAR(50),
Description NVARCHAR(500),
Base_cost DECIMAL(10,2),
Reason_code NVARCHAR(50),
Reason_description NVARCHAR(500),
hdb_create_date DATETIME2 DEFAULT GETDATE()
);

GO

IF OBJECT_ID ('silver.organizations ', 'U') IS NOT NULL
	DROP TABLE silver.organizations ;

GO
CREATE TABLE silver.organizations (
Id UNIQUEIDENTIFIER PRIMARY KEY,
Name NVARCHAR(50),
Address NVARCHAR(50),
City NVARCHAR(50),
State NVARCHAR(50),
Zip INT,
Lat FLOAT,   
Lon FLOAT,
hdb_create_date DATETIME2 DEFAULT GETDATE()

);
