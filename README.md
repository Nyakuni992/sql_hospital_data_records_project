# 🏥 Hospital Data Warehouse & Analytics Project

## ☄️Welcome to the Hospital Data Warehouse & Analytics Project repository.
This project presents a comprehensive end-to-end data warehousing and analytics solution built using SQL Server, ETL pipelines, dimensional modeling, and BI reporting.

---
## 🎯Business Problem
Hospitals generate large volumes of operational and clinical data, but raw datasets alone do not support strategic decision-making.

This project centralizes hospital encounter data into a modern analytical warehouse to enable:
- Monitoring patient readmissions
- Tracking financial performance
- Evaluating payer coverage
- Understanding patient utilization behavior
- Supporting KPI-driven healthcare analytics

---
## 📖Project Overview

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Developing SQL-driven reports and dashboards that transform data into clear, actionable insights.

---
## 🛠 Skills Demonstrated

### 🏗Data Architecture & Engineering
- Medallion Architecture Design: Implemented a multi-layered data lakehouse approach (Bronze, Silver, Gold) to ensure a clean separation between raw ingestion, cleaned data, and business-ready analytical entities.

- Galaxy (Fact Constellation) Schema Modeling: Architected a multi-fact dimensional model to handle differing granularities (Encounters vs. Procedures), preventing data fan-out and ensuring 100% aggregation accuracy.

- ETL/ELT Pipeline Development: Engineered robust SQL-based transformation scripts to handle data cleansing, standardization, and complex business logic (e.g., excluding post-death encounters).

### 🔍Healthcare Data Analytics
- Clinical Logic Implementation: Applied healthcare-specific constraints, such as identifying and monitoring Patient Readmission rates and Length of Stay (LOS) metrics.

- Financial Performance Analysis: Built logic to calculate payer coverage gaps and total claim costs, providing insights into revenue leakage and payer efficiency.


### 📊BI & Data Storytelling
- Interactive Dashboard Design: Developed three distinct Tableau dashboards (Operational, Patient, and Payer) tailored to different stakeholder personas (Operations, Clinical, and Finance).

- Actionable KPI Development: Translated raw transactional data into high-level business metrics like Encounter Volume Growth, Readmission Probability, and Cost Distribution.

### 🖥Technical Proficiency
- Advanced SQL: Expert use of Common Table Expressions (CTEs), window functions for trend analysis, and complex joins across normalized schemas.

- Documentation & Governance: Maintained a strict Data Catalog and naming conventions to ensure the warehouse is scalable and easy for other analysts to navigate.

---
## 🚀Scope & Technical Specifications
### Building the Data Warehouse (Data Engineering)
#### Objective:
Design and implement a modern data warehouse using SQL Server to consolidate hospital encounter data, enabling analytical reporting and data-driven decision-making.

#### Specifications:
- **Data Sources**: Ingest structured data provided as CSV files into a staging layer.                  
- **Data Quality**: Perform data cleansing, validation, and transformation to resolve inconsistencies and ensure integrity.
- **Data Integration**: Integrate source data into a unified dimensional data model (fact and dimension tables) optimized for analytical queries.
-  **Scope**: Exclude encounters occurring after a recorded patient death date to maintain logical and clinical consistency across KPIs.
- **Documentation**: Provide comprehensive data model documentation to support business stakeholders and analytics teams.

---
## 🏙️Data Architecture

