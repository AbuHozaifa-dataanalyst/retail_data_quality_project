# Retail Data Quality & Business Analytics

A portfolio project demonstrating an end-to-end **Retail Data Quality, Data Validation, SQL Analytics, and Power BI Business Intelligence workflow** using realistic retail sales data.

The project focuses on transforming imperfect retail data into a trusted, business-ready dataset and then using that data to analyze **sales, profitability, stores, and product categories**.

---

## 📌 Project Overview

Retail organizations depend on accurate and consistent data for reporting, decision-making, inventory planning, pricing, promotions, and profitability analysis.

However, raw retail transaction data can contain problems such as:

- Missing values
- Duplicate records
- Invalid quantities
- Invalid prices
- Invalid discounts
- Invalid costs
- Inconsistent categories
- Inconsistent cities and regions
- Invalid dates
- Referential integrity issues
- Missing or unknown customer references
- Missing or unknown product references
- Business-rule violations

This project demonstrates how a Retail/Data Analyst can identify, clean, validate, transform, and analyze such data before using it for business reporting.

### Project Workflow

```text
Raw Retail Data
      ↓
Data Profiling
      ↓
Data Cleaning
      ↓
Data Validation
      ↓
SQL Server Transformation
      ↓
Business-Ready Data
      ↓
Power BI Data Model
      ↓
Retail Business Analysis
      ↓
Business Insights & Recommendations
```




🎯 Business Objectives

The project aims to answer four major questions:

1. Is the retail data trustworthy?

Identify and validate data-quality problems before reporting.

2. Can the cleaned data be loaded reliably into SQL Server?

Build a structured relational model with appropriate keys and relationships.

3. Can the validated data support reliable retail KPIs?

Reconcile important KPIs between Python and SQL Server.

4. What business insights can management obtain from the trusted data?

Analyze:

Sales performance
Profitability
Gross margin
Store performance
Product category performance
Customer performance
Business opportunities
🗂️ Project Structure
retail-data-quality-project/
│
├── data/
│   ├── raw/
│   ├── cleaned/
│   └── processed/
│
├── python/
│   ├── 01_data_profiling.ipynb
│   ├── 02_data_cleaning.ipynb
│   ├── 03_data_validation.ipynb
│   └── 04_kpi_reconciliation.ipynb
│
├── sql/
│   ├── 01_create_database.sql
│   ├── 02_create_tables.sql
│   ├── 03_load_data.sql
│   ├── 04_data_quality_checks.sql
│   ├── 05_transformations.sql
│   └── 06_create_views.sql
│
├── powerbi/
│   └── retail_data_quality_analytics.pbix
│
├── docs/
│   ├── data_dictionary.md
│   ├── data_quality_report.md
│   ├── business_rules.md
│   ├── methodology.md
│   └── business_insights.md
│
├── README.md
└── requirements.txt
🛠️ Tools & Technologies
Tool	Purpose
Python	Data profiling, cleaning, validation, KPI reconciliation
Pandas	Data manipulation and quality analysis
NumPy	Numerical operations
Matplotlib	Data visualization
SQL Server	Data storage, validation, transformation, analytics
SSMS	SQL development and database management
Power BI	Interactive dashboards and business analysis
DAX	Retail KPI calculations
Power Query	Data preparation/model loading
Git	Version control
GitHub	Portfolio and project documentation
VS Code	Development environment
📊 Dataset

The project uses a realistic retail sales dataset designed to simulate a multi-store retail environment.

The data contains sales transactions along with supporting dimension tables.

Main Tables
fact_sales
dim_product
dim_customer
dim_store
dim_date
Fact Table

fact_sales contains transaction-level sales information.

Important fields include:

Transaction ID
Date
Product ID
Customer ID
Store ID
Quantity
Unit Price
Discount
Cost
Gross Sales
Net Sales
Gross Profit
Payment Method
Channel
Region / City
Dimension Tables
dim_product

Contains product information such as:

Product ID
Product Name
Category
Product attributes
dim_customer

Contains customer-level information.

dim_store

Contains store-level information such as:

