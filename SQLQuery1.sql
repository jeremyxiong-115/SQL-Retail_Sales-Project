-- SQl Retails Sales Analysis - P1


-- Create Table
/* DROP TABLE IF EXISTS Retail_Sales;
CREATE TABLE Retail_Sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender NVARCHAR(10),
    age INT NULL,
    category NVARCHAR(50),
    quantity INT NULL,
    price_per_unit DECIMAL(10,2),
    cogs DECIMAL(10,2),
    total_sale DECIMAL(10,2)
)*/

select top 10 * from Retail_Sales

select count(*) from Retail_Sales


-- Data Cleaning
select * from Retail_Sales
where transactions_id is null

select * from Retail_Sales
where sale_date is null

select * from Retail_Sales
where sale_time is null

select * from Retail_Sales
where
    transactions_id is null
    or sale_date is null
    or sale_time is null
    or customer_id is null
    or gender is null
    or age is null
    or category is null
    or quantity is null
    or price_per_unit is null
    or cogs is null
    or total_sale is null

delete from Retail_Sales
where
    transactions_id is null
    or sale_date is null
    or sale_time is null
    or customer_id is null
    or gender is null
    or age is null
    or category is null
    or quantity is null
    or price_per_unit is null
    or cogs is null
    or total_sale is null

alter table Retail_Sales
alter column sale_time TIME(0)


-- Data Exploration

-- How many sales we have?
select count(*) as total_sales from Retail_Sales

-- How many unique customers we have?
select count(distinct customer_id) as total_customers from Retail_Sales

-- How many unique category we have?
select distinct category as total_category from Retail_Sales


-- Data Analysis & Business Key Problem & Answers


-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17).



-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from Retail_Sales
where sale_date = '2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
select *
from Retail_Sales
where 
    category = 'Clothing'
    and quantity >= 3
    and format(sale_date, 'yyyy-MM') = '2022-11'

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select 
    category,
    sum(total_sale) as net_sale,
    count(*) as total_sales
from Retail_Sales
group by category

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select
    round(avg(age), 0) as Avg_age
from Retail_Sales
where category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select 
    *
from Retail_Sales
where total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select 
    category,
    gender,
    count(*) as total_trans
from Retail_Sales
group by
    category,
    gender
order by category desc

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
select * from
(
    select
        year(sale_date) as year,
        month(sale_date) as month,
        avg(total_sale) as Avg_monthly_sale,
        rank() over(partition by year(sale_date) order by avg(total_sale) desc) as rank
    from Retail_Sales
    group by
        year(sale_date),
        month(sale_date)
) as t1
where rank = 1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.
select top 5
    customer_id,
    sum(total_sale) as total_sales
from Retail_Sales
group by customer_id
order by sum(total_sale) desc

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select
    category,
    count(distinct customer_id) as uni_customer
from Retail_Sales
group by category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17).
with hourly_sale as 
(
    select *,
        case
            when datepart(hour, sale_time) < 12 then 'Morning'
            when datepart(hour, sale_time) between 12 and 17 then 'Afternoon'
            else 'Evening'
        end as shift
    from Retail_Sales
)
select shift, count(*) as total_orders from hourly_sale
group by shift


-- End of project