-- Day 23 Project Setup + Data wx==Exploration

CREATE TABLE orders (
order_id TEXT,
customer_id TEXT,
order_status TEXT,
order_purchase_timestamp TIMESTAMP,
order_approved_at TIMESTAMP,
order_delivered_carrier_date TIMESTAMP,
order_delivered_customer_date TIMESTAMP,
order_estimated_delivery_date TIMESTAMP
);

select *
from orders
limit 10;

CREATE TABLE customers (
customer_id TEXT,
customer_unique_id TEXT,
customer_zip_code_prefix TEXT,
customer_city TEXT,
customer_state TEXT
);


CREATE TABLE order_items (
order_id TEXT,
order_item_id INTEGER,
product_id TEXT,
seller_id TEXT,
shipping_limit_date TIMESTAMP,
price NUMERIC,
freight_value NUMERIC
);



CREATE TABLE order_payments (
order_id TEXT,
payment_sequential INTEGER,
payment_type TEXT,
payment_installments INTEGER,
payment_value NUMERIC
);


SELECT * FROM customers LIMIT 5;
SELECT * FROM order_items LIMIT 5;
SELECT * FROM order_payments LIMIT 5;
SELECT * FROM orders LIMIT 5;


SELECT
o.order_id,
c.customer_city,
c.customer_state,
oi.price,
oi.freight_value,
p.payment_type,
p.payment_value
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN order_payments p
ON o.order_id = p.order_id
LIMIT 20;



-- Day 24 Data Cleaning + Validation
-- Step 1: Check Tables Sizes  

SELECT count(*) FROM customers ;
SELECT count(*) FROM order_items ;
SELECT count(*) FROM order_payments ;
SELECT count(*) FROM orders ;

--Step 2: Check NULL values
-- Compare total rows vs non-null rows
SELECT
count(*) as total_rows,
count(order_id) as order_id_not_null,
count(order_delivered_customer_date) as delivered_date_not_null
FROM orders ;

select *
from orders
where order_delivered_customer_date is null 
limit 20;

-- Possible reasons for null:
--1. cancelled orders, 2. shipped late, 3. still processing

-- Step 3: Check Duplicates

select 
order_id,
count(*)
from orders
group by order_id
having count(*) > 1;

-- return 0 rows. There is no duplicates.

-- Step 4: Validate Order Status

select 
order_status,
count(*) as total_orders
from orders
group by order_status
order by total_orders desc
;

-- 1	delivered	96478
-- 2	shipped	    1107
-- 3	canceled	625
-- 4	unavailable	609
-- 5	invoiced	314
-- 6	processing	301
-- 7	created	    5
-- 8	approved	2

-- Step 5: Validate Payment Types
select 
payment_type,
count(*) as total_payments
from order_payments
group by payment_type
order by total_payments desc
;
-- 1	credit_card	76795
-- 2	boleto	19784
-- 3	voucher	5775
-- 4	debit_card	1529
-- 5	not_defined	3
-- 1. Most custpmers use credit card, 2. 

-- Step 6: Basic Revenue Validate

select 
round(sum(payment_value),2) as total_revenue,
round(avg(payment_value),2) as avg_paymnet
from order_payments
;

-- Step 7: Create FIRST Cleaned CTE 
with clean_orders as (
    select 
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_delivered_customer_date
    from orders
    where order_status != 'canceled'
)
select *
from clean_orders
limit 20;

--Step 8: Build First Clean JOIN Dataset
with clean_orders as (
    select *
    from orders
    where order_status != 'canceled'
)

SELECT
o.order_id,
c.customer_state,
oi.price,
p.payment_value
FROM clean_orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN order_payments p
    ON o.order_id = p.order_id
LIMIT 50;

-- Basic Business Insights
-- 1. Most orders are successfully delivered.
-- 2. Credit card is the dominant payment methed.
-- 3. Some orders have missing delivery dates.
-- 4. Canceled orders should be excluded from revenue analysis.