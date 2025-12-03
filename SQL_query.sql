                           --CASE STUDY
-- Topic: Uncovering Business Trends from a Multi-Table Sales Dataset Using SQL


USE [sql_capston];

GO

SELECT * FROM [dbo].[customer];

SELECT * FROM [dbo].[product_sql]

SELECT * FROM [dbo].[supplier_sql]

SELECT * FROM  [dbo].[Sales_sql] 

UPDATE [dbo].[Sales_sql]
SET Discount = ROUND(Discount,2)

 



                        --Data cleaning
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

                                     --Objectives
-- To analyze customer purchase behavior and revenue patterns across product categories and time periods.
-- To evaluate product and supplier performance to improve inventory, pricing, and promotional strategies.


-- Customer segmentaion based 
-- Who are our top 10 customer with total sales revenue ?
-- To identify High Value customer

SELECT  TOP 10
         name,
		 SUM(s.Quantity * s.Final_Price) AS Revenue
		 
FROM [dbo].[Sales_sql] s
JOIN [dbo].[customer] c ON c.Customer_ID = s.Customer_ID
GROUP BY c.name
ORDER BY Revenue DESC

--Customer Segmentation based on the location/region
-- To identify customers who spent the most within each product category.

SELECT TOP 5
         c.Name,
		 c.region,
		 SUM(s.Quantity * s.Final_Price) AS Revenue
		 
FROM [dbo].[Sales_sql] s
JOIN [dbo].[customer] c ON c.Customer_ID = s.Customer_ID
GROUP BY c.name, c.Region
ORDER BY Revenue DESC

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

SELECT * FROM [dbo].[product_sql]

--Daily trend
-- This counts the number of sales records

SELECT
          DATENAME(DW,s.Date) AS Week,
		  DATEPART(DW,s.Date) AS week_number,
		  COUNT(s.Sale_ID) AS Total_quantity
FROM 
[dbo].[Sales_sql] s
GROUP BY DATENAME(DW,s.Date),DATEPART(DW,s.Date)  
ORDER BY DATEPART(DW,s.Date)  

 --Top  most value product name

SELECT Top 10
          p.Product_Name,
		  SUM(s.Quantity * s.Final_Price) AS total_spent
FROM [dbo].[Sales_sql] s
JOIN [dbo].[customer] c ON c.Customer_ID = s.Customer_ID
JOIN [dbo].[product_sql] p ON p.Product_ID = s.Product_ID
GROUP BY p.Product_Name
ORDER BY total_spent DESC

--Most order product

SELECT 
          p.Product_ID,
		  p.Product_Name,
		  p.category,
		  COUNT(s.Sale_ID) AS Most_order_product
FROM [dbo].[Sales_sql] s
JOIN [dbo].[customer] c ON c.Customer_ID = s.Customer_ID
JOIN [dbo].[product_sql] p ON p.Product_ID = s.Product_ID
GROUP BY p.Product_Name, p.Product_ID,p.category
ORDER BY Most_order_product DESC


-- Changes in customer purchase behavior over time (seasonal patterns).
-- It refers to how customers buy differently at different times of the year.

SELECT 
          DATENAME(MONTH, s.date ) AS Month_name,
		  COUNT(S.Sale_ID) AS total_orders,
		  SUM(s.quantity) AS total_quanty,
		  SUM(S.Quantity * S.Final_Price) AS total_revenue
FROM [dbo].[Sales_sql] s
JOIN [dbo].[customer] c ON c.Customer_ID = s.Customer_ID
JOIN [dbo].[product_sql] p ON p.Product_ID = s.Product_ID
GROUP BY DATENAME(MONTH, s.date )
ORDER BY total_revenue DESC

-- Best-performing suppliers based on product sales and profit.

SELECT 
         sp.Supplier_ID,
		 sp.Supplier_Name,
		 SUM(s.quantity) AS quantity_sold,
		 SUM( (s.final_price - p.cost_price) * s.Quantity)   AS profit
FROM [dbo].[Sales_sql] s
JOIN [dbo].[customer] c ON c.Customer_ID = s.Customer_ID
JOIN [dbo].[product_sql] p ON p.Product_ID = s.Product_ID
JOIN [dbo].[supplier_sql] sp ON sp.Supplier_ID = p.Supplier_ID
GROUP BY sp.Supplier_ID,  sp.Supplier_Name
ORDER BY  profit DESC

-- TOTAL NUMBER SALE FROM EACH CATEGORY

SELECT 
          p.Category,
		  COUNT(s.Sale_ID) AS total_no_sale,
		  SUM(s.Final_Price * s.Quantity) as revenue
FROM [dbo].[Sales_sql] s
JOIN [dbo].[customer] c ON c.Customer_ID = s.Customer_ID
JOIN [dbo].[product_sql] p ON p.Product_ID = s.Product_ID
JOIN [dbo].[supplier_sql] sp ON sp.Supplier_ID = p.Supplier_ID
GROUP BY p.Category
ORDER BY revenue desc

