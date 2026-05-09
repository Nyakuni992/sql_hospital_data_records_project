/*====================================================================================================
Procedure Performance Report
======================================================================================================
Purpose:
    This report provides a consolidated view of procedure-related activity and performance within the
    healthcare system. It summarizes procedure volume, operational duration, and financial impact to
    support analytical evaluation of clinical procedures across reporting periods.

Key Components
    1) Core Procedure Attributes
        Retrieves essential procedure-level fields including:
        • Procedure code
        • Procedure description
        • Encounter year
    2) Aggregated Procedure Metrics
        Computes summary metrics associated with each procedure:
        • Total procedures performed
        • Number of unique patients receiving the procedure
        • Total procedure cost
        • Total procedure duration (minutes)
    3) Operational and Financial KPIs
        Calculates key indicators used to evaluate procedure performance and efficiency:
        • Average procedure cost
        • Average procedure duration
        • Average cost per procedure minute
        • Highest recorded procedure cost
        • Lowest recorded procedure cost
        • Procedure frequency ranking
        • Procedure revenue ranking
====================================================================================================
*/
CREATE VIEW gold.report_procedures AS
WITH Base_query AS (
--> 1) Base query: Retrives core columns from the tables
SELECT
    pr.Procedure_code,
    pr.Procedure_code_description,
    pr.Patient_key,
    pr.Procedure_start_time,
    pr.Procedure_end_time,
    YEAR(Procedure_start_time)                                                AS Procedure_year,
    MONTH(Procedure_start_time)                                               AS Procedure_month,
    pr.Procedure_base_cost,
    DATEDIFF(MINUTE, pr.Procedure_start_time, pr.Procedure_end_time)          AS Procedure_duration_minutes
FROM gold.fact_procedures pr
LEFT JOIN gold.dim_patients p
    ON pr.Patient_key = p.Patient_key
WHERE
    pr.Procedure_start_time < p.Death_date OR p.Death_date IS NULL
    
)

, Procedure_performance AS (
--> Procedure performance: Summarizes important performance indicators for procedures performed.
SELECT
    Procedure_code,
    Procedure_code_description,
    COUNT(*)                                                                   AS Total_procedures,
    COUNT(DISTINCT Patient_key)                                                AS Unique_patients,
    SUM(Procedure_base_cost)                                                   AS Total_procedure_cost,
    ROUND(CAST(AVG(Procedure_base_cost)AS FLOAT),2)                            AS Avg_procedure_cost,
    MAX(Procedure_base_cost)                                                   AS Highest_procedure_cost,
    MIN(Procedure_base_cost)                                                   AS Lowest_procedure_cost,
    ROUND(AVG(CAST(Procedure_duration_minutes AS FLOAT)), 2)                   AS Avg_procedure_duration,
    SUM(Procedure_duration_minutes)                                            AS Total_procedure_minutes,
    ROUND(CAST(COALESCE(SUM(Procedure_base_cost)/ 
         NULLIF(SUM(Procedure_duration_minutes),0),0)AS FLOAT),2)              AS Avg_cost_per_minute
FROM Base_query
GROUP BY
    Procedure_code,
    Procedure_code_description

)

--> Final Query
SELECT
    Procedure_code,
    Procedure_code_description,
    Total_procedures,
    Unique_patients,
    Total_procedure_cost,
    Avg_procedure_cost,
    Highest_procedure_cost,
    Lowest_procedure_cost,
    Avg_procedure_duration,
    Total_procedure_minutes,
    Avg_cost_per_minute,
    DENSE_RANK() OVER (ORDER BY Total_procedures DESC)                              AS Procedure_frequency_rank,
    DENSE_RANK() OVER (ORDER BY Total_procedure_cost DESC)                          AS Procedure_revenue_rank
FROM Procedure_performance


