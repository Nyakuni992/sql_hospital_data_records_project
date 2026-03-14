--Find the date of the first encounter and last encounter.
-- Find the number of encounter months and years available.
SELECT 
     MIN(Encounter_start_time) as First_encounter,
     MAX(Encounter_start_time) as Last_encounter,
     DATEDIFF(Month, MIN(Encounter_start_time) , MAX(Encounter_start_time))   AS Encounter_months,
     DATEDIFF(Year, MIN(Encounter_start_time) , MAX(Encounter_start_time))    AS Encounter_years
FROM gold.fact_encounters

--Find the longest and shortest procedure done
SELECT
     MAX(DATEDIFF(Hour,Procedure_start_time, Procedure_end_time))              AS Longest_procedure,
     MIN(DATEDIFF(Hour,Procedure_start_time, Procedure_end_time))              AS shortest_procedure
FROM gold.fact_procedures

--Find the youngest and oldest patient
SELECT 
    MIN(Birth_date)                                                             AS Oldest_birthdate,
    DATEDIFF(Year,MIN(Birth_date), GETDATE())                                   AS Oldest_patient,
    MAX(Birth_date)                                                             AS youngest_birthdate,
    DATEDIFF(Year,MAX(Birth_date), GETDATE())                                   AS youngest_patient
FROM gold.dim_patients 
