# **Naming Conventions**
This document defines the naming standards applied to schemas, tables, views, columns, and other objects within the data warehouse.

## **Table of Contents**

1. [General Principles](#general-principles)
2. [Table Naming Conventions](#table-naming-conventions)
   - [Bronze Rules](#bronze-rules)
   - [Silver Rules](#silver-rules)
   - [Gold Rules](#gold-rules)
3. [Column Naming Conventions](#column-naming-conventions)
   - [Surrogate Keys](#surrogate-keys)
   - [Technical Columns](#technical-columns)
4. [Stored Procedure](#stored-procedure-naming-conventions)
---

## **General Principles**

- **Naming Conventions**: Apply a mixed style that combines Pascal Case and snake case, starting each name with an uppercase letter followed by lowercase letters, and using underscores (_) to separate words.
- **Language**: Use English for all names.
- **Avoid Reserved Words**: Avoid using SQL reserved keywords as names for database objects.
## **Table Naming Conventions**

### **Bronze Rules**
-All object names should begin with the source system name, and table names must retain their original names without any modifications.
- **`<sourcesystem>_<entity>`**  
  - `<sourcesystem>`: Name of the source system (e.g., `encounters`, `payers`).  
  - `<entity>`: The table name must exactly match the name used in the source system.  
  - Example: `patients` → Patient data sourced from the CVS system.

### **Silver Rules**
-All object names should begin with the source system name, and table names must retain their original names without any modifications.
- **`<sourcesystem>_<entity>`**  
  - `<sourcesystem>`: Name of the source system (e.g., `encounters`, `payers`).  
  - `<entity>`: The table name must exactly match the name used in the source system.  
  - Example: `patients` → Patient data sourced from the CVS system.

### **Gold Rules**
- All object names should be clear and descriptive, with table names beginning with the appropriate category prefix.
- **`<category>_<entity>`**  
  - `<category>`: Describes the role of the table, such as `dim` (dimension) or `fact` (fact table).  
  - `<entity>`: A clear and descriptive name of the table, that reflects the organization domain (e.g., `patients`, `payers`, `encounters`).  
  - Examples:
    - `dim_patient` → Dimension table for patient data.  
    - `fact_procedures` → Fact table containing procedures done and the base cost of each.  

#### **Glossary of Category Patterns**

| Pattern     | Meaning                           | Example(s)                              |
|-------------|-----------------------------------|-----------------------------------------|
| `dim_`      | Dimension table                  | `dim_patients`, `dim_patients`           |
| `fact_`     | Fact table                       | `fact_encounters`                            |
| `report_`   | Report table                     | `report_patients`, `report_encounters_monthly`   |

## **Column Naming Conventions**

### **Surrogate Keys**  
- All primary keys in dimension tables must use the suffix `_key`.
- **`<table_name>_key`**  
  - `<table_name>`: Refers to the name of the table or entity the key belongs to.  
  - `_key`: A suffix indicating that this column is a surrogate key.  
  - Example: `patient_key` → Surrogate key in the `dim_patients` table.
  
### **Technical Columns**
- All technical columns should begin with the prefix dwh_, followed by a clear and descriptive name that reflects the column’s purpose.
- **`hdb_<column_name>`**  
  - `hdb`: A prefix used solely for system-generated metadata.  
  - `<column_name>`: A descriptive name indicating the column's purpose.  
  - Example: `hdb_create_date` → System-generated column used to store the date when the record was loaded.
 
## **Stored Procedure**

- All stored procedures used for loading data must follow the naming pattern:
- **`load_<layer>`**.
  
  - `<layer>`: Represents the layer being loaded, such as `bronze`, `silver`, or `gold`.
  - Example: 
    - `load_bronze` → Stored procedure for loading data into the Bronze layer.
    - `load_silver` → Stored procedure for loading data into the Silver layer.
