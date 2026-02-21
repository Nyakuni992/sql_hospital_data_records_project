# Data Catalog for Gold Layer

## Overview
The Gold Layer represents data at the business level, organized specifically for analytics and reporting. 
It is made up of dimension tables and fact tables designed to measure and analyze key business metrics.
---

### 1. **gold.dim_patients**
- **Purpose:** Stores patient details including demographic and geographic data.
- **Columns:**

| Column Name      | Data Type         | Description                                                                                                                                     |
|------------------|-------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| Patient _key     | INT               | Surrogate key uniquely identifying each Patient record in the dimension table.                                                                  |
| Patient_id       | UNIQUEIDENTIFIER  | Unique alphanumeric identifier assigned to each patient, (e.g '32c84703-2481-49cd-d571-3899d5820253').                                          |
| First_name       | NVARCHAR(50)      | The patient's first name, as recorded in the system.                                                                                            |
| Last_name        | NVARCHAR(50)      | The patient's last name.                                                                                                                        | 
| Gender           | NVARCHAR(50)      | The gender of the patient (e.g., 'Male', 'Female', 'n/a').                                                                                      |        
| Birthdate        | DATE              | The date of birth of the patient, formatted as YYYY-MM-DD (e.g., 1971-10-06).                                                                   |
| Death_date       | DATE              | The date of death of the patient, formatted as YYYY-MM-DD                                                                                       |
| Marital_status   | NVARCHAR(50)      | The marital status of the patient (e.g., 'Married', 'Single').                                                                                  |
| Race             | NVARCHAR(50)      | The race of the patient, (e.g. 'Native', 'Black', 'White').                                                                                     |
| Ethnicity        | NVARCHAR(50)      | The ethnicity of the patient, (e.g. 'Hispanic', 'Nonhispanic').                                                                                 | 
| Birth_place      | NVARCHAR(50)      | Name of the town where the patient was born.                                                                                                    |
| City             | NVARCHAR(50)      | Patient's address city.                                                                                                                         |
| State            | NVARCHAR(50)      | Patient's address state.                                                                                                                        |
| County           | NVARCHAR(50)      | Patient's address county.                                                                                                                       |  
| Zip_code         | NVARCHAR(50)      | Patient's zip code.                                                                                                                             |
| Latitude         | FLOAT             | Latitude of patient's address.                                                                                                                  |
| Longitude        | FLOAT             | Longitude of patient's address.                                                                                                                 |


---

### 2. **gold.dim_payers**
- **Purpose:** Provides the names and geographic details of the payers or insurance companies.
- **Columns:** 

| Column Name         | Data Type         | Description                                                                                                                                  |
|---------------------|-------------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| Payer_key           | INT               | Surrogate key uniquely identifying each payer record in the payer dimension table.                                                           |
| Payer_id            | UNIQUEIDENTIFIER  | A unique identifier assigned to each payer to facilitate tracking of patients medical payments.                                              |              
| Payer_name          | NVARCHAR(50)      | The name of the Payer.                                                                                                                       |
| Address             | NVARCHAR(50)      | Payer's street address.                                                                                                                      |
| City                | NVARCHAR(50)      | Payer's address city.                                                                                                                        |    
| State_hq_abbr       | NVARCHAR(50)      | Payer's state abbreviation.                                                                                                                  |
| Zip_code            | INT               | Payer's zip code.                                                                                                                            |
| Phone_number        | NVARCHAR(50)      | Payer's phone number.                                                                                                                        |


---

### 3. **gold.dim_organizations**
- **Purpose:** Stores the organization/hospital's details
- **Columns:** 

| Column Name              | Data Type         | Description                                                                                                                             |
|--------------------------|-------------------|-----------------------------------------------------------------------------------------------------------------------------------------|
| Organization_key         | INT               | Surrogate key uniquely identifying the organization in the dimension table.                                                             |
| Organization_id          | UNIQUEIDENTIFIER  | A unique identifier assigned to the organization where the patient receives treatment.                                                  |                                 
| Name                     | NVARCHAR(50)      | The name of the organization/hospital.                                                                                                  |                       
| Address                  | NVARCHAR(50)      | Hospital address.                                                                                                                       |
| City                     | NVARCHAR(50)      | City in which the hospital is located.                                                                                                  |                                                    
| State                    | NVARCHAR(50)      | The state in which the hospital is located.                                                                                             |                                                  
| Zip_code                 | INT               | Hospital's zip code.                                                                                                                    |                                                      
| Latitude                 | FLOAT             | Latitude of the hospital's address.                                                                                                     |
| Longitude                | FLOAT             | Longitude of the hospital's address.                                                                                                    |                                                                       