-- Seasonal purchase behavior
SELECT 
   CASE
		  WHEN  DATEPART(MONTH, s.Date)  IN ( 1,2,12) THEN 'Winter'
		  WHEN   DATEPART(MONTH, s.Date) IN ( 3,4,5 ) THEN 'Spring'
		  WHEN   DATEPART(MONTH, s.Date) IN ( 6,7,8 ) THEN 'Summer'
		  WHEN   DATEPART(MONTH, s.Date) IN  ( 9,10,11 ) THEN 'Autumn'
	END AS Season,
		  COUNT(S.Sale_ID) AS best_season	 
FROM [dbo].[Sales_sql] s
JOIN [dbo].[customer] c ON c.Customer_ID = s.Customer_ID
JOIN [dbo].[product_sql] p ON p.Product_ID = s.Product_ID
JOIN [dbo].[supplier_sql] sp ON sp.Supplier_ID = p.Supplier_ID
GROUP BY  CASE
		  WHEN  DATEPART(MONTH, s.Date)  IN ( 1,2,12) THEN 'Winter'
		  WHEN   DATEPART(MONTH, s.Date) IN ( 3,4,5 ) THEN 'Spring'
		  WHEN   DATEPART(MONTH, s.Date) IN ( 6,7,8 ) THEN 'Summer'
		  WHEN   DATEPART(MONTH, s.Date) IN  ( 9,10,11 ) THEN 'Autumn'
	END 
 ORDER BY best_season DESC

 -- Performance by age (total order by age)
 SELECT 
    CASE 
        WHEN Age < 26 THEN '18-25'
        WHEN Age < 36 THEN '26-35'
        WHEN Age < 46 THEN '36-45'
        WHEN Age < 61 THEN '46-60'
        ELSE '60+'
    END AS Age_Group,
    COUNT(Sale_ID) AS Total_Orders,
    SUM(Quantity * Final_Price) AS Total_Revenue
FROM [dbo].[Sales_sql] s
JOIN [dbo].[customer] c ON s.Customer_ID = c.Customer_ID
GROUP BY 
    CASE 
        WHEN Age < 26 THEN '18-25'
        WHEN Age < 36 THEN '26-35'
        WHEN Age < 46 THEN '36-45'
        WHEN Age < 61 THEN '46-60'
        ELSE '60+'
    END
ORDER BY Age_Group;

-- Gender based performance 

SELECT 
    c.Gender,
    COUNT(s.Sale_ID) AS Total_Orders,
    SUM(s.Quantity * s.Final_Price) AS Total_Revenue
FROM [dbo].[Sales_sql] s
JOIN [dbo].[customer] c ON s.Customer_ID = c.Customer_ID
GROUP BY c.Gender
ORDER BY Total_Revenue DESC;

  

-- Region with more order(To know best performing region )
SELECT 
         c.Region,
		 COUNT(s.sale_id) AS order_count
FROM [dbo].[Sales_sql] s
JOIN [dbo].[customer] c ON c.Customer_ID = s.Customer_ID
JOIN [dbo].[product_sql] p ON p.Product_ID = s.Product_ID
JOIN [dbo].[supplier_sql] sp ON sp.Supplier_ID = p.Supplier_ID
GROUP BY  c.Region
ORDER BY  order_count  DESC

-- MoM Revenue Growth 
--how your revenue changed month by month.

WITH month_revenue AS(
SELECT 
         DATEPART(MONTH, s.Date) AS Month_name,
		 DATENAME(MONTH, s.date) AS month,
		 SUM(S.Quantity * S.Final_Price) AS total_revenue
FROM [dbo].[Sales_sql] s
JOIN [dbo].[customer] c ON c.Customer_ID = s.Customer_ID
JOIN [dbo].[product_sql] p ON p.Product_ID = s.Product_ID
JOIN [dbo].[supplier_sql] sp ON sp.Supplier_ID = p.Supplier_ID
GROUP BY  DATEPART(MONTH, s.Date), DATENAME(MONTH, s.date)
), previous_revenue AS(

SELECT 
        *,
		LAG(total_revenue,1, total_revenue) OVER(ORDER BY month_name ASC ) AS prev_revenue

FROM month_revenue

)

SELECT 
        *,
	 (total_revenue - prev_revenue)/total_revenue * 100 AS MoM

FROM previous_revenue

-- supplier that their product offer more profit
SELECT 
         sp.Supplier_Name,
		 sp.Supplier_ID,
		 SUM(s.Final_Price - p.Cost_Price) AS profit,
		 COUNT (s.Quantity) AS totatl_unit_sold 
FROM [dbo].[Sales_sql] s
JOIN [dbo].[customer] c ON c.Customer_ID = s.Customer_ID
JOIN [dbo].[product_sql] p ON p.Product_ID = s.Product_ID
JOIN [dbo].[supplier_sql] sp ON sp.Supplier_ID = p.Supplier_ID
GROUP BY SP.Supplier_Name,SP.Supplier_ID
 ORDER BY profit DESC


  --KPI 
SELECT --total_revenue 

        SUM(Final_Price * Quantity) AS total_revenue

FROM [dbo].[Sales_sql]

SELECT --total_product

       COUNT(Product_ID)  

FROM  [dbo].[product_sql]


SELECT --total_order

       COUNT(Sale_ID)  

FROM [dbo].[Sales_sql]

SELECT --total_supplier

       COUNT(Supplier_ID)  

FROM [dbo].[supplier_sql]