create database sales;
use sales;
select * from retail_sales;
-- data cleaning--
alter table retail_sales
change id trans_id int;

alter table retail_sales
change quantiy quantity int;

-- Data Exploration
-- 1. How many sales we have?
select count(*) as total_sales from retail_sales;

-- 2. How many customers we have?
select count(distinct id)from retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
    
-- data analysis--
-- 1. Write a query to retrieve all columns for sales made on '2022-11-05'.
select *
from retail_sales
where sale_date = '2022-11-05';

-- 2.Write a query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022? 
select * from retail_sales
where category = "Clothing"
and 
char(sale_date , 'YYYY-MM') = '2022-11'
and
quantity >=4;

-- 3. Write a query to calculate the total sales (total_sale) for each category?
SELECT category,
SUM(total_sale) as net_sale,
COUNT(*) as total_orders
FROM retail_sales
GROUP BY category;

-- 4. Write a query to find the average age of customers who purchased items from the 'Beauty' category?
select round(avg(age),0)
from retail_sales
where category = "Beauty";

-- 5. Write a query to find all transactions where the total_sale is greater than 1000?
select * from retail_sales
where total_sale> 1000;

-- 6.Write a query to find the total number of transactions (transaction_id) made by each gender in each category?
select category, gender,
count(trans_id) as total_transactions
from retail_sales
group by category, gender 
order by total_transactions;

-- 7. Write a query to calculate the average sale for each month. Find out best selling month in each year?
select year, month, average_sale
from(
	 select 
     EXTRACT(YEAR from sale_date) as year,
     EXTRACT(MONTH from sale_date) as month,
     avg(total_sale) as average_sale,
     rank()over(partition by extract(year from sale_date) order by avg(total_sale) desc) as sale_rank
     from retail_sales
	group by year, month
     )r
     where sale_rank = 1;
     
-- 8. Write a query to find the top 5 customers based on the highest total sales?
Select customer_id, sum(total_sale) as total_sales
from retail_sales
group by customer_id
order by total_sales desc
limit 5;

-- 9. Write a query to find the number of unique customers who purchased items from each category?
Select category,
count(distinct customer_id) as total_customers
from retail_sales
group by category;

-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)?
with hourly_sale as(
        select *,
		case
		when extract(hour from sale_time) <12 then "Morning"
        when extract(hour from sale_time) between 12 and 17 then "Afternoon"
        else "Evening"
        END AS Shift
        from retail_sales)
select Shift,
Count(*) as total_orders
from hourly_sale
group by Shift;