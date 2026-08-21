SQL Retail Sales Analysis — P1

## Project Overview

**Project Title:** Retail Sales Analysis
**Level:** Beginner
**Database:** `sql_project_01`

This project demonstrates core SQL skills used by data analysts to explore, clean, and analyze retail sales data. It covers setting up a retail sales database, performing exploratory data analysis (EDA), cleaning the data, and answering specific business questions through SQL queries. This project is ideal for those starting their data analyst journey and looking to build a solid foundation in SQL.

---

## Objectives

1. **Set up a retail sales database:** Create and populate a retail sales table with the provided sales data.
2. **Data Cleaning:** Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA):** Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis:** Use SQL to answer specific business questions and derive insights from the sales data.

---

## Project Structure

### 1. Database Setup

```sql
CREATE DATABASE sql_project_01;
USE sql_project_01;

CREATE TABLE retail_sales
(
    transactions_id  INT PRIMARY KEY,
    sale_date        DATE,
    sale_time        TIME,
    customer_id      INT,
    gender           VARCHAR(15),
    age              INT,
    category         VARCHAR(15),
    quantiy          INT,
    price_per_unit   FLOAT,
    cogs             FLOAT,
    total_sale       FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count:** Total number of records in the dataset.
- **Customer Count:** Total number of unique customers.
- **Category Count:** All unique product categories.
- **Null Value Check:** Checked for null values in all columns and deleted records with missing data.

```sql
DELETE FROM retail_sales
WHERE
    transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL
    OR customer_id IS NULL OR gender IS NULL OR age IS NULL
    OR category IS NULL OR quantiy IS NULL OR price_per_unit IS NULL
    OR cogs IS NULL OR total_sale IS NULL;
```

### 3. Data Analysis & Business Key Questions

The following SQL queries were developed to answer specific business questions:

1. **Retrieve all sales made on `2022-11-05`:**
```sql
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Retrieve all transactions where category is `Clothing` and quantity sold is more than 4 in Nov-2022:**
```sql
SELECT * FROM retail_sales
WHERE
    category = 'CLOTHING'
    AND date_format(sale_date, '%Y-%m') = '2022-11'
    AND quantiy >= 4;
```

3. **Calculate total sales for each category:**
```sql
SELECT category, SUM(total_sale) AS net_Sales
FROM retail_sales
GROUP BY 1;
```

4. **Find the average age of customers who purchased from the `Beauty` category:**
```sql
SELECT ROUND(AVG(age), 2) AS avg_Age
FROM retail_sales
WHERE category = 'beauty';
```

5. **Find all transactions where total sale is greater than 1000:**
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000;
```

6. **Find the total number of transactions made by each gender in each category:**
```sql
SELECT category, gender, COUNT(*) AS total_transaction
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;
```

7. **Calculate the average sale for each month and find the best-selling month in each year:**
```sql
SELECT * FROM
(
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        ROUND(AVG(total_sale), 2) AS avg_sale,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS sales_rank
    FROM retail_sales
    GROUP BY 1, 2
) AS t1
WHERE sales_rank = 1;
```

8. **Find the top 5 customers based on the highest total sales:**
```sql
SELECT customer_id, SUM(total_sale) AS total_sale_sum
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

9. **Find the number of unique customers who purchased items from each category:**
```sql
SELECT category, COUNT(DISTINCT customer_id) AS cnt_unique_cs
FROM retail_sales
GROUP BY 1;
```

10. **Create shifts and find the number of orders (Morning <=12, Afternoon 12-17, Evening >17):**
```sql
WITH hourly_sale AS
(
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'MORNING'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
            ELSE 'EVENING'
        END AS shift
    FROM retail_sales
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
```

---

## Key Findings

- **Customer Demographics:** The dataset includes customers across various age groups, with sales distributed across categories like Clothing, Beauty, and Electronics.
- **High-Value Transactions:** Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends:** Monthly analysis reveals fluctuations in sales, helping identify the best-performing month for each year.
- **Customer Insights:** The analysis identifies the top-spending customers and the unique customer count per category.

---

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings help understand customer behavior, sales trends, and category performance, which can guide business decisions.

---

## How to Use

1. **Clone the Repository:** Clone this repository to your local machine.
   ```bash
   git clone https://github.com/Devanshi18006/sql-retail-sales-analysis.git
   ```
2. **Set Up the Database:** Run the SQL script `sql_query_p1.sql` to create and populate the database.
3. **Run the Queries:** Use the SQL queries provided in the script to perform your own analysis.
4. **Explore and Modify:** Feel free to modify the queries to explore different aspects of the dataset.

---

## Author

This project is part of my SQL portfolio, showcasing SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to reach out!
