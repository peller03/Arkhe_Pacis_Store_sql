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

#### All SQL queries used in this project data cleaning, EDA, and business analysis are stored in:

 [`SQL_capston.sql`](SQL_capston.sql)


This file includes:

Data cleaning queries

```sql
-- To check if there is duplicate row in sales table 
SELECT 
    Customer_ID, Product_ID, Date, Quantity, Price, Discount,
    COUNT(*) AS occurrences
FROM [dbo].[Sales_sql]
GROUP BY  Customer_ID, Product_ID, Date, Quantity, Price, Discount
HAVING COUNT(*) > 1; -- it shows row with the same data greater than the unique


-- To check if there is duplicate row in product table
SELECT
       Product_ID,
	   Product_Name,
	   Category,
	   Supplier_ID,
	   Cost_Price,
	   COUNT(*) AS occurrence 
FROM [dbo].[product_sql]
GROUP BY Product_ID,Product_Name,Category,Supplier_ID,Cost_Price
HAVING COUNT( *) > 1

-- To check if there is duplicate row in Customer table
SELECT 
       Customer_ID,
	   Name,
	   Age,
	   Region,
	   COUNT(*) AS occurrence 
FROM[dbo].[customer]
GROUP BY Customer_ID,Name,Age,Region
HAVING  COUNT(*) > 1

-- Addind column to Show the final price after the discount is active

ALTER TABLE [dbo].[Sales_sql]
ADD  Final_Price DECIMAL(10, 2);

ALTER TABLE [dbo].[Sales_sql]
ALTER COLUMN Price DECIMAL(10, 2); -- change the column data type from money to decimal to avoid data type conflict 

UPDATE [dbo].[Sales_sql]
SET Final_Price = Price * (1 - Discount); --To know actual price paid after discount  

SELECT * FROM [dbo].[Sales_sql]

```

Table modification statements

KPI calculations

Joins across all datasets

CTE-based analysis
```sql
-- highest-value customers across product categories.

WITH total_spent AS(
SELECT 
          c.Customer_ID,
		  c.Name,
		  P.Category,
		  SUM(s.Quantity * s.Final_Price) AS total_spent
FROM [dbo].[Sales_sql] s
JOIN [dbo].[customer] c ON c.Customer_ID = s.Customer_ID
JOIN [dbo].[product_sql] p ON p.Product_ID = s.Product_ID
GROUP BY s.Sale_ID,c.Customer_ID,c.Name,p.Category
), high_value_customer AS(
SELECT 
        *,
		ROW_NUMBER() OVER (PARTITION BY Category ORDER BY total_spent DESC) AS rank
FROM total_spent
)
SELECT  
      customer_id,
	  name,
	  category,
	  total_spent,
	  rank
FROM high_value_customer
WHERE rank = 1

```

Ranking queries (ROW_NUMBER)

Aggregation for revenue & profit

Monthly, seasonal, and demographic insights

Anyone reviewing the project can simply click the link above to see the full SQL logic.


### Results / Findings

Key insights from the analysis include:

- Identification of high-value customers driving sales
```sql
SELECT  TOP 10
         name,
		 SUM(s.Quantity * s.Final_Price) AS Revenue
		 
FROM [dbo].[Sales_sql] s
JOIN [dbo].[customer] c ON c.Customer_ID = s.Customer_ID
GROUP BY c.name
ORDER BY Revenue DESC
```

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