The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:
![Data Architecture](https://github.com/Nyakuni992/sql_hospital_data_records_project/blob/main/doc/Data%20Architecture.png)

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Contains business-ready, curated data structured into a galaxy schema to support reporting, analytics, and KPI-driven insights.

---
## ⭐Data Model (Galaxy Schema)

![Galaxy Schema](https://github.com/Nyakuni992/sql_hospital_data_records_project/blob/main/doc/Data%20Model(Galaxy%20Schema)%20png.png)

A galaxy schema was implemented to support scalable healthcare analytics across encounters, procedures, patients, organizations and payers. The model improves query efficiency, reduces redundancy, and enables cross-functional reporting in Tableau.
[View Full Data Model Documentation →](https://github.com/Nyakuni992/sql_hospital_data_records_project/blob/main/doc/Data%20Catalog.sql)

#### Design Choice: Fact Constellation Schema (Galaxy Schema)
I opted for a Galaxy Schema over a single Fact table because fact_procedures and fact_encounters exist at different levels of granularity.
- Encounters: Track the overarching visit and billing timeline.
- Procedures: Track specific medical actions within those visits.
Keeping them separate prevents data inflation and ensures accurate aggregation of base_cost, procedure cost, payer coverage and total_claim_cost.

---
## ⚙️ Tech Stack

| Category | Tools |
|---|---|
| Database | SQL Server Express |
| Query Tool | SSMS |
| Data Modeling | Draw.io |
| Version Control | Git & GitHub |
| Documentation | Notion |
| Visualization | Tableau Public |
| Data Format | CSV |

---
## 📊BI: Analytics & Reporting (Data Analysis)

### Objective:
Design and implement SQL-driven analytical reporting to measure and monitor key healthcare performance indicators (KPIs), supporting operational efficiency, financial performance, and patient care insights.
The reporting layer transforms curated warehouse data into actionable insights through interactive dashboards and KPI-focused analytics.

### 🏥 Encounters Operational Dashboard

#### Focus Areas
- Encounter volume trends
- Readmission analysis
- Operational utilization metrics
- Encounter distribution analysis

#### Dashboard Preview

![Encounters Operational Dashboard](https://github.com/Nyakuni992/sql_hospital_data_records_project/blob/main/doc/Encounters%20Operational%20Dashboard.png)

#### Key Business Value
Provides operational visibility into hospital encounter activity, helping stakeholders identify utilization patterns, monitor readmission trends, and improve resource planning.

#### 🔗 Tableau Public Dashboard
[Tableau Public Link for Encounters Operational Dashboard](https://public.tableau.com/views/Hospitalkpi/EncountersOperationalDashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

### 👤 Patient Monitoring Dashboard

#### Focus Areas
- Patient visit behavior
- Readmission monitoring
- Service utilization patterns

#### Dashboard Preview

![Patient Monitoring Dashboard](https://github.com/Nyakuni992/sql_hospital_data_records_project/blob/main/doc/Patient%20Monitoring%20Dashboard.png)

#### Key Business Value
Supports patient-centered analytics by identifying behavioral trends, demographic patterns, and healthcare utilization characteristics that can improve care planning and engagement strategies.

#### 🔗 Tableau Public Dashboard
[Tableau Public Link for Patient Monitoring Dashboard](https://public.tableau.com/views/Hospitalkpi/PatientMonitoringDashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

### 📈 Payer Performance Dashboard

#### Focus Areas
- Payer coverage analysis
- Treatment cost distribution
- Financial responsibility tracking
- Revenue contribution analysis
- Cost and reimbursement monitoring

#### Dashboard Preview

![Payer Performance Dashboard](https://github.com/Nyakuni992/sql_hospital_data_records_project/blob/main/doc/Payer%20Performance%20Dashboard.png)

#### Key Business Value
Provides financial visibility into payer performance, reimbursement trends, and healthcare cost distribution to support strategic financial planning.

#### 🔗 Tableau Public Dashboard
[Tableau Public Link for Payer Performance Dashboard](https://public.tableau.com/views/Hospitalkpi/PayerPerformanceDashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

---

## 📈 Overall Analytical Impact

The dashboards provide stakeholders with measurable KPIs that support:

- Strategic healthcare planning
- Operational performance monitoring
- Financial performance analysis
- Patient utilization insights
- Data-driven decision-making

For additional project documentation, refer to the [docs](https://github.com/Nyakuni992/sql_hospital_data_records_project/tree/main/doc) folder.

## 🔍 Key Insights

- High-risk patients contributed to the highest number of readmissions
- Q1 and Q4 recorded the highest total treatment costs.
- Encounter volume growth was primarily driven by repeat patient visits.
- Certain payer categories showed significantly higher uncovered costs.
- Longer Length of Stay (LOS) was associated with increased readmission probability.

---

## 🚀Getting Started
### Prerequisites
[Database Engine: SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)
[SQL Server Management Studio (SSMS)](https://learn.microsoft.com/en-us/ssms/install/install)
[Tableau Desktop/Public](https://www.tableau.com/products/public?utm_source=chatgpt.com) 

### Installation & Setup
#### 1. Clone the Repository
Bash
[git clone](https://github.com/Nyakuni992/sql_hospital_data_records_project.git)
#### 2. Initialize the Database:
Open SSMS and connect to your local instance.
Run the script scripts/bronze[/init_database.sql ](https://github.com/Nyakuni992/sql_hospital_data_records_project/blob/main/Scripts/bronze/ddl_bronze.sql)to create the database structure.
### 3. Ingest Raw Data:
Place the CSV files from the [datasets/ folder](https://github.com/Nyakuni992/sql_hospital_data_records_project/tree/main/datasets) into your SQL Server's authorized import directory.
### 4.Execute the [scripts/bronze/load_bronze.sql](https://github.com/Nyakuni992/sql_hospital_data_records_project/blob/main/Scripts/bronze/proc_load_bronze.sql) scripts.
### 5.Run Transformations:
Execute scripts in the [silver/ folder](https://github.com/Nyakuni992/sql_hospital_data_records_project/tree/main/Scripts/silver), followed by the [gold/ folder](https://github.com/Nyakuni992/sql_hospital_data_records_project/tree/main/Scripts/gold) to build the Galaxy Schema.

### 5.View Analytics:
Tableau Access: Open the .twbx (Packaged Workbook) located in the [reports/ folder](https://github.com/Nyakuni992/sql_hospital_data_records_project/tree/main/Reports/Tableau_dashboards).

#### 📝Technical Notes
- Tableau Connection: Data was transformed and curated in SQL Server; Gold-layer tables were exported to CSV for visualization in Tableau Public due to the software's connection limitations for local SQL instances.
- Data Integrity: The exported CSVs represent the final, cleaned "Gold" layer, ensuring the dashboards reflect the logic applied within the SQL Server environment. Refer to the SQL scripts in [reports/export data](https://github.com/Nyakuni992/sql_hospital_data_records_project/tree/main/Reports/Export_data_tableau_csv) which correspond exactly to the data structures seen in the Tableau "Data Source" tab.

## 📂 Repository Structure
```
Hopital-data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (CSV)
│
├── docs/                               # Project documentation and architecture details
│   ├── etl.drawio                      # Illustrates the various ETL techniques & processes used
│   ├── data_architecture.drawio        # Draw.io file shows the project's architecture
│   ├── data_catalog.md                 # Catalog of datasets, including field descriptions and metadata
│   ├── data_flow.drawio                # Draw.io file for the data flow diagram
│   ├── data_models.drawio              # Draw.io file for data models (star schema)
│   ├── naming-conventions.md           # Consistent naming guidelines for tables, columns, and files
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models
│
├── reports/                            # THE ANALYTICAL OUTPUT               
│   ├── exported_gold_data              # The CSVs used for Tableau (since SQL connection is limited)
│   ├── kpi_queries.sql                 # Final analytical reports & KPI queries
│   └── tableau dashboards.twbx         # The Packaged Tableau Workbook
│  
│  
├── tests/                              # Data validation & integrity checks
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
└── gitignore                          # Files and directories to be ignored by Git

```
---


## 🛡️ License

This project is licensed under the [MIT License](LICENSE). allowing you to freely use, modify, and share it, provided proper attribution is given.

## 🌟 About Me

**Hello!** I’m **Aramiru Nyakuni Rebecca**, a professional accountant transitioning into the field of data analysis. I am dedicated to honing my skills and expertise in data analytics while leveraging data-driven insights and predictive analysis to help organizations achieve their long-term objectives.

## 🤝 Connect With Me

[![Portfolio](https://img.shields.io/badge/Portfolio-Canva-00C4CC?logo=canva&logoColor=white)](https://rebekaharamiru.my.canva.site/)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/rebecca-aramiru-3a699a12b/)
[![Gmail](https://img.shields.io/badge/Email-Gmail-red?logo=gmail&logoColor=white)](mailto:nyanetah@gmail.com)

