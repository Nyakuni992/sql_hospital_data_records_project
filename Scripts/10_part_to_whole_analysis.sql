-- What percentage of total claim cost and payer coverage is contributed by each payer.

SELECT
    Payer_key,
    Payer_name,
    Total_claim_cost,
    ROUND(CAST(CASE WHEN SUM(Total_claim_cost) OVER () = 0 THEN NULL
                    ELSE Total_claim_cost / SUM(Total_claim_cost) OVER () * 100
                END AS FLOAT), 2)                                               AS Percentage_total_cost,
    Total_coverage,
    ROUND(CAST(CASE WHEN SUM(Total_coverage) OVER () = 0 THEN NULL
                    ELSE Total_coverage / SUM(Total_coverage) OVER () * 100
               END AS FLOAT), 2)                                                 AS Percentage_coverage
FROM(
    SELECT
        e.Payer_key,
        py.Payer_name,
        SUM(e.Total_claim_cost)                                                  AS Total_claim_cost,
        SUM(Payer_coverage)                                                      AS Total_coverage
    FROM gold.fact_encounters e
    LEFT JOIN gold.dim_payers py
        ON e.Payer_key = py.Payer_key
    GROUP BY  
        e.Payer_key,
        py.Payer_name
)t
ORDER BY Percentage_total_cost DESC

-- For each year, what percentage of all encounters belonged to each encounter class
SELECT
	Encounter_class,
	Encounter_year,
	Encounters_per_class_per_year,
	ROUND(Encounters_per_class_per_year / 
	CAST(SUM(Encounters_per_class_per_year) OVER (PARTITION BY Encounter_year)AS FLOAT) * 100, 2) 
	                                                                                   AS Percentage_per_class_per_year
FROM (
	SELECT
		Encounter_class,
		YEAR(Encounter_start_time)                         AS Encounter_year,
		COUNT(Encounter_id)                                AS Encounters_per_class_per_year
	FROM gold.fact_encounters
	GROUP BY YEAR(Encounter_start_time), Encounter_class
	)t
ORDER BY Encounter_year ASC

-- c. What percentage of encounters were over 24 hours versus under 24 hours?

WITH Duration_category AS (
SELECT 
    Encounter_id,
    CASE WHEN DATEDIFF(Hour, Encounter_start_time, Encounter_end_time) >= 24 THEN 'Over 24 Hours'
         ELSE 'Under 24 Hours'
	     END                                                       AS Encounter_duration
FROM gold.fact_encounters   
)
SELECT
    Encounter_duration,
    COUNT(*)                                                         AS Total_encounter,
    ROUND(COUNT(*) / CAST(SUM(COUNT(*)) OVER () AS FLOAT) * 100, 2)  AS Percentage_of_encounters
FROM Duration_category
GROUP BY Encounter_duration
