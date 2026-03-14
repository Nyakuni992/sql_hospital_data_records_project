--Calculate the total number of 30 day-readmissions per patient and categorize them into high, moderate,
-- and low risk groups along with their age range.
WITH Patient_readmission AS (
SELECT
    e.Patient_key,
    p.First_name,
    p.Last_name,
    DATEDIFF(Year, p.Birth_date, GETDATE()) as Age, 
CASE WHEN DATEDIFF(Day, e.Encounter_end_time, LEAD(e.Encounter_start_time) 
          OVER (PARTITION BY e.Patient_key ORDER BY e.Encounter_start_time)) 
     BETWEEN 1 AND 30 THEN 1
     ELSE 0
     END                                   AS Readmissions
FROM gold.fact_encounters e
LEFT JOIN gold.dim_patients p
    ON e.Patient_key = p.Patient_key
WHERE e.Encounter_class = 'Inpatient'
)
SELECT
    Patient_key,
    First_name,
    Last_name,
    CASE WHEN Age > 50 THEN 'Above 50'
         WHEN Age BETWEEN 30 AND 49 THEN 'Between 30–49'
         ELSE 'Below 30'
    END                                     AS Age_range,
    SUM(Readmissions) as Total_readmissions,
    CASE WHEN SUM(Readmissions) >= 4 THEN 'High risk'
         WHEN SUM(Readmissions) BETWEEN 2 AND 3 THEN 'Moderate risk'
         ELSE 'Low risk'
        END                                 AS Risk_category
FROM Patient_readmission
GROUP BY 
Patient_key,
First_name,
Last_name,
Age
ORDER BY Total_readmissions DESC

-- Group patients into three risk categories high, moderate and low based on the 
-- total number of procedures, including their total average base cost.
WITH Procedures_summary AS (
SELECT
    pr.Patient_key,
    p.First_name,
    p.Last_name,
    COUNT(*) as Total_procedures,
    ROUND(CAST(AVG(Procedure_base_cost) AS FLOAT), 2)     AS Avg_base_cost
FROM gold.fact_procedures pr
LEFT JOIN gold.dim_patients p
    ON pr.Patient_key = p.Patient_key
GROUP BY pr.Patient_key,
p.First_name,
p.Last_name
)
SELECT
    Patient_key,
    First_name,
    Last_name,
    Total_procedures,
    Avg_base_cost,
    CASE WHEN Total_procedures >= 10 THEN 'High'
         WHEN Total_procedures BETWEEN 4  AND 9 THEN 'Moderate'
         ELSE 'Low'
    END as Risk_category
FROM Procedures_summary
ORDER BY Total_procedures DESC

-- Evaluate the financial performance of each payer by calculating the total claim cost and total payer coverage 
-- associated with their encounters. 
-- Determine the percentage of total claim costs covered by each payer and classify the payers into three
-- coverage performance tiers: High Coverage (>= 75%), Moderate Coverage (50–74%), and Low Coverage (< 50%).
WITH Payer_summary AS (
SELECT
    Payer_key,
    Payer_name,
    Total_claim_cost,
    Total_coverage,
    ROUND(CAST(
    CASE WHEN Total_claim_cost = 0 THEN NULL
         ELSE Total_coverage / Total_claim_cost * 100 
         END AS FLOAT), 2)                            AS Percentage_coverage
FROM (
    SELECT
        e.Payer_key,
        py.Payer_name,
        SUM(e.Total_claim_cost)                       AS Total_claim_cost,
        SUM(e.Payer_coverage)                         AS Total_coverage
    FROM gold.fact_encounters e
    LEFT JOIN gold.dim_payers py
        ON e.Payer_key = py.Payer_key
    GROUP BY 
    e.Payer_key,
    py.Payer_name
)t
)
SELECT
    Payer_key,
    Payer_name,
    Total_claim_cost,
    Total_coverage,
    Percentage_coverage,
    CASE WHEN Percentage_coverage >= 75 THEN 'High coverage'
         WHEN Percentage_coverage BETWEEN 50 AND 74 THEN 'Moderate coverage'
         ELSE 'Low coverage'
END                                               AS Coverage_performance
FROM Payer_summary
ORDER BY Percentage_coverage DESC
