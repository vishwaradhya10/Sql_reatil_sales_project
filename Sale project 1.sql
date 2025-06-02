--Data Cleaning

select * from retail_sales
where
transactions_id is null
or 
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or 
category is null
or 
quantiy is null
or
price_per_unit is null
or
cogs is null
or 
total_sale is null;

--Data exploration 

--How many sales do we have?
select count (*) as total_sales from retail_sales

--How many unique customer do we have?
Select count (distinct customer_id) as total_customers from retail_sales

--How many unique categories we have?
Select distinct category from retail_sales


--Data Analysis & Business quetions & key Answers
--My Analysis And findings

-- Q.1 Write a SQL query to retrieve all columns for the sales made on '2022-11-05'
Select *
from retail_sales
where sale_date='2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nove-2022

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND 
  to_char(sale_date, 'YYYY-MM') = '2022-11'
  AND 
  quantiy >= 4;

-- Q.3 Write a SQL query to calculate the total sales (toatl_sale)for each category.

Select
category,
Sum (total_sale) as net_sales,
count (*) as total_orders
from retail_sales
group by 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

Select
Round(Avg (age),2) as avg_age 
From retail_sales
where category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000

 Select * from retail_sales
 where total_sale > 1000

 -- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category

 Select 
 category,
 gender,
 Count (*) as total_transacions
 from retail_sales
 group 
 by
 category,
 gender

 -- Q.7  Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
 Select 
 year,
 month,
 avg_sale
 From
 (
 Select 
 Extract(YEAR from sale_date) as year,
 Extract (MONTH from sale_date) as month,
 AVG (total_sale) as avg_sale,
 Rank() over (partition by Extract(YEAR from sale_date) order by  AVG (total_sale) desc) as rank
 from retail_sales
 Group by 1,2
 ) as t1
 where rank = 1
 
 -- Q.8  Write a SQL query to find the top 5 customers based on the highest total sale

  Select 
  customer_id,
  sum(total_sale) as total_sales
  from retail_sales
  Group by 1
  order by 2 desc
  Limit 5
 
 -- Q.9  Write a SQL query to find the number of unique customers who purchased items from each category
 
   Select 
   Category,
   Count (distinct customer_id)
 from retail_sales
  Group by Category

-- Q.10  Write a SQL query to create each shift and number of orders (example morning <=12, Afternoon between 12& 17, evening >17)

  with Hourly_sale
  as
   (
   Select *,
	case 
	when extract (Hour from sale_time ) <12 then 'Morning'
	when extract (Hour from sale_time ) Between 12 and 17 then 'Afternoon'
	else 'Evening'
	end as shift
	from retail_sales
    ) 
	Select shift,
	count (*) as total_orders
	from Hourly_sale
	group by shift