Store ID
Store Name
Store Type
City
Region
dim_date

Provides the date dimension used for time-based analysis.

🧹 Data Quality Analysis

The project intentionally includes realistic data-quality issues to simulate the type of problems analysts encounter in real retail environments.

Data Quality Problems Identified

Examples include:

Missing values
Duplicate transactions
Conflicting duplicate transaction IDs
Negative quantities
Invalid prices
Invalid discounts
Invalid costs
Inconsistent categorical values
Invalid dates
Referential integrity issues
Unknown customer references
Unknown product references
🔍 Data Profiling with Python

Python/Pandas was used to profile the raw data before performing transformations.

The profiling process examined:

Dataset shape
Data types
Missing values
Duplicate records
Unique values
Descriptive statistics
Invalid values
Category consistency
Referential integrity
Business-rule violations

The purpose was to understand the condition of the data before modifying it.

🧼 Data Cleaning

The cleaning process followed a controlled approach rather than modifying the raw data directly.

Principle
Raw Data
   ↓
Profile
   ↓
Clean
   ↓
Validate
   ↓
Business-Ready Data

The original raw dataset was preserved.

Cleaning Actions

Depending on the issue, records were:

Corrected where the transformation was deterministic
Standardized where categorical variations represented the same business value
Recalculated where financial values could be derived reliably
Quarantined for review when the correct value could not be safely determined
Assigned to an UNKNOWN dimension member where appropriate to preserve referential integrity
📝 Data Cleaning Audit

A cleaning audit was created to document the cleaning process.

Output:

data/cleaned/cleaning_audit.csv

This provides traceability between identified problems and the actions taken.

✅ Data Validation

After cleaning, automated validation tests were performed.

The current validation framework contains:

Total Tests: 15
PASS:        13
FAIL:         1
REVIEW:       1
Validation Result
Status	Tests
PASS	13
FAIL	1
REVIEW	1
Total	15

The remaining FAIL and REVIEW results were intentionally retained for transparency rather than being hidden.

🔗 Referential Integrity Validation

One important issue identified during the process involved product references.

The validation identified:

Orphan Product Records = 147

These records could not be directly linked to the existing product dimension.

Instead of arbitrarily deleting valid sales records, the project uses an explicit data-quality approach involving an UNKNOWN dimension member where appropriate.

This preserves the fact data while making the data-quality issue visible.

🏗️ SQL Server Data Model

The cleaned data was loaded into SQL Server using a staging and production approach.

Loading Architecture
CSV Files
   ↓
Staging Tables
   ↓
Validation
   ↓
Production Tables
   ↓
Views
   ↓
Power BI
Example Staging Tables
stg_dim_product
stg_fact_sales
stg_data_validation_results

The production layer contains the main analytical tables.

⭐ Star Schema

The Power BI / SQL analytical model follows a star-schema design.

                 dim_date
                    |
                    |
dim_product ---- fact_sales ---- dim_customer
                    |
                    |
                 dim_store
Fact

fact_sales

Dimensions
dim_date
dim_product
dim_customer
dim_store

This structure allows business users to analyze transactions from different perspectives.

📐 Key Retail KPIs

The project calculates and validates important retail KPIs.

Net Sales
Net Sales = Gross Sales - Discounts
Gross Profit
Gross Profit = Net Sales - Cost
Gross Margin %
Gross Margin % = Gross Profit / Net Sales
Average Transaction Value
ATV = Net Sales / Transactions
Units Per Transaction
UPT = Units Sold / Transactions
Active Customers

Number of customers with sales activity, excluding the UNKNOWN dimension member.

Active Products

Number of products with sales activity, excluding the UNKNOWN dimension member.

Active Stores

Number of stores with sales activity, excluding the UNKNOWN dimension member.

🔄 Python ↔ SQL KPI Reconciliation

Important business KPIs were reconciled between Python and SQL Server to ensure that the cleaned data produced consistent results across analytical tools.

