create database Retail_Bike_Store_Sales;
use Retail_Bike_Store_Sales;

CREATE TABLE brands (
    brand_ID INT,
    brand_name VARCHAR(20)
);
select * from brands;

CREATE TABLE categories (
    category_Id INT,
    category_name VARCHAR(20)
);
select * from categories;

CREATE TABLE customers (
    customer_id INT,
    name VARCHAR(30),
    city VARCHAR(50),
    state VARCHAR(40)
); 
select * from customers;

CREATE TABLE order_items (
    order_id INT,
    item_id INT,
    product_id INT,
    quantity INT,
    list_price FLOAT,
    discount FLOAT
);
select * from order_items;

CREATE TABLE orders1 (
    order_id INT,
    customer_id INT,
    order_date DATE,
    required_date DATE,
    shipped_date DATE,
    store_id INT,
    staff_id INT
);
select * from orders1;


CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(50),
    brand_id INT,
    category_id INT,
    model_year YEAR,
    list_price FLOAT
);

select * from products;

CREATE TABLE Staff (
    staff_id INT,
    Emp_name VARCHAR(50),
    email VARCHAR(50),
    phone INT,
    active INT,
    store_id INT,
    maanger_id INT
);
select * from Staff;

CREATE TABLE stocks (
    store_id INT,
    product_id INT,
    quantity INT
);
select * from stocks;

CREATE TABLE stores (
    store_id INT,
    store_name VARCHAR(50),
    phone INT,
    email VARCHAR(40),
    street VARCHAR(100),
    city VARCHAR(40),
    state VARCHAR(20),
    zip_code INT
);

select * from stores;

    
-- Count Total Rows on each table

SELECT COUNT(*) AS total_brands FROM brands;
SELECT COUNT(*) AS total_categories FROM categories;
SELECT COUNT(*) AS total_products FROM products;
SELECT COUNT(*) AS total_customers FROM customers;
SELECT COUNT(*) AS total_stores FROM stores;
SELECT COUNT(*) AS total_staff FROM staff;
SELECT COUNT(*) AS total_orders FROM orders1;
SELECT COUNT(*) AS total_order_items FROM order_items;
SELECT COUNT(*) AS total_stocks FROM stocks;


-- First 5 Rows from every table for data look readable.
SELECT 
    *
FROM
    categories
LIMIT 5; 
#####################
SELECT 
    *
FROM
    products
LIMIT 5;
####################
SELECT 
    *
FROM
    customers
LIMIT 5;
###################
SELECT 
    *
FROM
    orders
LIMIT 5;
##################
SELECT 
    *
FROM
    order_items
LIMIT 5;
###################
SELECT 
    *
FROM
    staff
LIMIT 5; 
###################
SELECT 
    *
FROM
    stocks
LIMIT 5;
###################

-- Check null values every tables.

SELECT 
    SUM(category_name IS NULL) AS null_category_name
FROM
    categories;
    
#############################################################

select sum(product_name is null) as null_product_name,
sum(list_price is null) as null_price,
sum(category_id is null) as null_category
from products;

#############################################################
-- customer table

SELECT 
    SUM(name IS NULL) AS null_name,
    SUM(city IS NULL) AS null_city,
    SUM(state IS NULL) AS null_state
FROM
    customers; 
##############################################################

-- Order item table
select  sum(quantity is null) as null_quantity,
sum(list_price is null) as null_price,
sum(discount is null) as null_discount
from order_items;
##############################################################
-- orders table
SELECT 
    SUM(quantity IS NULL) AS null_quantity,
    SUM(list_price IS NULL) AS null_price,
    SUM(discount IS NULL) AS null_discount
FROM
    order_items;
#############################################################

-- Stocks table
SELECT 
    SUM(quantity IS NULL) AS null_stock
FROM
    stocks;

-- Checking Duplicate each 1 of table in this  table
SELECT customer_id, COUNT(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT order_id, COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;


SELECT product_id, COUNT(*)
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;
#######################################################

-- Orders and customers
SELECT 
    o.order_id
FROM
    orders o
        LEFT JOIN
    customers c ON o.customer_id = c.customer_id
WHERE
    c.customer_id is null;


-- Orders and stores
SELECT 
    o.store_id
FROM
    orders o
        LEFT JOIN
    stores s ON o.store_id = s.store_id
WHERE
    s.store_id
LIMIT 10;


-- Order Items and Products check null values


SELECT 
    oi.product_id
FROM
    order_items oi
        RIGHT JOIN
    Products p ON oi.product_id = p.product_id
WHERE
    p.product_id IS NULL;
    
-- order_item table check list price columns
select * from products
where list_price is null;

-- Order items table null values check.
 SELECT 
    *
FROM
    order_items
WHERE
    quantity IS NULL;
-- Discount columns check null value for null represent no discount on order_id
SELECT 
    *
FROM
    order_items
WHERE
    discount IS NULL;
    
##########################################################################################

-- Avoid space in products and customers table error less query perform

UPDATE customers 
SET 
    city = TRIM(city),
    state = TRIM(state);

UPDATE products 
SET 
    product_name = TRIM(product_name);

select * from products;

-- Final Check 
SELECT 
    COUNT(*) AS clean_order_items
FROM
    order_items;
    
SELECT 
    COUNT(*) AS clean_products
FROM
    products;

############################################################################################################################

-- Q1. Total Revenue
SELECT 
    SUM(quantity * list_price * (1 - discount)) AS Total_Revenue
FROM
    order_items; 


-- Q2. Total Number of Orders
select count(distinct order_id) as Total_orders
from orders;

-- 3. Total Number of Customres
SELECT 
    COUNT(*) AS Total_Customers
FROM
    customers;
    
-- 4. Revenue by Products Category
SELECT 
    c.category_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS category_revenue
FROM
    order_items oi
        JOIN
    products p ON oi.product_id = p.product_id
        JOIN
    categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY category_revenue DESC;

-- Q5.TOP 10 BEST-SELLING PRODUCTS (BY REVENUE)
SELECT 
    p.product_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS product_revenue
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY product_revenue DESC
LIMIT 10;

-- Q6. STORE-WISE REVENUE

SELECT 
    s.store_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS store_revenue
FROM orders1 o
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN stores s 
    ON o.store_id = s.store_id
GROUP BY s.store_name
ORDER BY store_revenue DESC;
select * from orders;
-- Q7.SALES BY STATE
SELECT 
    s.state,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS state_revenue
FROM orders o
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN stores s 
    ON o.store_id = s.store_id
GROUP BY s.state
ORDER BY state_revenue DESC;


-- Q8.TOP 10 CUSTOMERS BY SPENDING
SELECT 
    c.name AS customer_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spent
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 10;

-- Q9. MONTHLY SALES TREND (USING CTE – SIMPLE)
WITH monthly_sales AS (
    SELECT 
        MONTH(o.order_date) AS order_month,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
    FROM orders o
    JOIN order_items oi 
        ON o.order_id = oi.order_id
    GROUP BY MONTH(o.order_date)
)
SELECT *
FROM monthly_sales
ORDER BY order_month;

-- Q 10.LOW STOCK PRODUCTS (INVENTORY CHECK)
SELECT 
    p.product_name,
    s.store_id,
    st.quantity AS stock_quantity
FROM stocks st
JOIN products p 
    ON st.product_id = p.product_id
JOIN stores s 
    ON st.store_id = s.store_id
WHERE st.quantity < 10
ORDER BY st.quantity;

##################################################################################################################################################

