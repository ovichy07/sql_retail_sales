--CREATE TABLE
DROP TABLE IF EXISTS retail_sales;
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
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT

			);
SELECT * FROM retail_sales
LIMIT 10


SELECT
	COUNT(*) 
FROM retail_sales

--Data Cleaning

DELETE FROM retail_sales
WHERE 
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	or
	category IS NULL
	or
	quantiy IS NULL
	or
	price_per_unit IS NULL
	or 
	cogs IS NULL
	or
	total_sale IS NULL;

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale from retail_sales

--How many unique customer we have?

SELECT COUNT(DISTINCT customer_id) as total_sale from retail_sales


SELECT DISTINCT category from retail_sales

--Data Analysis & Business Key Problem & Answers
--Q1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
--Q2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
--Q3 Write a SQL query to calculate the total sales (total_sale) for each category
--Q4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
--Q5 Write a SQL query to find all transactions where the total_sale is greater than 1000
--Q6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
--Q7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
--Q8 Write a SQL query to find the top 5 customers based on the highest total sales
--Q9 Write a SQL query to find the number of unique customers who purchased items from each category
--Q10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)


--Q1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

--Q2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND
quantiy >=3

--Q3 Write a SQL query to calculate the total sales (total_sale) for each category
SELECT 
	category,
	sum(total_sale) as net_sale,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1

--Q4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category

SELECT	
	ROUND (AVG(age),2) as avg_age
FROM retail_sales
WHERE category ='Beauty'

--Q5 Write a SQL query to find all transactions where the total_sale is greater than 1000

SELECT *
FROM retail_sales
WHERE total_sale >=1000

--Q6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category

SELECT
	category,
	gender,
	COUNT(*) AS total_trans
FROM retail_sales
GROUP 
	BY
	category,
	gender

--Q7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
		year,
		month,
		avg_sale
from
(
select
	EXTRACT (YEAR FROM sale_date) as year,
	EXTRACT (MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG (total_sale)DESC)
FROM retail_sales
GROUP BY 1,2
) as t1
where rank = 1

--Q8 Write a SQL query to find the top 5 customers based on the highest total sales

SELECT 
	customer_id,
	sum(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q9 Write a SQL query to find the number of unique customers who purchased items from each category
SELECT
	category,
	COUNT(DISTINCT customer_id) as unique_customers
FROM retail_sales
GROUP BY category

--Q10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

with hourly_sale
as
(
SELECT *,
	CASE
		WHEN extract(hour from sale_time) < 12 THEN 'Morning'
		WHEN extract(hour from sale_time) between 12 and 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift

FROM retail_sales
)

Select 
	shift,
	count(*) as total_orders
from hourly_sale
group by shift

--End of Project



