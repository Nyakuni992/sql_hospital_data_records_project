# Hospital Data Warehouse & Analytics Project

## ☄️ Welcome to the Hospital Data Warehouse & Analytics Project repository.
This project presents a comprehensive end-to-end data warehousing and analytics solution — from designing and developing the data warehouse to delivering meaningful, actionable insights. Developed as a portfolio project, it demonstrates industry best practices in data engineering, data modeling, and analytics.

---
## 🏙️Data Architecture

The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:
![Data Architecture](https://github.com/Nyakuni992/sql_hospital_data_records_project/blob/main/doc/Data%20Architecture.png)

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.

---
## 📖 Project Overview

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Developing SQL-driven reports and dashboards that transform data into clear, actionable insights.
---

## 🛠️ Important Links & Tools:

Everything is for Free!
- **[Datasets](datasets/):** Access to the project dataset (csv files).
- **[SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads):** Lightweight server for hosting your SQL database.
- **[SQL Server Management Studio (SSMS)](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16):** GUI for managing and interacting with databases.
- **[Git Repository](https://github.com/):** Set up a GitHub account and repository to manage, version, and collaborate on your code efficiently.
- **[DrawIO](https://www.drawio.com/):** Design data architecture, models, flows, and diagrams.
- **[Notion](https://www.notion.com/):** All-in-one tool for project management and organization.
- **[Notion Project Steps](https://www.notion.so/Hospital-Records-Project-2cb3700e152f806d9b0ad71b35d548ac):** Access to All Project Phases and Tasks.

---

## 🚀 Project Requirements
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


## 📊BI: Analytics & Reporting (Data Analysis)

### Objective:
Design and implement SQL-driven analytical reporting to measure and monitor key healthcare performance indicators (KPIs), supporting operational efficiency, financial performance, and patient care insights.
- **Encounters Overview**: Volume trends, readmissions, and utilization metrics.
- **Cost & Coverage Insights**: Treatment costs, payer coverage distribution, and financial responsibility analysis.
- **Patient Behavioral Analysis**: Visit patterns, Demographic distribution (age, gender, location), and service utilization behavior.
- **Financial Performance**: Revenue performance, contribution analysis, and key financial indicators.

These KPIs provide stakeholders with measurable performance indicators that support strategic planning, operational improvements, and financial decision-making.
For more details, refer to [docs/requirements.md](https://github.com/Nyakuni992/sql_hospital_data_records_project/tree/main/doc).

## 📂 Repository Structure
```
data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (CSV)
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

This project is licensed under the [MIT License](LICENSE). allowing you to freely use, modify, and share it, provided proper attribution is given.
## 🌟 About Me

**Hello!** I’m **Aramiru Nyakuni Rebecca**, a professional accountant transitioning into the field of data analysis. I am dedicated to honing my skills and expertise in data analytics while leveraging data-driven insights and predictive analysis to help organizations achieve their long-term objectives.

## 🤝 Connect With Me

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-blue?logo=linkedin)](https://www.linkedin.com/in/rebecca-aramiru-3a699a12b/)
[![Gmail](https://img.shields.io/badge/Email-Contact-red?logo=gmail&logoColor=white)](mailto:nyanetah@gmail.com)
[![Website](https://rebekaharamiru.my.canva.site/)
