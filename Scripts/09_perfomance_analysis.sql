-- c. What are the total number of encounters that were over 24 hours versus under 24 hours?

WITH Duration_category AS (
SELECT 
    Encounter_id,
    CASE WHEN DATEDIFF(Hour, Encounter_start_time, Encounter_end_time) >= 24 THEN 'Over 24 Hours' ELSE 'Under 24 Hours'
	  END   AS Encounter_duration
FROM gold.fact_encounters   
)
SELECT
    COUNT(*) AS Total_encounter,
    Encounter_duration
FROM Duration_category
GROUP BY Encounter_duration
--"Analyze the yearly performance of the encounter_class by comparing each encounter_class's total claim cost 
--to both its average total claim cost performance and the previous year's total claim cost."
SELECT
        Encounter_year,
        Encounter_class,
        Current_total_claim_cost,
        AVG(Current_total_claim_cost) OVER (PARTITION BY Encounter_class) AS Avg_total_claim_cost,
        Current_total_claim_cost - AVG(Current_total_claim_cost) OVER (PARTITION BY Encounter_class) AS Diff_avg,

        CASE WHEN Current_total_claim_cost - AVG(Current_total_claim_cost) OVER (PARTITION BY Encounter_class) > 0 
             THEN 'Above average'
             WHEN Current_total_claim_cost - AVG(Current_total_claim_cost) OVER (PARTITION BY Encounter_class) < 0 
             THEN 'Below average'
             ELSE 'Average'
             END                                                                                  AS Change_in_avg,
        LAG(Current_total_claim_cost) OVER (PARTITION BY Encounter_class ORDER BY Encounter_year) AS Previous_year_total_claim,
        Current_total_claim_cost - LAG(Current_total_claim_cost) OVER 
                 (PARTITION BY Encounter_class ORDER BY Encounter_year ASC)                       AS diff_per_year,
        CASE WHEN Current_total_claim_cost - LAG(Current_total_claim_cost) OVER 
                  (PARTITION BY Encounter_class ORDER BY Encounter_year ASC) > 0 THEN 'Increase'
             WHEN Current_total_claim_cost - LAG(Current_total_claim_cost) OVER 
                   (PARTITION BY Encounter_class ORDER BY Encounter_year ASC) < 0 THEN 'Decrease'
             ELSE 'No change'
             END                                                                                  AS Change_in_total_claim
FROM (
        SELECT
            YEAR(Encounter_start_time) AS Encounter_year,
            Encounter_class,
            SUM(Total_claim_cost) AS Current_total_claim_cost
        FROM gold.fact_encounters
        WHERE YEAR(Encounter_start_time) IS NOT NULL
        GROUP BY YEAR(Encounter_start_time),
                 Encounter_class
)t

-- Analyze the yearly performance of encounter volume by comparing each year's total encounters to both the historical 
-- average encounters and the previous year's encounters including the year over year encounter growth rate.
WITH Yearly_encounters AS (
SELECT
    Year(Encounter_start_time)                                        AS Encounter_year,
    COUNT(*)                                                          AS Total_encounters
    FROM gold.fact_encounters
    GROUP BY Year(Encounter_start_time)
)

SELECT
Encounter_year,
Total_encounters,
AVG(Total_encounters) OVER ()                                           AS Historical_avg,
Total_encounters - AVG(Total_encounters) OVER ()                        AS Diff_avg,
CASE WHEN Total_encounters - AVG(Total_encounters) OVER () > 0 THEN 'Above historical average'
     WHEN Total_encounters - AVG(Total_encounters) OVER () < 0 THEN ' Below historical average'
     ELSE 'No change'
     END                                                                 AS Change_avg_encounters,
LAG(Total_encounters) OVER (ORDER BY Encounter_year)                     AS Previous_total_encounters,
Total_encounters - LAG(Total_encounters) OVER (ORDER BY Encounter_year)  AS Diff_encounters,
CASE WHEN Total_encounters - LAG(Total_encounters) OVER (ORDER BY Encounter_year) > 0 THEN 'Increase'
     WHEN Total_encounters - LAG(Total_encounters) OVER (ORDER BY Encounter_year) < 0 THEN 'Decrease'
     ELSE 'No change'
END as Change_in_encounters,
ROUND((Total_encounters - LAG(Total_encounters) OVER (ORDER BY Encounter_year)) /
CAST(LAG(Total_encounters) OVER (ORDER BY Encounter_year) AS FLOAT) * 100, 2) AS YoY_growth_rate
FROM Yearly_encounters
