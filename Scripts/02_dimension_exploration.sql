--Explore all address citys of the patients 
SELECT DISTINCT 
  City 
  FROM gold.dim_patients

--Explore all the different Insuarance payers and their address
SELECT DISTINCT 
  Payer_name,
  Address
FROM gold.dim_payers 

--Explore all the different Organizations
SELECT DISTINCT 
  Name,
  Address
FROM gold.dim_organizations 
