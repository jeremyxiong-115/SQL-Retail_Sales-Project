# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `SQL_Project_1`

Designed and executed a retail sales analysis project using SQL to explore, clean, and analyze sales data, including database setup, data cleaning, and business insights through queries.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `SQL_Project_1`.
- **Table Creation**: A table named `Retail_Sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE Retail_Sales;

CREATE TABLE Retail_Sales 
(
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
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
- **Change Fomat of Time**: Change the format of hh:mm:ss:0000 to hh:mm:ss.

```sql
select top 10 * from Retail_Sales;
select count(*) from Retail_Sales;

select * from Retail_Sales
where
    transactions_id is null or sale_date is null or sale_time is null or 
    customer_id is null or gender is null or age is null or category is null
    or quantity is null or price_per_unit is null or cogs is null 
    or total_sale is null;

delete from Retail_Sales
where
    transactions_id is null or sale_date is null or sale_time is null or 
    customer_id is null or gender is null or age is null or category is null
    or quantity is null or price_per_unit is null or cogs is null 
    or total_sale is null;

alter table Retail_Sales;
alter column sale_time TIME(0);
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
select * from Retail_Sales
where sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022**:
```sql
select *
from Retail_Sales
where 
    category = 'Clothing'
    and quantity >= 3
    and format(sale_date, 'yyyy-MM') = '2022-11';
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
select 
    category,
    sum(total_sale) as net_sale,
    count(*) as total_sales
from Retail_Sales
group by category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
select
    round(avg(age), 0) as Avg_age
from Retail_Sales
where category = 'Beauty'
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
select 
    *
from Retail_Sales
where total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
select 
    category,
    gender,
    count(*) as total_trans
from Retail_Sales
group by
    category,
    gender
order by category desc;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
where rank = 1;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
select top 5
    customer_id,
    sum(total_sale) as total_sales
from Retail_Sales
group by customer_id
order by sum(total_sale) desc;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
select
    category,
    count(distinct customer_id) as uni_customer
from Retail_Sales
group by category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
group by shift;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Usage
1. Import `Retail_Sales.csv` into SQL Server.
2. Create the database and table using the provided SQL scripts.
3. Run each query in SQL Server Management Studio (SSMS) to see results.





















