-- Sql Retails Sales Analysis - P1
CREATE DATABASE sql_project_01;
USE sql_project_01;

-- Create table 
CREATE TABLE retail_sales
			(
				transactions_id	INT PRIMARY KEY,
				sale_date	DATE,
				sale_time	TIME,
				customer_id	INT,
				gender	VARCHAR(15),
				age	INT,
				category VARCHAR(15),	
				quantiy	INT,
				price_per_unit	FLOAT,
				cogs	FLOAT,
				total_sale FLOAT
			);
SELECT*FROM retail_sales
limit 10;

SELECT
	COUNT(*)
FROM retail_sales;    

-- DATA CLEANING :
SELECT*FROM retail_sales
WHERE transactions_id IS NULL;

SELECT*FROM retail_sales
WHERE
	transactions_id IS NULL
    OR
    sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    customer_id IS NULL
    OR
    gender IS NULL
    OR
    age IS NULL
    OR
   category IS NULL
   OR
   quantiy IS NULL
   OR
   price_per_unit IS NULL
   OR
   cogs IS NULL
   OR
   total_sale IS NULL;

DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
    OR
    sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    customer_id IS NULL
    OR
    gender IS NULL
    OR
    age IS NULL
    OR
   category IS NULL
   OR
   quantiy IS NULL
   OR
   price_per_unit IS NULL
   OR
   cogs IS NULL
   OR
   total_sale IS NULL;

SET SQL_SAFE_UPDATES = 0;

SET SQL_SAFE_UPDATES = 1;

-- DATA EXPLORATION:

-- HOW MANY SALES THE CO HAVE?
SELECT
	COUNT(*) AS Total_Sales
FROM retail_sales;

-- HOW MANY CUSTOMERS DO WE HAVE ?
SELECT
COUNT(customer_id) AS Total_Customers
FROM retail_sales; 

-- HOW MANY unique CUSTOMERS DO WE HAVE ?
SELECT 
	COUNT( DISTINCT customer_id) 
FROM retail_sales;

-- HOW MANY CATEGORY OF PRODUCTS DO WE HAVE?
SELECT 
	COUNT(DISTINCT Category) AS CATEGORY
FROM  retail_sales;

-- NAME OF THE DISTINCT CATEGORY 
SELECT DISTINCT CATEGORY FROM retail_sales;

-- DATA ANALYSIS & BUSINESS KEY PROBLEMS & ITS SOLUTION:
-- Q.1 WRITE A SQL QUERY TO RETRIEVE ALL COLUMNS FOR SALES MADE ON '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05' ;
-- Q.2  WRITE A SQL QUERY TO RETRIEVE ALL TRANSACTIONS WHERE THE CATEGORY IS "CLOTHING' AND THE QUNATITY SOLD IS MORE THAN 4 IN THE MONTH OF NOV-2022
SELECT * FROM retail_sales
WHERE 
	category = 'CLOTHING'
	AND 
    date_format(sale_date,'%Y-%m') = '2022-11'
    AND
    quantiy>=4;
    -- Q.3  WRITE A SQL QUERY TO CALCULLATE TOTAL SALES FOR EACH CATEGORY
    SELECT 
		CATEGORY,
        SUM(total_sale) AS net_Sales
	FROM retail_sales
    GROUP BY 1;
-- Q.4 WRITE A SQL QUERY TO FIND THE AVG AGE OF CUSTOMERS WHO PURCHASE THW ITEMS FROM THE 'BEAUTY' CATEGORY 
SELECT 
ROUND(AVG(age),2) AS avg_Age
FROM retail_sales
WHERE category='beauty';
-- Q.5 WRITE A SQL QUERY TO FIND ALL TRANSACTIONS WHERE THE TOTAL_SALES IS GRETATER THAN 1000
SELECT*FROM retail_sales
WHERE total_sale>1000;
-- Q.6 Write a SQL query to find the total number of transactions made by each gender in each category 
SELECT 
	category,
    gender,
    COUNT(*) AS total_transaction 
FROM retail_sales
GROUP BY
	category,
    gender
ORDER BY 1;
-- Q.7  WRITE A SQL QUERY TO CALCULATE THE AVERAGE SALE FOR EACH MONTH.FIND OUT BEST SELLING MONTH IN EACH YEAR
SELECT*FROM
(
		SELECT 
			EXTRACT(YEAR FROM sale_date) AS year,
			EXTRACT(MONTH FROM sale_date) AS month,
			ROUND(AVG(total_sale),2) AS avg_sale,
			RANK() OVER (partition by EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as sales_rank
		FROM retail_sales
		GROUP BY 1,2 
) AS t1
WHERE sales_rank = 1
-- ORDER BY 1,3 DESC;
-- Q.8 WRITE A SQL QUERY TO FIND THE TOP 5 CUSTOMERS BASED ON THE HIGHEST TOTAL SALES
SELECT 
	Customer_id,
    SUM(total_sale) AS SUM
FROM retail_sales
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 5;
-- Q.9 WRITE A SQL QUERY TO FIND THE NUMBER OF UINQUE CUSTOMERS WHO PURCHASED ITEMS FROM EACH CATEGORY 
 SELECT
	category,
    COUNT(DISTINCT customer_id) AS cnt_nique_cs
FROM retail_sales
GROUP BY 1;
-- 10 WRITE A SQL QUERY TO CREATE EACH SHIFT AND NUMBER OF ORDER (EXAMPLE MORNING <=12, AFTERNOON BETWEEN 12 & 17 , EVENING >17)
WITH hourly_sale
AS
(
SELECT*,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'MORNING'
        WHEN EXTRACT(HOUR FROM sale_time)BETWEEN 12 AND 17 THEN 'AFTERNOON'
        ELSE 'EVENING'
	END AS Shift 
FROM retail_sales
)
SELECT
	Shift,
	COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY Shift ;

-- END OF PROJECT  
