use superstore_kpi;
-- 1. AOV per Customer
CREATE VIEW AOV_per_customer AS
SELECT customerid, ROUND(SUM(sales) / COUNT(DISTINCT orderid), 2) AS AOV
FROM orders
GROUP BY customerid;

-- 2. AOV per Market
CREATE VIEW AOV_per_market AS
WITH join_loc_ord AS (
    SELECT orderid, sales, market
    FROM orders
    JOIN locations ON orders.locationid = locations.id
)
SELECT market, ROUND(SUM(sales) / COUNT(DISTINCT orderid), 2) AS AOV
FROM join_loc_ord
GROUP BY market;

-- 3.AOV per Segment
CREATE VIEW AOV_per_segment AS
WITH join_ord_cust AS (
    SELECT cu.customerid, aov.AOV, cu.segment
    FROM AOV_per_customer aov
    JOIN customers cu ON aov.customerid = cu.customerid
)
SELECT segment, ROUND(AVG(AOV), 2) AS avg_AOV
FROM join_ord_cust
GROUP BY segment;
