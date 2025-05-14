use superstore_kpi;

-- 1 total orders per segment
create view orders_per_segment as
select segment, count(distinct orderid) as total_orders ,sum(quantity) as total_units
from orders o
join customers c on o.customerid=c.customerid
group by segment
order by 3 desc,2 desc; 

-- 2 top 1% highest selling products
create view highest_selling_products as
with total_quantity as (
select products_id,sum(quantity) units from orders
group by products_id),
products_units as(
select productid,productname,sum(units)as units from total_quantity tq
join products p on tq.products_id=p.id
group by productid,productname),
top_products as(
select productid,productname,units,ntile(100) over(order by units desc)as place from products_units
)
select productid,productname,units from top_products
where place=1
order by units desc,productid
limit 100;


-- 3 top 20% highest selling subcategory
create view highest_selling_subcategories as
with total_quantity as (
select products_id,sum(quantity) units from orders
group by products_id),
products_units as(
select subcategory,sum(units)as units from total_quantity tq
join products p on tq.products_id=p.id
group by subcategory ),
top_products as(
select subcategory,units,ntile(5) over(order by units desc)as place from products_units
)
select subcategory,units from top_products
where place=1
order by units desc,subcategory;

