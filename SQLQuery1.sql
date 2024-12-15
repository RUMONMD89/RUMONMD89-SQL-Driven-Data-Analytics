
-- select * from df_orders

--now we try to solution this question
--1) find top 10 highest reveue generating products

select top 10 product_id,sum(sale_price)as sales
from df_orders
group by product_id
order by sales desc
---------------------------------------------------------------------------------
--2) find top 3 highest selling products in each region
--select distinct region from df_orders
with cte as (
select  region, product_id,sum(sale_price)as sales
from df_orders
group by region,product_id)
--order by region,sales desc
select *from (
select * 
, row_number() over(partition by region order by sales desc) as rn
from cte) A
 where rn<=3
----------------------------------------------------------------------------------
--3Q) find month over month growth compare 2022~2023
with cte as(
 select  year(order_date) as order_year,month(order_date) as order_month,
 sum(sale_price) as sales
 from df_orders
 group by year(order_date),month(order_date)
 --order by year(order_date),month(order_date)
-- group by year(order_date),month(order_date)	  
)
select order_month
, sum (case when order_year = 2022 then sales else 0 end) as sales_2022
, sum (case when order_year = 2023 then sales else 0 end) as sales_2023
from cte
group by order_month
order by order_month

----------------------------------------------------------------------------------------
--4Q) Identify the top3 month with the highest sales for each category


with cte as (
select category, format (order_date,'yyyyMM')as order_year_month,
sum(sale_price) as sales
from df_orders
group by category, format(order_date,'yyyyMM')
--order by category, format(order_date,'yyyyMM')
) 
select * from(
select *,
row_number() over(partition by category order by sales desc) as rn
from cte
) a 
where rn=1

------------------------------------------------------------------------------------------------
--5Q) identify the which top 5 sub category has highest growth by profit in 2023 compare to 2022

with cte as(
 select  sub_category,year(order_date) as order_year,
 sum(sale_price) as sales
 from df_orders
 group by sub_category, year(order_date)
 --order by year(order_date),month(order_date)
-- group by year(order_date),month(order_date)	  
 )
,cte2 as (
select sub_category
, sum (case when order_year = 2022 then sales else 0 end) as sales_2022
, sum (case when order_year = 2023 then sales else 0 end) as sales_2023
from cte
group by sub_category
)
select top 5 *
,((sales_2023-sales_2022)) as highes_growth
from cte2
order by (sales_2023-sales_2022) desc
