*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in Hospital_db. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

   Each view integrates data from the Silver layer and applies modifications 
   to produce enriched, clean, and business-ready data.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_patients
-- =============================================================================
IF OBJECT_ID('gold.dim_patients', 'V') IS NOT NULL
    DROP VIEW gold.dim_patients;
GO

CREATE VIEW gold.dim_patients AS
SELECT
    ROW_NUMBER() OVER (ORDER BY Id) AS Patient_key,
    Id                              AS Patient_id,
    First                           AS First_name,
    Last                            AS Last_name,
    Gender,
    Birth_date,
    Death_date,
    Marital_status,
    Race,
    Ethnicity,
    Birth_place,
    City,
    State,
    County,
    Zip                            AS Zip_code,
    Lat                            AS Latitude,
    Lon                            AS Longitude
FROM silver.patients;
GO

-- =============================================================================
-- Create Dimension: gold.dim_payers
-- =============================================================================
IF OBJECT_ID('gold.dim_payers', 'V') IS NOT NULL
    DROP VIEW gold.dim_payers;
GO

CREATE VIEW gold.dim_payers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY Id) AS Payer_key,
    Id                              AS Payer_id,
    Name                            AS payer_name,
    Address,
    City,
    State_headquatered              AS State_hq_abbr,
    Zip                             AS Zip_code,
    Phone                           AS Phone_number
FROM silver.payers;

-- =============================================================================
-- Create Dimension: gold.dim_organizations
-- =============================================================================
IF OBJECT_ID('gold.dim_organizations', 'V') IS NOT NULL
    DROP VIEW gold.dim_organizations;
GO

CREATE VIEW gold.dim_organizations AS

    SELECT
    ROW_NUMBER() OVER (ORDER BY  Id) AS Organization_key,
    Id                               AS Organization_id,
    Name,
    Address,
    City,
    State,
    Zip                              AS Zip_code,
    Lon                              AS Latitude,
    Lon                              AS Longitude
FROM silver.organizations;
-- =============================================================================
-- Create Fact : gold.fact_encounters
-- =============================================================================
IF OBJECT_ID('gold.fact_encounters', 'V') IS NOT NULL
    DROP VIEW gold.fact_encounters;
GO
CREATE VIEW gold.fact_encounters AS

    SELECT
  e.Id                             AS Encounter_id,
  p.Patient_key,
  o.Organization_key,
  py.Payer_key,
  e.Start                          AS Start_time,
  e.Stop                           AS End_time,
  e.Encounter_class,
  e.Code                           AS Encounter_code,
  e.Description                    AS Encounter_code_description,
  e.Reason_code                    AS Encounter_reason_code,
  e.Reason_description             AS Reason_code_description,
  e.Base_encounter_cost,
  e.Total_claim_cost,
  e.Payer_coverage
FROM silver.encounters e
LEFT JOIN gold.dim_patients p
ON e.Patient = p.Patient_id
LEFT JOIN gold.dim_organizations o
ON e.Organization = o.Organization_id
LEFT JOIN gold.dim_payers py
ON e.Payer = py.Payer_id
WHERE Encounter_after_death_flag = 0 OR Encounter_after_death_flag IS NULL

 

-- =============================================================================
-- Create Fact : gold.fact_procedures
-- =============================================================================
IF OBJECT_ID('gold.fact_procedures', 'V') IS NOT NULL
    DROP VIEW gold.fact_procedures;
GO
CREATE VIEW gold.fact_procedures AS

    SELECT
    pr.Encounter                    AS Encounter_id,
    p.Patient_key,
    pr.Start                        AS Start_time,
    pr.Stop                         AS End_time,
    pr.Code                         AS Procedure_code,
    pr.Description                  AS Procedure_code_description,
    pr.Reason_code                  AS Procedure_reason_code,
    pr.Reason_description           AS Reason_code_description,
    pr.Base_cost
    FROM silver.procedures pr
LEFT JOIN gold.dim_patients p
ON p.Patient_id = pr.Patient 
