--Calculate the total claim cost, the running total claim costs and the payer coverage moving average over time.
SELECT
    Encounter_year,
    Total_claim_cost_per_year,
    SUM(Total_claim_cost_per_year) OVER (ORDER BY Encounter_year)                 AS Cumulative_total_cost,
    AVG(Avg_payer_coverage) OVER (ORDER BY Encounter_year)                        AS Moving_avg_payer_coverage
FROM(
    SELECT
        DATETRUNC(Year,Encounter_start_time) AS Encounter_year,
        SUM(Total_claim_cost) AS Total_claim_cost_per_year,
        AVG(Payer_coverage) AS Avg_payer_coverage
    FROM gold.fact_encounters
    GROUP BY DATETRUNC(Year,Encounter_start_time)
)t
