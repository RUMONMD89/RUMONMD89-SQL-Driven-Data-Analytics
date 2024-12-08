
-- select * from df_orders

--now we try to solution this question
--1) find top 10 highest reveue generating products

select top 10 product_id,sum(sale_price)as sales
from df_orders
group by product_id
order by sales desc

--2) find top 5 highest selling products in each region
--select distinct region from df_orders
with city as (
select  region, product_id,sum(sale_price)as sales
from df_orders
group by region,product_id)
--order by region,sales desc
select *from (
select * 
, row_number() over(partition by region order by sales desc) as rn
from city) A
 where rn<=5
