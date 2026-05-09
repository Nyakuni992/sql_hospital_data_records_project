 /*=======================================================================================
 Patient Report
 =========================================================================================
 Purpose
   This report provides a comprehensive analysis of patient activity, healthcare utilization, and financial impact by 
   consolidating key patient-level metrics. It is designed to support operational monitoring, cost analysis, and patient risk 
   identification within the healthcare system.
 
Key Features
    1. Patient Information
         Retrieves core patient attributes including patient name, age, and encounter-related details.
    2. Patient Risk Segmentation
         Categorizes patients into three utilization-based risk groups: High risk, Moderate risk and Low risk
    3. Patient-Level Aggregated Metrics
         Summarizes critical healthcare activity metrics for each patient, including:
           - Total encounters
           - Total procedures
           - Total claim cost
           - Total payer coverage
           - Total 30-day readmissions
    4. Key Performance Indicators (KPIs)
         Calculates important performance and cost indicators used in healthcare analytics:
            - Readmission rate
            - Average procedure cost
            - Average total claim cost
            - Average encounter duration (in hours)
==========================================================================================
*/
  
CREATE VIEW gold.report_patients AS 
WITH Base_query AS (
--> 1) Base query: Retrives core columns from the encounter table.
    SELECT
        e.Encounter_id,
        e.Patient_key,
        e.Encounter_start_time,
        e.Encounter_end_time,
        e.Total_claim_cost,
        e.Payer_coverage,
        DATEDIFF(HOUR, e.Encounter_start_time, e.Encounter_end_time)                                AS Length_of_encounter,
        DATEDIFF(DAY, e.Encounter_end_time,LEAD(e.Encounter_start_time) 
                 OVER (PARTITION BY e.Patient_key ORDER BY e.Encounter_start_time))                 AS Readmission
    FROM gold.fact_encounters e
    WHERE e.Encounter_start_time IS NOT NULL
)
, Procedure_aggregation AS (
--> 2) Procedure aggregation: Aggregates key procedure columns from the procedure table.
    SELECT
        Encounter_id,
        COUNT(*)                                                                                     AS Total_procedures,
        AVG(Procedure_base_cost)                                                                     AS Avg_procedure_cost
    FROM gold.fact_procedures
    GROUP BY Encounter_id   
)
, Combined_query AS (
--> Combined query: Joins the Procedure_aggregation to the Base query.
    SELECT
        b.*,
        pr.Total_procedures,
        pr.Avg_procedure_cost
    FROM Base_query b
    LEFT JOIN Procedure_aggregation pr
        ON b.Encounter_id = pr.Encounter_id
    
)
, Patient_aggregation AS (
--> Patient aggregation: Consolidates key performance metrics at the individual patient level
    SELECT
        c.Patient_key,
        p.First_name,
        p.Last_name,
        p.Birth_date,
        p.Gender,
        p.Race,
        p.City,
        COUNT(DISTINCT Encounter_id)                                                                    AS Total_encounters,
        SUM(Total_claim_cost)                                                                           AS Total_claim_cost,
        ROUND(CAST(AVG(Total_claim_cost) AS FLOAT),2)                                                   AS Avg_total_claim,
        SUM(Payer_coverage)                                                                             AS Total_payer_coverage,
        AVG(Length_of_encounter)                                                                        AS Avg_encounter_duration_hours,
        MIN(Encounter_start_time)                                                                       AS First_encounter,
        MAX(Encounter_start_time)                                                                       AS Last_encounter,
        SUM(CASE WHEN Readmission BETWEEN 1 AND 30 THEN 1 ELSE 0 
            END)                                                                                        AS Total_30day_readmissions,
        ROUND(CAST(
              SUM(CASE WHEN Readmission BETWEEN 1 AND 30 THEN 1 ELSE 0 END) AS FLOAT) / 
              COUNT(DISTINCT c.Encounter_id) * 100, 2)                                                  AS Readmission_rate,
        SUM(Total_procedures)                                                                           AS Total_procedures,
        ROUND(CAST(AVG(Avg_procedure_cost) AS FLOAT), 2)                                                AS Avg_procedure_cost
    FROM Combined_query c
    LEFT JOIN gold.dim_patients p
    ON c.Patient_key = p.Patient_key
    GROUP BY 
            c.Patient_key,
            p.First_name,
            p.Last_name,
            p.Birth_date,
            p.Gender,
            p.Race,
            p.City
)
--> Final Query
    SELECT
        Patient_key,
        CONCAT(First_name, ' - ',Last_name)                                                            AS Patient_name,
        DATEDIFF(Year, Birth_date,GETDATE())                                                           AS Age,
        Gender,
        Race,
        CASE WHEN DATEDIFF(Year, Birth_date,GETDATE())  >= 50 THEN 'Above 50'
             WHEN DATEDIFF(Year, Birth_date,GETDATE())  BETWEEN 30 AND 49 THEN '30-49'
             ELSE 'Below 30'
             END                                                                                       AS Age_group,
        City,
        Total_encounters,
        ISNULL(Total_procedures, 0)                                                                    AS Total_procedures,
        ISNULL(Avg_procedure_cost, 0)                                                                  AS Avg_procedure_cost,
	    Total_claim_cost,
        Avg_total_claim,
	    Total_payer_coverage,
        Total_30day_readmissions,
        CONCAT(Readmission_rate,'%')                                                                    AS Readmission_rate,
        CASE WHEN Total_30day_readmissions >= 3 OR Readmission_rate >= 50 THEN 'High Risk'
             WHEN Total_30day_readmissions BETWEEN 1 AND 2 
             OR Readmission_rate BETWEEN 20 AND 49 THEN 'Moderate Risk' ELSE 'Low Risk'
        END                                                                                             AS Risk_category,
        CASE WHEN  Avg_encounter_duration_hours >= 24 THEN 'Over 24 Hours'
             ELSE 'Under 24 Hours'
	    END                                                                                             AS Avg_encounter_duration,
        Avg_encounter_duration_hours,
        First_encounter,
        Last_encounter
      FROM Patient_aggregation
      
   SELECT * FROM gold.report_patients