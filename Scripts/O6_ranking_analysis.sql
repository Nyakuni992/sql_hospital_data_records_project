-- b. What are the top 10 most frequent procedures performed.
SELECT 
    Procedure_code,
    Procedure_code_description,
    Procedure_count,
    Rank_procedure_count
FROM (
SELECT 
	  Procedure_code,
	  Procedure_code_description,
	  COUNT(*) as Procedure_count,
	  DENSE_RANK() OVER (ORDER BY COUNT(*) DESC)       AS Rank_procedure_count
FROM gold.fact_procedures
GROUP BY Procedure_code, 
         Procedure_code_description
)t
WHERE Rank_procedure_count <= 10
 
 -- c. What are the top 10 procedures with the highest average base cost and the number of times they were performed?
 
 SELECT
     Procedure_code,
     Procedure_code_description,
     Avg_Procedure_base_cost,
     Procedure_count,
     Avg_rank
 FROM (
     SELECT 
     Procedure_code,
     Procedure_code_description,
     ROUND(CAST(AVG(Procedure_base_cost) AS FLOAT), 2)                           AS Avg_Procedure_base_cost,
     COUNT(Patient_key) as Procedure_count,
     DENSE_RANK() OVER (ORDER BY CAST(AVG(Procedure_base_cost) AS FLOAT) DESC)   AS Avg_rank
     FROM gold.fact_procedures
     GROUP BY Procedure_code,
          Procedure_code_description
)t
WHERE Avg_rank <= 10
