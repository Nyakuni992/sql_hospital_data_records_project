/*======================================================================================
Encounter Performance Report
========================================================================================
Purpose
* This report provides a consolidated view of encounter activity and performance across
  the healthcare system. 
Key Components
   1. Core Encounter Attributes
       * Retrieves essential encounter-level fields including:
         • Encounter class
         • Encounter year
         • Encounter time stamp
         • Associated financial measures
   2. Aggregated Encounter Metrics
       * Computes summary metrics at the encounter reporting level:
         • Total encounters
         • Number of unique patients
         • Total claim cost
         • Total payer coverage
         • Total 30-day readmissions
   3. Operational and Financial KPIs
       * Calculates key performance indicators used to evaluate encounter efficiency
         and financial performance:
         • Average length of stay (hours)
         • Readmission rate
         • Avg_base_encounter_cost
         • Average total claim cost 
         • Average payer coverage 
   4. Encounter Volume Benchmarking
       * Ranks encounter volume by year per encounter class to highlight periods of higher or lower
         healthcare utilization and support trend analysis across reporting periods.
  ========================================================================================
  */

CREATE VIEW gold.report_encounters AS   
WITH Base_query AS (
--> Base query: Retrives core columns from the tables
SELECT
    e.Patient_key,
    p.Gender,
    DATEDIFF(YEAR, p.Birth_date, GETDATE())                      AS Age,
    p.Race,
    p.City,
    e.Encounter_start_time,
    e.Encounter_end_time,
    YEAR( e.Encounter_start_time)                                AS Encounter_year,
    MONTH( e.Encounter_start_time)                               AS Encounter_month,
    DATEDIFF(HOUR, e.Encounter_start_time, e.Encounter_end_time) AS Encounter_duration_hours,
    CASE WHEN DATEDIFF(DAY, e.Encounter_end_time, LEAD( e.Encounter_start_time) OVER 
         (PARTITION BY e.Patient_key ORDER BY  e.Encounter_start_time))
         BETWEEN 1 AND 30 THEN 1 
         ELSE 0
         END                                                     AS Readmission,
    e.Encounter_class,
    e.Base_encounter_cost,
    e.Total_claim_cost,
    e.Payer_coverage
FROM gold.fact_encounters e
LEFT JOIN gold.dim_patients p
ON e.Patient_key = p.Patient_key
WHERE e.Encounter_start_time IS NOT NULL

)
, Encounter_aggregations AS (
--> Encounter aggregations: Provides a summary of key operational performance metrics for each encounter class.
SELECT
     Encounter_class,
     Encounter_year,
     COUNT(*)                                                    AS Total_encounters,
     COUNT(DISTINCT Patient_key)                                 AS Unique_patients,
     ROUND(CAST(AVG(Base_encounter_cost)AS FLOAT), 2)            AS Avg_base_cost,
     SUM(Total_claim_cost)                                       AS Total_claim_cost,
     ROUND(CAST(AVG(Total_claim_cost)AS FLOAT), 2)               AS Avg_claim_cost,
     SUM(Payer_coverage)                                         AS Total_payer_coverage,
     ROUND(CAST(AVG(Payer_coverage)AS FLOAT), 2)                 AS Avg_payer_coverage,
     ROUND(CAST(AVG(Encounter_duration_hours)AS FLOAT), 2)       AS Avg_length_of_stay,
     SUM(Readmission)                                            AS Total_30day_readmissions
FROM Base_query
GROUP BY Encounter_class,
         Encounter_year
)
--> Final query
SELECT
    Encounter_class,
    Encounter_year,
    Total_encounters,
    Total_encounters - LAG(Total_encounters) OVER 
                       (PARTITION BY Encounter_class ORDER BY Encounter_year)
                                                                AS Encounter_growth,
    Unique_patients,
    Avg_base_cost,
    Total_claim_cost,
    Total_payer_coverage,
    Avg_claim_cost,
    Avg_payer_coverage,
    Avg_length_of_stay,
    Total_30day_readmissions,
    CONCAT(ROUND(CAST(Total_30day_readmissions AS FLOAT) /  
               NULLIF(Total_encounters,0) * 100, 2), '%')      AS Readmission_rate,             
    DENSE_RANK() OVER (PARTITION BY Encounter_year 
                       ORDER BY Total_encounters DESC)          AS Encounter_volume_rank,       
    DENSE_RANK() OVER (PARTITION BY Encounter_year 
                       ORDER BY Total_claim_cost DESC)          AS Encounter_revenue_rank                                  
FROM Encounter_aggregations
