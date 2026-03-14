--What is the total encounter_base_cost?
SELECT 
SUM(Base_encounter_cost)                     AS Total_encounter_cost
FROM gold.fact_encounters

--What is the avg encounter_base_cost?
SELECT 
AVG(Base_encounter_cost)                     AS Avg_encounter_cost
FROM gold.fact_encounters

--What is the overall total claim cost?
SELECT 
SUM(Total_claim_cost)                         AS Overall_total_claim_cost
FROM gold.fact_encounters

--What is the avg overall total claim cost?
SELECT 
AVG(Total_claim_cost)                         AS Overall_avg_claim_cost
FROM gold.fact_encounters

--Find the total payer coverage
SELECT
SUM(Payer_coverage)                           AS Total_payer_coverage
FROM gold.fact_encounters

--Find the average payer coverage
SELECT
AVG(Payer_coverage)                           AS Avg_payer_coverage
FROM gold.fact_encounters

--Find the total procedure base cost.
SELECT 
SUM(Procedure_base_cost)                      AS Total_procedure_cost
FROM gold.fact_procedures

--Find the avg procedure base cost.
SELECT 
AVG(Procedure_base_cost)                     AS Avg_procedure_cost
FROM gold.fact_procedures

--Find the Total number of encounters.
SELECT 
COUNT(Encounter_id)                          AS Total_encounters
FROM gold.fact_encounters

--What is the total number of unique patients who had encounters
SELECT
COUNT( DISTINCT Patient_key)                 AS Total_unique_patients
FROM gold.fact_encounters

--Find the total number of patients.
SELECT
COUNT(*)                                     AS Total_patients
FROM gold.dim_patients

--Find the total number of procedures
SELECT
COUNT(*)                                     AS Total_procedures
FROM gold.fact_procedures

--Find the total unique patients who had procedures
SELECT
COUNT(DISTINCT Patient_key)                  AS Patients_with_procedures
FROM gold.fact_procedures

--Generate a report that shows all key metrics of the organization.
SELECT 'Total_base_encounter_cost' AS Measure_name, SUM(Base_encounter_cost) AS Measure_value FROM gold.fact_encounters 
UNION ALL
SELECT 'Avg_base_encounter_cost' AS Measure_name, AVG(Base_encounter_cost) AS Measure_value FROM gold.fact_encounters
UNION ALL
SELECT 'Overall_total_claim_cost' AS Measure_name, SUM(Total_claim_cost) AS Measure_value FROM gold.fact_encounters
UNION ALL
SELECT 'Overall_avg_claim_cost' AS Measure_name, AVG(Total_claim_cost) AS Measure_value FROM gold.fact_encounters
UNION ALL
SELECT 'Total_payer_coverage' AS Measure_name, SUM(Payer_coverage) AS Measure_name FROM gold.fact_encounters
UNION ALL
SELECT 'Avg_payer_coverage' AS Measure_name, AVG(Payer_coverage) AS Measure_name FROM gold.fact_encounters
UNION ALL
SELECT 'Total_procedure_cost' AS Measure_name, SUM(Procedure_base_cost) AS Measure_name FROM gold.fact_procedures
UNION ALL
SELECT 'Avg_procedure_cost' AS Measure_name, AVG(Procedure_base_cost) AS Measure_name FROM gold.fact_procedures
UNION ALL
SELECT 'Total_nr.encounters' AS Measure_name, COUNT(Encounter_id) AS Measure_name FROM gold.fact_encounters
UNION ALL
SELECT 'Total_nr.unique_patients' AS Measure_name, COUNT( DISTINCT Patient_key) AS Measure_name FROM gold.fact_encounters
UNION ALL
SELECT 'Total_nr.patients' AS Measure_name, COUNT(*) AS Measure_value FROM gold.dim_patients
UNION ALL
SELECT 'Total_nr.procedures' AS Measure_name, COUNT(*) AS Measure_value FROM gold.fact_procedures
UNION ALL
SELECT 'Total_nr.patients_with_procedures' AS Measure_name,COUNT(DISTINCT Patient_key) AS Measure_value FROM gold.fact_procedures
