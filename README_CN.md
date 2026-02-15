# 零售销售数据分析 SQL 项目

## 项目概述

**项目名称**：零售销售数据分析
**项目难度**：初级
**数据库名称**：`SQL_Project_1`

本项目旨在展示数据分析师常用的 SQL 技能与技术，包括对零售销售数据的探索、清洗与分析。项目内容涵盖数据库搭建、探索性数据分析（EDA），以及通过 SQL 查询回答具体业务问题

---

## 项目目标

1. **搭建零售销售数据库**：创建数据库并导入提供的销售数据。
2. **数据清洗**：识别并删除包含缺失值或空值的记录。
3. **探索性数据分析（EDA）**：对数据集进行基础探索，理解数据结构与分布情况。
4. **业务分析**：通过 SQL 查询回答具体业务问题，并从销售数据中提炼有价值的洞察。

---

## 项目结构

### 1. 数据库搭建

* **创建数据库**：新建名为 `SQL_Project_1` 的数据库。
* **创建数据表**：创建 `Retail_Sales` 表，用于存储销售数据。字段包括交易编号、销售日期、销售时间、客户编号、性别、年龄、产品类别、销售数量、单价、销售成本（COGS）以及总销售额。

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

---

### 2. 数据探索与清洗

* **记录总数统计**：统计数据集中总记录数。
* **客户数量统计**：统计唯一客户数量。
* **产品类别统计**：查看所有不同的产品类别。
* **空值检查**：检查数据中是否存在空值，并删除相关记录。
* **时间格式调整**：将时间格式从 `hh:mm:ss:0000` 修改为 `hh:mm:ss`。

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

---

### 3. 数据分析与结果

以下 SQL 查询用于回答具体业务问题：

#### 1. 查询 2022-11-05 当天的所有销售记录

```sql
select * from Retail_Sales
where sale_date = '2022-11-05';
```

#### 2. 查询 2022 年 11 月中，类别为 Clothing 且销售数量大于等于 3 的交易记录

```sql
select *
from Retail_Sales
where 
    category = 'Clothing'
    and quantity >= 3
    and format(sale_date, 'yyyy-MM') = '2022-11';
```

#### 3. 计算每个产品类别的总销售额

```sql
select 
    category,
    sum(total_sale) as net_sale,
    count(*) as total_sales
from Retail_Sales
group by category;
```

#### 4. 计算购买 Beauty 类别商品客户的平均年龄

```sql
select
    round(avg(age), 0) as Avg_age
from Retail_Sales
where category = 'Beauty'
```

#### 5. 查询总销售额大于 1000 的交易记录

```sql
select 
    *
from Retail_Sales
where total_sale > 1000;
```

#### 6. 统计每个类别中不同性别的交易数量

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

#### 7. 计算每月平均销售额，并找出每年销售额最高的月份

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

#### 8. 查询总销售额最高的前 5 位客户

```sql
select top 5
    customer_id,
    sum(total_sale) as total_sales
from Retail_Sales
group by customer_id
order by sum(total_sale) desc;
```

#### 9. 统计每个类别的唯一客户数量

```sql
select
    category,
    count(distinct customer_id) as uni_customer
from Retail_Sales
group by category;
```

#### 10. 按时间段划分班次并统计订单数量（早上 <12 点，下午 12–17 点，晚上 >17 点）

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

---

## 主要发现

* **客户结构分析**：数据涵盖多个年龄层客户，销售分布于 Clothing、Beauty 等多个产品类别。
* **高价值交易识别**：存在多笔总销售额超过 1000 的交易，体现出高客单价消费行为。
* **销售趋势分析**：通过月度分析识别出不同年份的销售高峰月份，有助于理解季节性变化。
* **客户洞察**：识别出高消费客户群体以及受欢迎的产品类别，为营销决策提供数据支持。

---

## 使用说明

1. 将 `Retail_Sales.csv` 导入 SQL Server。
2. 使用提供的 SQL 脚本创建数据库和数据表。
3. 在 SQL Server Management Studio（SSMS）中运行各查询语句查看分析结果。

