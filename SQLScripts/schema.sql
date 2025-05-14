-- CREATE DATABASE superstore_kpi
CREATE DATABASE superstore_kpi;

-- USE the superstore_kpi database
USE superstore_kpi;

-- CREATE a table to store superstore data temporarily
CREATE TABLE superstore (
  rowid INT NOT NULL UNIQUE, 
  orderid VARCHAR(30) NOT NULL,
  orderdate VARCHAR(30) NOT NULL, 
  shipdate VARCHAR(30) NOT NULL,
  customerid VARCHAR(30) NOT NULL, 
  customer_name VARCHAR(100) NOT NULL,
  segment VARCHAR(30) NOT NULL, 
  city VARCHAR(50) NOT NULL,
  state VARCHAR(50) NOT NULL,
  country VARCHAR(50) NOT NULL,
  market VARCHAR(30) NOT NULL,
  region VARCHAR(30) NOT NULL,
  productid VARCHAR(30) NOT NULL,
  category VARCHAR(30) NOT NULL,
  subcategory VARCHAR(30) NOT NULL, 
  productname VARCHAR(300) NOT NULL,
  sales FLOAT NOT NULL,
  quantity INT NOT NULL, 
  discount FLOAT NOT NULL,
  profit FLOAT NOT NULL,
  shipping_cost FLOAT NOT NULL
);

-- CUSTOMER TABLE SCHEMA
CREATE TABLE customers (
  customerid VARCHAR(30),
  customer_name VARCHAR(100),
  segment VARCHAR(30),
  PRIMARY KEY (customerid)
);

-- PRODUCT TABLE
CREATE TABLE products (
  id INT AUTO_INCREMENT,
  productid VARCHAR(30) NOT NULL,
  category VARCHAR(30) NOT NULL,
  subcategory VARCHAR(30) NOT NULL, 
  productname VARCHAR(300) NOT NULL,
  PRIMARY KEY (id)
);

-- LOCATION TABLE
CREATE TABLE locations (
  id INT AUTO_INCREMENT,
  city VARCHAR(50) NOT NULL,
  state VARCHAR(50) NOT NULL,
  country VARCHAR(50) NOT NULL,
  market VARCHAR(30) NOT NULL, 
  region VARCHAR(30) NOT NULL,
  PRIMARY KEY (id)
);

-- ORDERS TABLE
CREATE TABLE orders (
  id INT AUTO_INCREMENT,
  orderid VARCHAR(30) NOT NULL,
  orderdate DATE NOT NULL, 
  shipdate DATE NOT NULL,
  customerid VARCHAR(30) NOT NULL,
  locationid INT NOT NULL,
  products_id INT NOT NULL,
  sales FLOAT NOT NULL,
  quantity INT NOT NULL, 
  discount FLOAT NOT NULL,
  profit FLOAT NOT NULL,
  shipping_cost FLOAT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (customerid) REFERENCES customers (customerid),
  FOREIGN KEY (locationid) REFERENCES locations (id),
  FOREIGN KEY (products_id) REFERENCES products (id)
);

-- RETURNS TABLE 
-- 1. Superstore dataset table
CREATE TABLE superstore_returns (
  returned VARCHAR(10),
  orderid VARCHAR(30) NOT NULL,
  market VARCHAR(30) NOT NULL 
);

-- 2. Database schema for returns
CREATE TABLE returns (
  orderid VARCHAR(30),
  PRIMARY KEY (orderid)
);

-- ADDING INDEXES
-- Indexes on frequently searched columns
CREATE INDEX idx_orders_orderid ON orders(orderid);
CREATE INDEX idx_orders_customerid ON orders(customerid);
CREATE INDEX idx_products_productid ON products(productid);
CREATE INDEX idx_locations_market ON locations(market);

-- For products join
CREATE INDEX idx_superstore_product ON superstore (productid, category, subcategory);

-- For locations join
CREATE INDEX idx_superstore_location ON superstore (city, state, country, market, region);
CREATE INDEX idx_products_full ON products (productid, category, subcategory);
CREATE INDEX idx_locations_full ON locations (city, state, country, market, region);
