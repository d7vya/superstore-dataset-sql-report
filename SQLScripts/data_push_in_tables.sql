-- USE the superstore_kpi database
USE superstore_kpi;

-- INSERT data into customers table
INSERT INTO customers (customerid, customer_name, segment)
SELECT DISTINCT customerid, customer_name, segment 
FROM superstore;

-- INSERT data into products table
INSERT INTO products (productid, category, subcategory, productname)
SELECT DISTINCT productid, category, subcategory, productname 
FROM superstore;

-- INSERT data into locations table
INSERT INTO locations (city, state, country, region, market)
SELECT DISTINCT city, state, country, region, market 
FROM superstore;

-- INSERT data into orders table 
INSERT INTO orders (
  orderid, orderdate, shipdate, customerid, locationid, products_id, 
  sales, quantity, discount, profit, shipping_cost
)
SELECT 
  orderid, 
  STR_TO_DATE(orderdate, '%d-%m-%Y'),
  STR_TO_DATE(shipdate, '%d-%m-%Y'),
  customerid, 
  l.id, 
  p.id, 
  sales, 
  quantity, 
  IF(discount >= 1, discount / 100, discount),
  profit, 
  shipping_cost
FROM superstore s
JOIN locations l
  ON s.city = l.city 
  AND s.state = l.state 
  AND s.country = l.country 
  AND s.market = l.market 
  AND s.region = l.region
JOIN products p 
  ON s.productid = p.productid 
  AND s.category = p.category 
  AND s.subcategory = p.subcategory 
  AND s.productname = p.productname;

-- INSERT data into returns table after importing data from returns.csv to superstore_returns
-- Important: Only orders in the orders table should be in the returns table
INSERT INTO returns (orderid)
SELECT DISTINCT o.orderid  
FROM orders o
JOIN superstore_returns s 
  ON o.orderid = s.orderid;
