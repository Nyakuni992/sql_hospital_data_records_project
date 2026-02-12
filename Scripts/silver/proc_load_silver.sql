/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    import the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading Encounters';
		PRINT '------------------------------------------------';

		-- Loading silver.encounters
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.encounters';
		TRUNCATE TABLE silver.encounters;
		PRINT '>> Inserting Data Into: silver.encounters';
		INSERT INTO silver.encounters (
			Id,
			Start,
			Stop,
			Patient,
			Organization,
			Payer,
			Encounter_class,
			Code,
			Description,
			Base_encounter_cost,
			Total_claim_cost,
			Payer_coverage,
			Reason_code,
			Reason_description
		)
		SELECT 
			Id ,
			CAST([Start] AS datetime) as Start,
			CAST([Stop] AS datetime) as Stop,
			Patient,
			Organization,
			Payer,
			CASE WHEN UPPER(TRIM(Encounter_Class)) = 'ambulatory' THEN 'Ambulatory'
				   WHEN UPPER(TRIM(Encounter_Class)) = 'urgentcare' THEN 'Urgentcare'
				   WHEN UPPER(TRIM(Encounter_Class)) = 'emergency' THEN 'Emergency'
				   WHEN UPPER(TRIM(Encounter_Class)) = 'inpatient' THEN 'Inpatient'
				   WHEN UPPER(TRIM(Encounter_Class)) = 'outpatient' THEN 'Outpatient'
				   WHEN UPPER(TRIM(Encounter_Class)) = 'wellness' THEN 'Wellness'
				   ELSE 'n/a'
			END Encounter_class,
			Code,
			Description,
			Base_Encounter_cost,
			Total_claim_cost,
			Payer_coverage,
			Reason_code,
			Reason_description
			FROM bronze.encounters
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		
		PRINT '------------------------------------------------';
		PRINT 'Loading Organizations';
		PRINT '------------------------------------------------';

		-- Loading silver.organizations
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.organizations';
		TRUNCATE TABLE silver.organizations;
		PRINT '>> Inserting Data Into: organizations';
		INSERT INTO silver.organizations (
			Id,
			Name,
			Address,
			City,
			State,
			Zip,
			Lat,
			Lon
		)
		SELECT 
			Id,
			CASE WHEN Name = 'MASSACHUSETTS GENERAL HOSPITAL' THEN 'Massachusetts General Hospital'
				 ELSE 'n/a'
			END as Name,
			CASE WHEN Address = '55 FRUIT STREET' THEN '55 Fruit Street'
				 ELSE 'n/a'
			   END as Address,
			CASE WHEN City = 'BOSTON' THEN 'Boston'
				 ELSE 'n/a'
			   END as 'City',
			State,
			Zip,
			Lat,
			Lon
			FROM bronze.organizations

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		PRINT '------------------------------------------------';
		PRINT 'Loading Patients';
		PRINT '------------------------------------------------';
    -- Loading patients
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.patients';
		TRUNCATE TABLE silver.patients;
		PRINT '>> Inserting Data Into: silver.patients';
		INSERT INTO silver.patients (
			Id,
			Birth_date,
			Death_date,
			Prefix,
			First,
			Last,
			Suffix,
			Maiden,
			Marital_status,
			Race,
			Ethnicity,
			Gender,
			Birth_place,
			Address,
			City,
			State,
			County,
			Zip,
			Lat,
			Lon
		)
		SELECT
			Id,
		    CASE
				WHEN Birthdate > GETDATE() THEN NULL
				ELSE Birthdate
			END AS Birthdate, 
			Deathdate,
			Prefix,
			First,
			Last,
			Suffix,
			Maiden,
			CASE WHEN Maritalstatus = 'S' THEN 'Single'
					WHEN Maritalstatus = 'M' THEN 'Married'
					ELSE 'n/a'
			END as Maritalstatus,
			CASE WHEN UPPER(TRIM(Race)) = 'asian' THEN 'Asian'
					WHEN UPPER(TRIM(Race)) = 'black' THEN 'Black'
					WHEN UPPER(TRIM(Race)) = 'white' THEN 'White'
					WHEN UPPER(TRIM(Race)) = 'hawaiian' THEN 'Hawaiian'
					WHEN UPPER(TRIM(Race)) = 'native' THEN 'Native'
					WHEN UPPER(TRIM(Race)) = 'other' THEN 'Other'
					ELSE 'n/a'
				END Race,
			CASE WHEN UPPER(TRIM(Ethnicity)) = 'nonhispanic' THEN 'Non Hispanic'
					WHEN UPPER(TRIM(Ethnicity)) = 'hispanic' THEN 'Hispanic'
					ELSE 'n/a'
				END Ethnicity,
			CASE WHEN Gender = 'F' THEN 'Female'
					WHEN Gender = 'M' THEN 'Male'
					ELSE 'n/a
			END as Gender,
			Birthplace,
			Address,
			City,
			State,
			County,
			COALESCE(CAST(Zip AS NVARCHAR), 'n/a') as Zip,
			Lat,
			Lon
			FROM bronze.patients
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		PRINT '------------------------------------------------';
		PRINT 'Loading Payers';
		PRINT '------------------------------------------------';

        -- Loading Payers
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.payers';
		TRUNCATE TABLE silver.payers;
		PRINT '>> Inserting Data Into: silver.payers';
		INSERT INTO silver.payers (
			Id,
			Name,
			Address,
			City,
			State_headquatered,
			Zip,
			Phone
		)
		SELECT
			Id,
			CASE WHEN UPPER(TRIM(Name)) IN ('NO_INSURANCE') THEN 'Self Pay' ELSE Name
			END Name,-- Set patient with no insuarance to self pay
			Address,
			City,
			State_headquatered,
			CASE WHEN Zip IS NOT NULL
				 AND LEN(Zip) < 5
				 AND Zip NOT LIKE '%[^0-9]%' THEN RIGHT('00000' + Zip, 5)
				 ELSE Zip
				 END AS Zip,
			Phone
			FROM bronze.payers
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

	    PRINT '------------------------------------------------';
		PRINT 'Loading Procedures';
		PRINT '------------------------------------------------';
        -- Loading procedures
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.procedures';
		TRUNCATE TABLE silver.procedures;
		PRINT '>> Inserting Data Into: silver.procedures';
		INSERT INTO silver.procedures (
			Start,
			Stop,
			Patient,
			Encounter,
			Code,
			Description,
			Base_cost,
			Reason_code,
			Reason_description 
		)
		SELECT
			Start,
			Stop,
			Patient,
			Encounter,
			Code,
			Description,
			Base_cost,
			Reasoncode,
			Reasondescription
		FROM bronze.procedures 
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
		
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END

