/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
--Loading Data Into The Bronze Layer

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
       
      BEGIN TRY
        SET @batch_start_time = GETDATE();
		PRINT'===================================================';
		PRINT'Loading Bronze Layer';
		PRINT'===================================================';

        SET @start_time = GETDATE();
        PRINT '>>Truncanting table: bronze.patients'
        TRUNCATE TABLE bronze.patients;

        PRINT '>>Inserting Data Into: bronze.patients'
        BULK INSERT bronze.patients
        FROM 'C:\HospitalRecords\patients.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        
        SET @end_time = GETDATE();
        PRINT '>>Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
        PRINT '>>-----------------------------------------------';
        
        
        SET @start_time = GETDATE();
        PRINT '>>Truncanting table: bronze.encounters'
        TRUNCATE TABLE bronze.encounters;

        PRINT '>>Inserting Data Into: bronze.encounters'
        BULK INSERT bronze.encounters
        FROM 'C:\HospitalRecords\encounters.csv'
        WITH(
         
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK

        );
        SET @end_time = GETDATE();
        PRINT'>>Loading duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
        PRINT '>>-------------------------------------------------';


        SET @start_time = GETDATE();
        PRINT'>>Truncating table: bronze.payers';
        TRUNCATE TABLE bronze.payers;

        PRINT'>>Inserting Data Into: bronze.payers';
        BULK INSERT bronze.payers
        FROM 'C:\HospitalRecords\payers.csv'
        WITH(
         
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK

        );

        SET @end_time = GETDATE();
        PRINT'>>Loading duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
        PRINT '>>---------------------------------------------------';

        
        SET @start_time = GETDATE();
        PRINT '>>Truncanting table: bronze.procedures'
        TRUNCATE TABLE bronze.procedures;

        PRINT '>>Inserting Data Into: bronze.procedures'
        BULK INSERT bronze.procedures
        FROM 'C:\HospitalRecords\procedures.csv'
        WITH(
         
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK

        );

        SET @end_time = GETDATE();
        PRINT'>>Loading duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
        PRINT '>>---------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>>Truncanting table: bronze.organizations'
        TRUNCATE TABLE bronze.organizations;

        PRINT '>>Inserting Data Into: bronze.organizations'
        BULK INSERT bronze.organizations
        FROM 'C:\HospitalRecords\organizations.csv'
        WITH(
         
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK

        );
        
        SET @batch_end_time = GETDATE();
		PRINT'=============================='
		PRINT'Loading Bronze Layer is Completed';
		PRINT'-Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds';
		PRINT'=============================='
	END TRY
	BEGIN CATCH
	PRINT'==================================='
	PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER'
	PRINT'Error Message' + ERROR_MESSAGE();
	PRINT'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
	PRINT'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
	PRINT'==================================='
	END CATCH
END


