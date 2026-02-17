/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
This script runs quality checks to verify the integrity, consistency, and accuracy of the Gold Layer. It ensures:
         Surrogate keys in dimension tables remain unique.
         Proper referential integrity between fact and dimension tables.
         Correct relationships within the data model to support reliable analytics.

Usage Notes:
         Review and fix any issues identified during the validation process.
===============================================================================
*/

-- ====================================================================
-- Checking 'gold.dim_patients'
-- ====================================================================
-- Check for Uniqueness of Patient Key in gold.dim_patients
-- Expectation: No results 
SELECT 
    Patient_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_patients
GROUP BY patient_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.payer_key'
-- ====================================================================
-- Check for Uniqueness of Payer Key in gold.dim_payers
-- Expectation: No results 
SELECT 
    Payer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_payers
GROUP BY Payer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.organization_key'
-- ====================================================================
-- Check for Uniqueness of Prganization Key in gold.dim_organization
-- Expectation: No results 
SELECT 
    Organization_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_organizations
GROUP BY Organization_key
HAVING COUNT(*) > 1;
-- ====================================================================
-- Checking 'gold.fact_encounters
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
SELECT *
FROM gold.fact_encounters e
LEFT JOIN gold.dim_patients p
ON e.Patient_key = p.Patient_key
LEFT JOIN gold.dim_payers py
ON e.Payer_key = py.Payer_key
LEFT JOIN gold.dim_organizations o
ON o.Organization_key = e.Organization_key
WHERE p.Patient_key IS NULL
OR    py.Payer_key IS NULL
OR    o.Organization_key IS NULL

-- ====================================================================
-- Checking 'gold.fact_procedures
-- ====================================================================
-- Check the data model connectivity between fact.procedures and dim.patients
SELECT *
FROM gold.fact_procedures pr
LEFT JOIN gold.dim_patients p
ON pr.Patient_key = p.Patient_key
WHERE p.Patient_key IS NULL
