use superstore_kpi;

-- 1. profit per market 
create view profit_per_market as
select market, round(sum(profit),2) as profit from orders
join locations on orders.locationid = locations.id
where NOT EXISTS (
    SELECT 1
    FROM returns r
    WHERE r.orderid = orders.orderid
)
group by market
order by profit desc;

-- 2 profit per year per market 
create view profit_per_year_per_market as
select year(orderdate) as 'year', market, round(sum(profit),2) as Profit from orders
join locations on orders.locationid=locations.id
where NOT EXISTS (
    SELECT 1
    FROM returns r
    WHERE r.orderid = orders.orderid
)
group by year(orderdate),market
order by 1,3 desc;