Current Reconciliation Results
KPI	Result
Fact Sales Rows	~118K
Gross Sales	745.28M
Discounts	37.22M
Net Sales	708.06M
Gross Profit	166.75M
Transactions	~118K
Units Sold	~355K
Average Transaction Value	~5.99K
Units Per Transaction	~3.01
Active Customers	~5K
Active Products	500
Active Stores	20

The SQL financial reconciliation confirmed:

Gross Sales = 745,278,899.94
Discounts   = 37,220,956.78
Net Sales   = 708,057,943.16

Calculated Net Sales matched recorded Net Sales with:

Difference = 0.00

Transaction-level financial reconciliation also produced:

Mismatched Transactions = 0

This provides confidence that the core financial calculations are consistent.

📊 Power BI Dashboard

The Power BI report currently contains two completed analytical pages.

File:

powerbi/retail_data_quality_analytics.pbix
Page 1 — Data Quality

The first page focuses on data-quality monitoring.

Main Components
Data Quality KPI cards
Overall Data Quality %
Validation status breakdown
PASS / FAIL / REVIEW analysis
Data-quality issue details
Current Validation Status
13 PASS
1 FAIL
1 REVIEW

The page is designed to show stakeholders whether the dataset is sufficiently trustworthy for downstream reporting.

📈 Page 2 — Retail Business Performance

The second page demonstrates how validated data can be used for actual retail business analysis.

Main Analysis Areas
Overall Retail KPIs
Net Sales
Gross Profit
Gross Margin %
Transactions
Units Sold
ATV
UPT
Active Customers
Active Products
Active Stores
Sales Trend

Monthly Net Sales trend was analyzed to understand changes in business performance over time.

Store Performance

Stores were analyzed using:

Net Sales
Gross Profit
Gross Margin %

A store performance quadrant was also created.

Store Performance Quadrants
High Sales + High Margin
        ↓
Strong Performer

High Sales + Low Margin
        ↓
High Sales / Margin Opportunity

Low Sales + High Margin
        ↓
Growth Opportunity

Low Sales + Low Margin
        ↓
Underperformer

The average store benchmarks used in the analysis were:

Average Store Net Sales ≈ 33.72M
Average Store Gross Margin ≈ 23.54%

The analysis identified:

GulfMart Taif 04 as the #1 store by Net Sales and Gross Profit.

It ranked #6 by Gross Margin % and was classified as a Strong Performer based on the sales and margin benchmark framework.

🛍️ Category Performance

Product categories were analyzed using:

Net Sales
Gross Profit
Gross Margin %
Current Findings

#1 Category by Net Sales

Home Appliances

#1 Category by Gross Profit

Home Appliances

#1 Category by Gross Margin %

Beauty

#2 Category by Gross Margin %

Home Appliances

Business Interpretation

Home Appliances is the strongest category by absolute financial contribution, ranking first in both Net Sales and Gross Profit.

Beauty has the highest Gross Margin %, indicating stronger profit efficiency relative to sales.

This demonstrates an important retail analytics distinction:

The category generating the most profit does not necessarily have the highest margin percentage.

💡 Business Insights Framework

Business insights are documented using the following framework:

Observation
     ↓
Evidence
     ↓
Business Impact
     ↓
Recommendation

This ensures that the analysis moves beyond reporting numbers and connects the results to potential business actions.

💼 Example Business Insights
Home Appliances — Primary Profit Driver
Observation

Home Appliances ranks #1 in both Net Sales and Gross Profit.

Evidence
#1 Net Sales
#1 Gross Profit
#2 Gross Margin %
Business Impact

Home Appliances is a major contributor to overall sales and gross profit.

Recommendation

The retailer should protect availability of high-performing products while investigating opportunities to improve margins through:

Pricing
Discount management
Product mix
Supplier costs
SKU-level profitability
Beauty — Margin Efficiency Leader
Observation

Beauty ranks #1 in Gross Margin %.

Business Impact

Beauty demonstrates strong profit efficiency relative to sales.

Recommendation

The retailer should investigate opportunities to increase Beauty sales while maintaining its strong margin profile.

Potential actions include:

