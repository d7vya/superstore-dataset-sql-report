use superstore_kpi;
-- 1 gross revenue per year per market
CREATE VIEW Gross_Revenue_per_year_per_market as
select year(orderdate) as 'year', market, round(sum(sales),2) as Revenue from orders
join locations on orders.locationid=locations.id
group by year(orderdate),market;

-- 2 revenue per year per market
CREATE VIEW Revenue_per_year_per_market as
with non_return_orders as(
select orderdate,market,sales from orders o
join locations on o.locationid=locations.id
where NOT EXISTS (
    SELECT 1
    FROM returns r
    WHERE r.orderid = o.orderid
))
select year(orderdate) as 'year',market,round(sum(sales),2) as Revenue from non_return_orders
group by year(orderdate),market;

-- 3 highest revenue market analysis 
create view highest_revenue_market_analysis as
with extract_market as (
select market, round(sum(Revenue),2)as revenue from Revenue_per_year_per_market
group by market
order by revenue desc
limit 1),
market_each_country as (
select id,country from locations 
where market = (select market from extract_market)),
sales_orders_each_country as (
select country,count(distinct orderid) as total_orders,round(sum(sales),2) as sales,ROUND(SUM(sales)/COUNT(DISTINCT orderid), 2) AS AOV from orders o
join market_each_country mc on o.locationid=mc.id
group by country)
select * from sales_orders_each_country
order by 2 desc,3 desc;

-- 4 lowest revenue market analysis
create view lowest_revenue_market_analysis as
with extract_market as (
select market, round(sum(Revenue),2)as revenue from Revenue_per_year_per_market
group by market
order by revenue 
limit 1),
market_each_country as (
select id,country from locations 
where market = (select market from extract_market)),
sales_orders_each_country as (
select country,count(distinct orderid) as total_orders,round(sum(sales),2) as sales,ROUND(SUM(sales)/COUNT(DISTINCT orderid), 2) AS AOV from orders o
join market_each_country mc on o.locationid=mc.id
group by country)
select * from sales_orders_each_country
order by 2 desc,3 desc;


