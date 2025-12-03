# Arkhe_Pacis_Store_sql

### Project Overview

This project analyzes Arkhe Pacis Store’s sales data using SQL Server. The objective was to clean, transform, and analyze multiple relational tables to uncover insights on customer behavior, product performance, supplier contribution, regional trends, and seasonal sales patterns.
All SQL logic used in this project including data cleaning, EDA, and business analysis queries is stored in a single script file for easy review and reproducibility.

![Capture](https://github.com/user-attachments/assets/6338e2e8-bee3-4014-8754-95009bc8b02e)


### Data source
The analysis uses four relational tables gotten from Kaggle site:

- Sales_sql – transactional sales data

- Customer – customer demographics

- Product_sql – product-level information

- Supplier_sql – supplier details

The datasets were provided as CSV files and imported into SQL Server.

### Tools Used

- SQL Server

- SQL Server Management Studio (SSMS)

- Excel (For Visualisation)


### Exploratory Data Analysis (EDA)

#### EDA covered:

- Customer purchasing behavior

- Revenue distribution across regions

- Product category performance

- Supplier-based profit analysis

- Monthly and seasonal trends
  
- Customer segmentation (age & gender)

- Order frequency patterns

- Identification of top customers
These exploratory insights shaped the structure of deeper business analysis queries.

### Data Analysis

The SQL script answers key business questions, including:

- Top customers by revenue

- Most profitable product categories

- Orders by day of the week

- Highest-performing regions

- Month-over-month revenue growth

- Most in-demand products

- Supplier performance and profitability

- Age and gender purchase trends

- Seasonal sales patterns
  

### SQL File Reference (IMPORTANT)

#### All SQL queries used in this project—data cleaning, EDA, and business analysis—are stored in:

 [`SQL_capston.sql`](SQL_capston.sql)


This file includes:

Data cleaning queries

Table modification statements

KPI calculations

Joins across all datasets

CTE-based analysis

Ranking queries (ROW_NUMBER)

Aggregation for revenue & profit

Monthly, seasonal, and demographic insights

Anyone reviewing the project can simply click the link above to see the full SQL logic.


### Results / Findings

Key insights from the analysis include:

- Identification of high-value customers driving sales

- Clear peak periods across months and seasons

- Strong performance in specific product categories

- Suppliers contributing highest profit margins

- Regions generating the strongest sales volume

- Top-performing age groups and gender distribution

- Products with the highest order count and revenue

- Noticeable month-over-month revenue movements


### Recommendations

- Increase inventory for high-demand product categories

- Strengthen relationships with top-performing suppliers

- Launch promotions during low-sales seasons

- Target marketing toward high-revenue age groups & regions

- Develop loyalty strategies for top 10 customers

- Use MoM revenue trends to optimize marketing cycles


