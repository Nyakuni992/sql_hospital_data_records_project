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
--> 1) Base query: Retrives core columns from the tables
    SELECT
        e.Patient_Key,
        e.Encounter_start_time,
        e.Encounter_end_time,
        e.Encounter_code,
        e.Encounter_code_description,
        e.Encounter_Class,
        e.Total_claim_cost,
        e.Payer_coverage,
        CONCAT(p.First_name, ' - ',p.Last_name)                             AS Patient_name,
        DATEDIFF(Year, p.Birth_date,GETDATE())                              AS Age,
        p.Gender,
        p.Race,
        p.City,
        pr.Procedure_code,
        pr.Procedure_base_cost,
        DATEDIFF(Hour, e.Encounter_start_time, e.Encounter_end_time)        AS Length_of_encounter,
        DATEDIFF(DAY, Encounter_end_time, LEAD(Encounter_start_time) OVER 
                (PARTITION BY e.Patient_key ORDER BY Encounter_start_time)) AS Readmission
   FROM gold.fact_encounters e
   LEFT JOIN gold.dim_patients p
       ON e.Patient_Key = p.Patient_Key
   LEFT JOIN gold.fact_procedures pr
       ON e.Encounter_id = pr.Encounter_id
   WHERE Encounter_start_time IS NOT NULL
    )
, Patient_aggregation AS (
--> 2) Patient aggregation: Consolidates key performance metrics at the individual patient level
    SELECT 
        Patient_key,
        Patient_name,
        Gender,
        Race,
        Age,
        City,
	    COUNT(Patient_key)                                                    AS Total_encounters,
	    SUM(Total_claim_cost)                                                 AS Total_claim_cost,
        ROUND(CAST(AVG(Total_claim_cost) AS FLOAT), 2)                      AS Avg_total_claim,
	    SUM(Payer_coverage)                                                   AS Total_payer_coverage,
        AVG(Length_of_encounter)                                            AS Avg_encounter_duration_hours,
        MIN(Encounter_start_time)                                           AS First_encounter,
        MAX(Encounter_start_time)                                           AS Last_encounter,
        SUM(CASE WHEN Readmission BETWEEN 1 AND 30 THEN 1 ELSE 0 
            END)                                                            AS Total_30day_readmissions,
        ROUND(CAST(
              SUM(CASE WHEN Readmission BETWEEN 1 AND 30 THEN 1 ELSE 0 END) AS FLOAT) / 
              COUNT(Patient_key) * 100, 2)                                  AS Readmission_rate,
        ROUND(CAST(AVG(Procedure_base_cost) AS FLOAT), 2)                   AS Avg_procedure_cost,
        COUNT(Procedure_code)                                               AS Total_procedures
     FROM Base_query
     GROUP BY Patient_key,
              Patient_name,
              Gender,
              Race,
              Age,
              City

)
--> Final Query
    SELECT
        Patient_key,
        Patient_name,
        Gender,
        Race,
        Age,
        CASE WHEN Age >= 50 THEN 'Above 50'
             WHEN Age BETWEEN 30 AND 49 THEN '30-49'
             ELSE 'Below 30'
             END                                                            AS Age_group,
        City,
        Total_encounters,
        Total_procedures,
	    Total_claim_cost,
        Avg_total_claim,
	    Total_payer_coverage,
        Total_30day_readmissions,
        CONCAT(Readmission_rate, '%')                                       AS Readmission_rate,
        Avg_procedure_cost,
        CASE WHEN Total_30day_readmissions >= 3 OR Readmission_rate >= 50 THEN 'High Risk'
             WHEN Total_30day_readmissions BETWEEN 1 AND 2 
             OR Readmission_rate BETWEEN 20 AND 49 THEN 'Moderate Risk' ELSE 'Low Risk'
        END                                                                  AS Risk_category,
        CASE WHEN  Avg_encounter_duration_hours >= 24 THEN 'Over 24 Hours'
             ELSE 'Under 24 Hours'
	    END                                                                  AS Avg_encounter_duration,
        Avg_encounter_duration_hours,
        First_encounter,
        Last_encounter
      FROM Patient_aggregation
      
   