---

### 4. **gold.fact_encounters**
- **Purpose:** Stores details about a patient's hospital encounters, including diagnosis information and the costs of the medical services provided.
- **Columns:**

| Column Name                | Data Type         | Description                                                                                                                           |
|----------------------------|-------------------|---------------------------------------------------------------------------------------------------------------------------------------|
| Encounter_id               | UNIQUEIDENTIFIER  | A unique alphanumeric identifier for each encounter (e.g., '32c84703-2481-49cd-d571-3899d5820253').                                   |
| Patient_key                | INT               | Surrogate key linking the encounters to the patient dimension table.                                                                  |
| Organization_key           | INT               | Surrogate key linking the encounters to the organization dimension table.                                                             |
| Payer_key                  | INT               | Surrogate key linking the encounters to the Payer dimension table.                                                                    |
| Start_time                 | DATETIME          | The date and time  when the patient-hospital encounter started.                                                                       |
| End_time                   | DATETIME          | The date and time  when the patient-hospital encounter ended.                                                                         |
| Encounter_class            | NVARCHAR(50)      | The class of the encounter, (e.g. 'ambulatory', 'emergency','wellness',etc)                                                           |
| Encounter_code             | NVARCHAR(50)      | Encounter code from SNOMED-CT describing the kind of encounter,(e.g. '185345009', '50849002').                                        |
| Encounter_code_description | NVARCHAR(50)      | Description/meaning of the encounter-code. (e.g.'Prenatal visit', 'Follow-up encounter').                                             |
| Encounter_reason_code      | NVARCHAR(50)      | Diagnosis code from SNOMED-CT, only if the encounter targeted a specific condition, (e.g. '10509002').                                |
| Reason_code_description    | NVARCHAR(500)     | Description/meaning of the enconter reason code, (e.g. 'Acute bronchitis (disorder)').                                                |
| Base_encounter_cost        | DECIMAL(10,2)     | The base cost of the encounter, not including any line item costs related to medications, immunizations, procedures, or other services|
| Total_claim_cost           | DECIMAL(10,2)     | The total monetary cost of the encounter, including all line items.                                                                   |
| Payer_coverage             | DECIMAL(10,2)     | The amount of cost covered by the Payer.    

                                                                                          

---

### 5. **gold.fact_procedures**
- **Purpose:** Stores information about patients’ medical diagnoses and procedures performed, including the base cost of any procedure carried out.
- **Columns:**

| Column Name                | Data Type         | Description                                                                                                                           |
|----------------------------|-------------------|---------------------------------------------------------------------------------------------------------------------------------------|
| Encounter_id               | UNIQUEIDENTIFIER  | A unique alphanumeric identifier for each encounter (e.g., '32c84703-2481-49cd-d571-3899d5820253').                                   |
| Patient_key                | INT               | Surrogate key linking the procedures to the patient dimension table.                                                                  |
| Start_time                 | DATETIME          | The date and time  when the procedure started.                                                                                        |
| End_time                   | DATETIME          | The date and time  when the procedure ended.                                                                                          |
| Procedure_code             | NVARCHAR(50)      | Procedure code from SNOMED-CT describing the medical action performed.(e.g. '90226004').                                              |
| Procedure_code_description | NVARCHAR(50)      | Description/meaning of the procedure-code. (e.g.'Renal dialysis (procedure)', 'Electrical cardioversion').                            |
| Procedure_reason_code      | NVARCHAR(50)      | Diagnosis code from SNOMED-CT, Explains why the patient needed the procedure, (e.g. '53827007').                                      |
| Reason_code_description    | NVARCHAR(500)     | Description/meaning of the procedure reason code, (e.g. 'Excessive salivation (disorder)').                                           |
| Base_cost                  | DECIMAL(10,2)     | The line item cost of the procedure.                                                                                                  |

