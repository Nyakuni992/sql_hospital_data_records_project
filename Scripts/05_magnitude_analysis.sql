-- Find total encounters by encounter class.
SELECT
   Encounter_class,
   COUNT(*)                          AS Total_encounters
FROM gold.fact_encounters
GROUP BY Encounter_class

-- Find total encounters by Gender
SELECT
   p.Gender,
    COUNT(*)                          AS Total_encounters
FROM gold.fact_encounters e
INNER JOIN gold.dim_patients p
    ON e.Patient_key = p.Patient_key
GROUP BY p.Gender

-- Find total encounters broken down by City
SELECT
   p.City,
    COUNT(*)                         AS Total_encounters
FROM gold.fact_encounters e
INNER JOIN gold.dim_patients p
    ON e.Patient_key = p.Patient_key
GROUP BY p.City
ORDER BY Total_encounters DESC

-- What is the total claim cost for each encounter class
SELECT
    Encounter_class,
    SUM(Total_claim_cost)              AS Total_claim_cost
FROM gold.fact_encounters
GROUP BY Encounter_class
ORDER BY Total_claim_cost DESC

-- Find the total claim cost for each patient
SELECT
   e.Patient_key,
   p.First_name,
   p.Last_name,
   SUM(Total_claim_cost)                AS Total_claim_cost
FROM gold.fact_encounters e
INNER JOIN gold.dim_patients p
     ON e.Patient_key = p.Patient_key
GROUP BY e.Patient_key,
         p.First_name,
         p.Last_name
ORDER BY Total_claim_cost DESC

-- Find the average total claim cost for each payer per encounter class.
SELECT
   py.Payer_name,
   e.Encounter_class,
   ROUND(CAST(AVG(Total_claim_cost) AS FLOAT), 2)   AS Avg_total_claim_cost
FROM gold.fact_encounters e
INNER JOIN gold.dim_payers py
    ON e.Payer_key = py.Payer_key
GROUP BY Payer_name,
         Encounter_class
ORDER BY Avg_total_claim_cost DESC
-- Find the total payer coverage broken down by payer
SELECT
    py.Payer_name,
    SUM(Payer_coverage)                            AS Total_payer_coverage
FROM gold.fact_encounters e
INNER JOIN gold.dim_payers py
     ON e.Payer_key = py.Payer_key
GROUP BY Payer_name
ORDER BY Total_payer_coverage DESC
-- What is the avg procedure base cost per patient
SELECT
    pr.Patient_key,
    p.First_name,
    p.Last_name,
    ROUND(CAST(AVG(pr.Procedure_base_cost) AS FLOAT), 2)    AS Avg_procedure_base_cost
FROM gold.fact_procedures pr
INNER JOIN gold.dim_patients p
     ON pr.Patient_key = p.Patient_key
GROUP BY pr.Patient_key,
         p.First_name,
         p.Last_name
ORDER BY Avg_procedure_base_cost DESC

-- Find the total number of procedures per patient
SELECT
    pr.Patient_key,
    p.First_name,
    p.Last_name,
    COUNT(pr.Patient_key)                                      AS Total_procedures
FROM gold.fact_procedures pr
INNER JOIN gold.dim_patients p
     ON pr.Patient_key = p.Patient_key
GROUP BY pr.Patient_key,
         p.First_name,
         p.Last_name
ORDER BY Total_procedures DESC
        USE Hospital_db
-- Find the average number of procedures by race
SELECT
   Race,
  AVG(Total_procedures)                        AS Avg_procedures
FROM(
SELECT
  p.Race,
  COUNT(*) AS Total_procedures
FROM gold.fact_procedures pr
INNER JOIN gold.dim_patients p
     ON pr.Patient_key = p.Patient_key
GROUP BY p.Race
)t
GROUP BY Race
ORDER BY Avg_procedures DESC
