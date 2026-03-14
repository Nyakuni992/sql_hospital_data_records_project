--For each year, find the total number of encounters, total claim cost.
SELECT
    Year(Encounter_start_time)                          AS Encounter_year,
    COUNT(*)                                            AS Total_encounters,
    SUM(Total_claim_cost)                               AS Total_claim_cost,
    SUM(Payer_coverage)                                 AS Total_payer_coverage
FROM gold.fact_encounters
GROUP BY Year(Encounter_start_time)
ORDER BY Year(Encounter_start_time) ASC

-- Find the total number pf procedures carried out per month
    SELECT
    DATETRUNC(Month, Procedure_start_time)              AS Procedure_month_year,
    COUNT(*) as Total_procedures
FROM gold.fact_procedures
GROUP BY DATETRUNC(Month, Procedure_start_time)
ORDER BY DATETRUNC(Month, Procedure_start_time)

-- How many unique patients were admitted each quarter over time?

SELECT
    CONCAT(YEAR(Encounter_start_time),'-Q', DATEPART(QUARTER, Encounter_start_time)) AS Year_quarter,
    COUNT(DISTINCT Patient_key) as Unique_patients
FROM gold.fact_encounters 
WHERE Encounter_class = 'Inpatient'
GROUP BY YEAR(Encounter_start_time),
         DATEPART(QUARTER, Encounter_start_time)
ORDER BY YEAR(Encounter_start_time),
         DATEPART(QUARTER, Encounter_start_time)

--Find the total number of readmissions per year.
SELECT
    Year(Encounter_end_time)                          AS Encounter_year,
    SUM(Readmission)                                  AS Total_readmissions
FROM (
SELECT
    Patient_key,
    Encounter_end_time,
CASE WHEN DATEDIFF(Day, Encounter_end_time,LEAD(Encounter_start_time) OVER 
          (PARTITION BY Patient_key ORDER BY Encounter_end_time)) 
     BETWEEN 1 AND 30 THEN 1 
     ELSE 0
END                                                  AS Readmission
FROM gold.fact_encounters
WHERE Encounter_class = 'Inpatient'
)t
GROUP BY Year(Encounter_end_time)
ORDER BY Year(Encounter_end_time) ASC

--Find the total number of discharges per month
SELECT
    DATETRUNC(Month, Encounter_end_time)                          AS Encounter_month,
    COUNT(*) as Total_discharges
FROM gold.fact_encounters
WHERE Encounter_end_time IS NOT NULL AND Encounter_class = 'Inpatient'
GROUP BY DATETRUNC(Month, Encounter_end_time)
ORDER BY DATETRUNC(Month, Encounter_end_time) ASC
