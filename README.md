Welcome to the **hospital_data_records_project** repository⚕️

This project illustrates an in-depth data warehousing and analytics solution, from building a data warehouse to generating operational insights. This project is designed as a portfolio project and It showcases industry best practices in data engineering and analytics.

## 🔷 Data Architecture

This project adopts the Medallion Architecture **Bronze**, **Silver**, and **Gold** layers for it's data design :
![Data Architecture](doc/Data%20Architecture.png)
/Data Architecture.png)

1. **Bronze Layer**: This layer stores raw data exactly as received from source systems, ingested from CSV files into the SQL Server Database.
2. **Silver Layer**: “In this layer data is cleansed, standardized, and normalized to ensure analytical readiness.”
3. **Gold Layer**: This layer contains Business-ready datasets that are structured using the star schema to enable efficient reporting and analytics.

---
## 📖 Project Overview

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Involves Extracting, transforming, and loading data from source systems into the sql database.
3. **Data Modeling**: Formulating fact and dimension tables that are efficient for analytical queries
4. **Analytics & Reporting**: Developing SQL-based reports and dashboards for actionable insights.

---

## 🛠️ Important Links & Tools:

- **[Datasets](https://mavenanalytics.io/data-playground/hospital-patient-records):** Sample dataset freely downloaded from maven analytics (csv files).
- **[SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads):** Lightweight server for hosting the SQL database.
- **[SQL Server Management Studio (SSMS)](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16):** GUI for managing and interacting with databases.
- **[Git Repository](https://github.com/):**  GitHub account and repository for managing and collaborating  the code efficiently.
- **[DrawIO](https://www.drawio.com/):** For designing the data architecture, models, flows, and diagrams.
- **[Notion Project Steps](https://www.notion.so/Hospital-Records-Project-2cb3700e152f806d9b0ad71b35d548ac):** Shows the complete steps and Tasks taken to manage and organize the project.

---

## 🪢 Project Requirements

### Building the Hospital Data Warehouse (Data Engineering)

#### Objective
Build a contemporary hospital data warehouse with SQL Server to consolidate patient records and supporting the analysis of patient behavior.

#### Specifications
- **Data Sources**: Import data from the hospital-patient records provided as CSV files.
- **Data Quality**: Cleanse and resolve any data quality issues before analysis.
- **Integration**: Combine related data sources into a single, user-friendly data model designed for analytical queries.
-  **Scope**: Excludes encounters occurring after a recorded patient death date for all analytical KPIs to maintain logical and clinical consistency.
- **Documentation**: "Provide thorough documentation of the data model to assist stakeholders,hospital administrators and analytics teams.
---

### BI: Analytics & Reporting (Data Analysis)

#### Objective
Develop SQL-based analytics to deliver detailed insights into:
- **Patient-encounter Overview**
- **Cost and Coverage Insights**
- **Patient Behavioural Analysis**

These clinical insights provide stakeholders, hospital administrators, and multidisciplinary care teams with critical healthcare performance indicators, facilitating evidence-based, strategic decision-making

For more details, refer to [docs/requirements.md](docs/requirements.md).

## 📂 Repository Structure
```
hospital_data_records-project/
│
├── datasets/                           # Raw datasets used for the project ( all patient records and cost data)
│
├── docs/                               # Project documentation and architecture details
│   ├── etl.drawio                      # Draw.io file shows all different techniquies and methods of ETL
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
├── tests/                              # Test scripts and quality files
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
├── .gitignore                          # Files and directories to be ignored by Git
└── requirements.txt                    # Dependencies and requirements for the project
```
---


## 🛡️ License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and share this project with proper attribution.

## 🌟 About Me

Hello! My name is **Aramiru Nyakuni Rebecca**. I am a professional accountant transitioning into data analytics with a mission to broaden and deepen my expertise in this evolving discipline.


I'd love to keep in touch! Connect with me on these platforms:

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/rebecca-aramiru-3a699a12b/)
[![Website](https://img.shields.io/badge/Website-000000?style=for-the-badge&logo=google-chrome&logoColor=white)]

