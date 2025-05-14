use superstore_kpi;
-- 1 returns and order per year
create view return_rate_per_year as
with orders_per_year as (
select year(orderdate) as 'year' ,count(distinct orderid) as orders from orders
group by year(orderdate)),
returns_per_year as(
select year(orderdate) as 'year' ,count(distinct orderid) as return_orders from orders
where exists (select 1 from returns where returns.orderid=orders.orderid)
group by year(orderdate))
select o.year ,  return_orders, orders from orders_per_year o
left join returns_per_year r on o.year=r.year;

-- 2 return rate per market 
create view return_rate_per_market as
with orders_per_market as (
select market ,count(distinct orderid) as orders from orders
join locations on orders.locationid=locations.id
group by market),
returns_per_market as(
select market ,count(distinct orderid) as return_orders from orders
join locations on orders.locationid=locations.id
where exists (select 1 from returns where returns.orderid=orders.orderid)
group by market )
select o.market ,  coalesce(return_orders,0) as return_orders,coalesce(orders ,0) orders from orders_per_market o
left join returns_per_market r on o.market=r.market
order by return_orders desc;

-- 3 return rate per year per market
create view return_rate_per_year_per_market as 
with orders_per_year_per_market as (
select year(orderdate) as 'year' ,market ,count(distinct orderid) as orders from orders
join locations on orders.locationid=locations.id
group by year(orderdate), market),
returns_per_year_per_market as(
select year(orderdate) as 'year',market ,count(distinct orderid) as return_order from orders
join locations on orders.locationid=locations.id
where exists (select 1 from returns where returns.orderid=orders.orderid)
group by year(orderdate), market)
select o.year, o.market ,  ROUND(COALESCE(r.return_order * 1.0 / o.orders, 0), 2) AS return_rate from orders_per_year_per_market o
left join returns_per_year_per_market r on o.market=r.market and o.year=r.year;

-- 4 returns per category
CREATE VIEW returns_per_category AS
WITH return_orders AS (
    SELECT o.orderid, o.products_id
    FROM orders o
    WHERE EXISTS (
        SELECT 1
        FROM returns r
        WHERE r.orderid = o.orderid
    )
),
return_category AS (
    SELECT ro.orderid, p.category
    FROM return_orders ro
    JOIN products p ON ro.products_id = p.id
)SELECT category, COUNT(DISTINCT orderid) AS return_orders
FROM return_category
GROUP BY category;