Expanding high-performing SKUs
Cross-selling
Bundling
Assortment optimization
Maintaining pricing discipline
📁 Documentation

Additional project documentation is maintained in the docs/ directory.

data_dictionary.md

Documents the meaning and purpose of important fields.

data_quality_report.md

Documents identified data-quality problems and validation outcomes.

business_rules.md

Documents the business rules used to determine whether records and calculations are valid.

methodology.md

Documents the overall analytical methodology and workflow.

business_insights.md

Contains detailed business observations, evidence, impacts, and recommendations.

🔄 Current Project Status
Component	Status
Raw Dataset Generation	✅ Complete
Data Profiling	✅ Complete
Data Cleaning	✅ Complete
Cleaning Audit	✅ Complete
Data Validation	✅ Complete
SQL Server Database	✅ Complete
SQL Data Quality Checks	✅ Complete
KPI Reconciliation	✅ Complete
Power BI Data Model	✅ Complete
Power BI Page 1 — Data Quality	✅ Complete
Power BI Page 2 — Retail Business Performance	✅ Complete
Store Performance Analysis	✅ Complete
Category Performance Analysis	✅ Complete
Customer Performance Analysis	🔄 In Progress
Customer Segmentation	🔄 Planned
Final Business Insights	🔄 In Progress
🚀 Planned Next Steps

The next stage of the project will focus on customer analytics.

Customer Performance

Planned analysis includes:

Customer Net Sales
Customer Gross Profit
Customer Gross Margin %
Top customers
Average customer value
Customer concentration
High-value customers
Customer Segmentation

The project will later explore customer segments based on customer value and purchasing behavior.

Potential segments include:

High-Value Customers
Margin Opportunity
Growth Opportunity
Low-Value Customers
🎓 Skills Demonstrated

This project demonstrates practical skills in:

Data Analytics
Data profiling
Data cleaning
Data validation
Exploratory analysis
KPI analysis
Business analysis
Python
Python
Pandas
NumPy
Data quality automation
Data transformation
KPI reconciliation
SQL Server
Database creation
Table design
Staging tables
Data loading
Constraints
Foreign keys
Data-quality checks
Transformations
Analytical views
KPI validation
Power BI
Data modeling
Star schema
Relationships
DAX measures
KPI cards
Tables
Bar charts
Trend analysis
Scatter plots
Conditional formatting
Performance quadrants
Git & GitHub
Version control
Repository organization
Commit management
.gitignore
GitHub portfolio management
🧠 Business Questions Addressed

The project is designed to answer questions such as:

Data Quality
Can management trust the sales data?
What data-quality problems exist?
Which validation tests passed or failed?
Are financial calculations internally consistent?
Sales
How much Net Sales did the retailer generate?
How are sales changing over time?
Which stores generate the most sales?
Profitability
Which stores generate the most Gross Profit?
Which stores have strong margins?
Which categories generate the most profit?
Which categories are most margin-efficient?
Store Performance
Which stores are strong performers?
Which stores have high sales but weak margins?
Which stores have growth potential?
Which stores may require management attention?
Category Performance
Which category generates the most sales?
Which category generates the most profit?
Which category has the highest margin?
Where might margin or growth opportunities exist?
Customer Analytics

Customer-level analysis is the next major stage of the project.

📌 Key Takeaway

This project demonstrates an important principle in retail analytics:

Good business decisions depend on trustworthy data.

The project therefore does not start with a dashboard.

It starts with:

Data Quality
      ↓
Data Validation
      ↓
Data Reliability
      ↓
Business KPIs
      ↓
Business Insights
      ↓
Business Decisions

The goal is to demonstrate not only technical analytics skills, but also the ability to connect data quality → retail KPIs → business performance → actionable recommendations.

👤 Portfolio Purpose

This project was developed as a portfolio project for roles such as:

Retail Analyst
Retail Data Analyst
Business Data Analyst
BI Analyst
Sales Analyst
Commercial Analyst
E-commerce Analyst

It demonstrates an end-to-end workflow using Python, SQL Server, Power BI, and Git/GitHub in a realistic retail analytics scenario.
