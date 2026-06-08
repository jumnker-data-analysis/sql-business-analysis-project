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



-- Day 25: Revenue KPI Analysis

-- step 1: Total Revenue:

select 
round(sum(payment_value),2) as total_revenue
from order_payments
;
-- Total Business Revenue 
-- step 2: Average Order Value:

select 
round(avg(payment_value),2) as avg_order_value
from order_payments
;
-- Average customer spending per order 

-- step 3: Revenue by Payment Type:

select 
payment_type,
round(sum(payment_value),2) as total_revenue,
count(*)
from order_payments
group by payment_type
order by total_revenue desc
;
-- Credit card dominate revenue

-- step 4: Monthly Revenue Trend:

select
extract(month from o.order_purchase_timestamp) as order_month,
round(sum(p.payment_value),2) as monthly_revenue
from orders o 
join order_payments p
    on o.order_id = p.order_id
group by extract(month from o.order_purchase_timestamp)
order by order_month asc
;
--

-- step 5: Revenue by State:

select
c.customer_state,
round(sum(p.payment_value),2) as total_revenue
from customers c
join orders o 
    on c.customer_id = o.customer_id
join order_payments p
    on o.order_id = p.order_id
group by c.customer_state
order by total_revenue desc
limit 10
;
-- State SP generated the most revenue

-- step 6: Top Customers:

select
c.customer_unique_id,
round(sum(p.payment_value),2) as total_spending
from customers c
join orders o 
    on c.customer_id = o.customer_id
join order_payments p
    on o.order_id = p.order_id
group by c.customer_unique_id
order by total_spending desc
limit 10
;
-- The Top 10 Contribution customers

-- step 7: Top Sellers

select
seller_id,
round(sum(price),2) as seller_revenue
from order_items
group by seller_id
order by seller_revenue desc
limit 10
;
-- The Top 10 Performance Sellers

-- step 8: Revenue + Freight Analysis

select 
round(sum(price),2) as product_revenue,
round(sum(freight_value),2) as total_shipping_cost
from order_items
;

-- step 9: First KPI CTE

with monthly_kpi as (
    select
        extract(month from o.order_purchase_timestamp) as order_month,
        round(sum(p.payment_value),2) as monthly_revenue,
        count(distinct o.order_id) as total_orders
    from orders o 
    join order_payments p
        on o.order_id = p.order_id
    group by order_month
)
select *
from monthly_kpi
order by order_month
;

-- step 10: Business Insights:

-- Credit cards generate most business revenue.
-- Revenue varies significantly by month.
-- Some states contribute much higher sales volumn.
-- High-Value customers contribute disproportionately to revenue.
-- Freight cost is a meaningful operational expense.

----------------------------------------------------
-- Day 26 Customer Analytics

-- Step 1: Top Customers by Spending

select 
    c.customer_unique_id,
    round(sum(p.payment_value))as total_spending
from customers c 
join orders o 
    on c.customer_id = o.customer_id
join order_payments p
    on o.order_id = p.order_id
group by c.customer_unique_id
order by total_spending desc
limit 10
;
----------------------------------------------------
-- Step 2: Repeat Customers

select 
    c.customer_unique_id,
    count(distinct o.order_id) as total_orders
from customers c 
join orders o 
    on c.customer_id = o.customer_id
group by c.customer_unique_id
having count(distinct o.order_id) > 1
order by total_orders desc
limit 20
;
----------------------------------------------------
-- Step 3: Customers Spending segmentayion
with customer_spending as (
    select 
    c.customer_unique_id,
    round(sum(p.payment_value),2) as total_spending
    from customers c 
    join orders o 
        on c.customer_id = o.customer_id
    join order_payments p
        on o.order_id = p.order_id
    group by c.customer_unique_id
)
select
    customer_unique_id,
    total_spending,
    case
        when total_spending >= 1000 then 'High Value'
        when total_spending >= 300 then 'Medium Value'
        else 'Low Value' 
    end as customer_segment
from customer_spending
order by total_spending desc
limit 20
;


----------------------------------------------------
-- Step 4: Count Customers by Segment

with customer_spending as (
    select 
    c.customer_unique_id,
    round(sum(p.payment_value),2) as total_spending
    from customers c 
    join orders o 
        on c.customer_id = o.customer_id
    join order_payments p
        on o.order_id = p.order_id
    group by c.customer_unique_id
),
customer_segment as (
    select
        customer_unique_id,
        total_spending,
        case
            when total_spending >= 1000 then 'High Value'
            when total_spending >= 300 then 'Medium Value'
            else 'Low Value' 
        end as segment
    from customer_spending
)
select
segment,
count(*) as total_customers,
round(sum(total_spending),2) as segment_revenue,
round(avg(total_spending),2) as avg_segment_revenue
from customer_segment
group by segment
order by segment_revenue desc
;

----------------------------------------------------
-- Step 5: Rank Customers

with customer_spending as (
    select 
    c.customer_unique_id,
    round(sum(p.payment_value),2) as total_spending
    from customers c 
    join orders o 
        on c.customer_id = o.customer_id
    join order_payments p
        on o.order_id = p.order_id
    group by c.customer_unique_id
)
select
    customer_unique_id,
    total_spending,
    rank() over(order by total_spending desc) as spending_rank
from customer_spending
limit 20
;

----------------------------------------------------
-- Step 6: Customers by State

select 
    c.customer_state,
    count(distinct c.customer_unique_id) as total_customers,
    round(sum(p.payment_value),2) as total_revenue
from customers c 
join orders o 
    on c.customer_id = o.customer_id
join order_payments p
    on o.order_id = p.order_id
group by  c.customer_state
order by total_revenue desc
;

----------------------------------------------------
-- Step 7: Business Insights
-- 1. Most ecommerce revenue was generated by a very large
-- group of low-value customers.
-- 2. High-value customers represented a small percentage of
-- the customer base but generated significantly higher average
-- spending per customer.
-- 3. The business currently appears to follow a high-volume
-- ecommerce model with broad customer participation.
-- 4. Customer segmentation analysis suggests strong opportunities
-- for loyalty and retention programs targeting high-value customers.
-- 5. Medium-value customers may represent the best opportunity
-- for future upselling and customer growth strategies.
-- 6. Revenue performance varied across customer segments, indicating
-- difference in purchasing behavior and spending power.
-- 7. State-level analysis showed that customer activity and
-- revenue contribution were uneven across regions.
-- 8. Credit card   

----------------------------------------------------
-- Day 27 Delivery Performance Analysis
----------------------------------------------------
-- Step 1: Check delivery-related columns

select
    order_id,
    order_status,
    order_purchase_timestamp,
    order_delivered_customer_date,
    order_estimated_delivery_date
from orders
limit 20
;

----------------------------------------------------
-- Step 2:Count delivery status 

select
    order_status,
    count(*) as total_orders
from orders
group by order_status
order by total_orders
;
-- Most orders are delivered, but cancelled/unavailable orders should be
-- excluded from delivery performance analysis

----------------------------------------------------
-- Step 3: Calculate delivery day

select 
    order_id,
    order_status,
    order_purchase_timestamp,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    round(
        extract(epoch from 
        (order_delivered_customer_date-order_purchase_timestamp))/86400,
        2
    ) as delivery_days
from orders
where order_delivered_customer_date is not null
limit 20
;

----------------------------------------------------
-- Step 4: Average delivery days

select
    round(
        avg(extract(epoch from 
        (order_delivered_customer_date-order_purchase_timestamp))/86400),
        2
    ) as avg_delivery_day
from orders
where order_status = 'delivered'
and order_delivered_customer_date is not null
;
-- Average delivery day helps measure logistics efficiency

----------------------------------------------------
-- Step 5: On-time vs late delivery

select 
    case
        when order_delivered_customer_date <= order_estimated_delivery_date
        then 'On-time'
        else 'Late'
    end as delivery_status,
    count(*) as total_orders
from orders
where order_status = 'delivered'
and order_delivered_customer_date is not null
and order_estimated_delivery_date is not null
group by delivery_status
order by total_orders desc
;


----------------------------------------------------
-- Step 6: Late delivery rate

select
    count(*) as total_delivered_orders,
    count(*) filter (
    where order_delivered_customer_date > order_estimated_delivery_date
    ) as late_orders,
    round(
    count(*) filter (
    where order_delivered_customer_date > order_estimated_delivery_date
    ) * 100.0 / count(*),
    2
    ) as late_delivery_rate
from orders
where order_status = 'delivered'
and order_delivered_customer_date is not null
and order_estimated_delivery_date is not null
;
-- Late delivery rate shows how often the business fails to meet
-- customer expectations. 

----------------------------------------------------
-- Step 7: Delivery perfomance by customer state

select
    c.customer_state,
    count(*) as delivered_orders,
    round(
        avg(extract(epoch from 
        (o.order_delivered_customer_date-o.order_purchase_timestamp))/86400),
        2
    ) as avg_delivery_day,
    round(
        count(*) filter (
            where o.order_delivered_customer_date > o.order_estimated_delivery_date
        ) * 100.0 / count(*),
        2
    ) as late_delivery_rate
from orders o 
join customers c 
    on o.customer_id = c.customer_id
where o.order_status = 'delivered'
and o.order_delivered_customer_date is not null
and o.order_estimated_delivery_date is not null
group by c.customer_state
order by late_delivery_rate desc
;


----------------------------------------------------
-- Step 8: Rank states by delivery speed

with state_delivery as(
    select
        c.customer_state,
        count(*) as delivered_orders,
        round(
            avg(extract(epoch from 
            (o.order_delivered_customer_date-o.order_purchase_timestamp))/86400),
            2
        ) as avg_delivery_day
    from orders o 
    join customers c 
        on o.customer_id = c.customer_id
    where o.order_status = 'delivered'
    and o.order_delivered_customer_date is not null
    group by c.customer_state
)
select
    customer_state,
    delivered_orders,
    avg_delivery_day,
    rank() over(order by avg_delivery_day asc) as delivery_speed_rank
from state_delivery
order by delivery_speed_rank
;

----------------------------------------------------
-- Step 9: Monthly delivery performance

select
    extract(month from order_purchase_timestamp) as order_month,
    count(*) as delivered_orders,
    round(
        avg(extract(epoch from 
        (order_delivered_customer_date - order_purchase_timestamp))/86400),
        2
    ) as avg_delivery_day,
    round(
        count(*) filter (
            where order_delivered_customer_date > order_estimated_delivery_date
        ) * 100.0 / count(*),
        2
    ) as late_delivery_rate
from orders
where order_status = 'delivered'
and order_delivered_customer_date is not null
and order_estimated_delivery_date is not null
group by extract(month from order_purchase_timestamp)
order by order_month
;

----------------------------------------------------

-- Day 27 Business Insights:
-- Delivery performance is a key operational KPI for ecommerce businesses.
-- Average delivery days help evaluate logistics efficiency.
-- Late delivery rate shows how often customer delivery expectations are not met.
-- State-level delivery analysis can reveal geographic logistics challenges.
-- Monthly delivery trends help identify whether logistics performance
-- improves or worsens over time.
-- Faster delivery regions may indicate stronger logistics coverage, while
-- slower regions may need operational improvement.

----------------------------------------------------


-- Day 28 
----------------------------------------------------
-- Step 1: Monthly Revenue Base table

with monthly_revenue_tbl as (
    select
        extract(month from o.order_purchase_timestamp) as order_month,
        round(sum(p.payment_value),2) as monthly_revenue,
        count(distinct o.order_id) as total_orders
    from orders o 
    join order_payments p
        on o.order_id = p.order_id
    group by extract(month from o.order_purchase_timestamp)
)
select *
from monthly_revenue_tbl
order by order_month
;

----------------------------------------------------
-- Step 2: Running revenue

with monthly_revenue_tbl as (
    select
        extract(month from o.order_purchase_timestamp) as order_month,
        round(sum(p.payment_value),2) as monthly_revenue
    from orders o 
    join order_payments p
        on o.order_id = p.order_id
    group by extract(month from o.order_purchase_timestamp)
)
select
    order_month,
    monthly_revenue,
    sum(monthly_revenue) over(order by order_month
    rows between unbounded preceding and current row)
    as running_revenue
from monthly_revenue_tbl
order by order_month
;

----------------------------------------------------
-- Step 3: Previous Month Revenue using LAG() 

with monthly_revenue_tbl as (
    select
        extract(month from o.order_purchase_timestamp) as order_month,
        round(sum(p.payment_value),2) as monthly_revenue
    from orders o 
    join order_payments p
        on o.order_id = p.order_id
    group by extract(month from o.order_purchase_timestamp)
)
select
    order_month,
    monthly_revenue,
    lag(monthly_revenue) over(order by order_month) as previous_month_revenue
from monthly_revenue_tbl
order by order_month
;


----------------------------------------------------
-- Step 4: Month-over-Month Revenue Growth 

with monthly_revenue_tbl as (
    select
        extract(month from o.order_purchase_timestamp) as order_month,
        round(sum(p.payment_value),2) as monthly_revenue
    from orders o 
    join order_payments p
        on o.order_id = p.order_id
    group by extract(month from o.order_purchase_timestamp)
),
revenue_growth as(
    select
        order_month,
        monthly_revenue,
        lag(monthly_revenue) over(order by order_month) as previous_month_revenue
    from monthly_revenue_tbl
    order by order_month
)
select
    order_month,
    monthly_revenue,
    previous_month_revenue,
    round(
        ((monthly_revenue - previous_month_revenue)
        / nullif(previous_month_revenue,0)) * 100 , 2
    ) as mom_growth_percent
from revenue_growth
order by order_month
;

----------------------------------------------------
-- Step 5: Next Month Revenue using LEAD() 

with monthly_revenue_tbl as (
    select
        extract(month from o.order_purchase_timestamp) as order_month,
        round(sum(p.payment_value),2) as monthly_revenue
    from orders o 
    join order_payments p
        on o.order_id = p.order_id
    group by extract(month from o.order_purchase_timestamp)
)
select
    order_month,
    monthly_revenue,
    lead(monthly_revenue) over(order by order_month) as next_month_revenue
from monthly_revenue_tbl
order by order_month
;


----------------------------------------------------
-- Step 6: Rolling 3-month average revenue

with monthly_revenue_tbl as (
    select
        extract(month from o.order_purchase_timestamp) as order_month,
        round(sum(p.payment_value),2) as monthly_revenue
    from orders o 
    join order_payments p
        on o.order_id = p.order_id
    group by extract(month from o.order_purchase_timestamp)
)
select
    order_month,
    monthly_revenue,
    round(
        avg(monthly_revenue) over(order by order_month
        rows between 2 preceding and current row)
    )
        as rolling_3_month_avg
from monthly_revenue_tbl
order by order_month
;

----------------------------------------------------
-- Step 7: Best growth month

with monthly_revenue_tbl as (
    select
        extract(month from o.order_purchase_timestamp) as order_month,
        round(sum(p.payment_value),2) as monthly_revenue
    from orders o 
    join order_payments p
        on o.order_id = p.order_id
    group by extract(month from o.order_purchase_timestamp)
),
growth_table as(
    select
        order_month,
        monthly_revenue,
        lag(monthly_revenue) over(order by order_month) as previous_month_revenue
    from monthly_revenue_tbl
),
final_growth as(
    select
        order_month,
        monthly_revenue,
        previous_month_revenue,
        round(
            ((monthly_revenue - previous_month_revenue)
            / nullif(previous_month_revenue,0)) * 100 , 2
        ) as mom_growth_percent
    from growth_table
)
select *
from final_growth
where mom_growth_percent is not null
order by mom_growth_percent desc
limit 1
;

----------------------------------------------------
-- Step 8: Worst growth month

with monthly_revenue_tbl as (
    select
        extract(month from o.order_purchase_timestamp) as order_month,
        round(sum(p.payment_value),2) as monthly_revenue
    from orders o 
    join order_payments p
        on o.order_id = p.order_id
    group by extract(month from o.order_purchase_timestamp)
),
growth_table as(
    select
        order_month,
        monthly_revenue,
        lag(monthly_revenue) over(order by order_month) as previous_month_revenue
    from monthly_revenue_tbl
),
final_growth as(
    select
        order_month,
        monthly_revenue,
        previous_month_revenue,
        round(
            ((monthly_revenue - previous_month_revenue)
            / nullif(previous_month_revenue,0)) * 100 , 2
        ) as mom_growth_percent
    from growth_table
)
select *
from final_growth
where mom_growth_percent is not null
order by mom_growth_percent asc
limit 1
;

----------------------------------------------------
-- Step 9: Dashboard-ready trend table

with monthly_revenue_tbl as (
    select
        extract(month from o.order_purchase_timestamp) as order_month,
        round(sum(p.payment_value),2) as monthly_revenue,
        count(distinct o.order_id) as total_orders
    from orders o 
    join order_payments p
        on o.order_id = p.order_id
    group by extract(month from o.order_purchase_timestamp)
),
trend_table as(
    select
        order_month,
        monthly_revenue,
        total_orders,
        sum(monthly_revenue) over(order by order_month) as running_revenue,
        lag(monthly_revenue) over(order by order_month) as previous_month_revenue,
        lead(monthly_revenue) over(order by order_month) as next_month_revenue,
        round(
        avg(monthly_revenue) over(order by order_month
        rows between 2 preceding and current row), 2
        ) as rolling_3_month_avg
    from monthly_revenue_tbl
)
select
    order_month,
    monthly_revenue,
    total_orders,
    running_revenue,
    previous_month_revenue,
    next_month_revenue,
    round(
        ((monthly_revenue - previous_month_revenue)
        / nullif(previous_month_revenue,0)) * 100 , 2
    ) as mom_growth_percent,
    rolling_3_month_avg
from trend_table
order by order_month
;

----------------------------------------------------
-- Day 28 Business Insights:
-- 1. Monthly revenue trend analysis helps evaluate
-- business momentum over time.
-- 2. Running revenue shows cumulative business growth
-- across months.
-- 3. Month-over-month growth identifies strong and
-- weak revenue periods.
-- 4. Rolling averages help smooth short-term fluctuations
-- and reveal longer-term patterns.
-- 5. LEAD and LAG allow the business to compare past,
-- current, and future periods in one query.
-- 6. These trend metrics can support dashboard
-- reporting and executive decision-making. 


----------------------------------------------------
-- Day 29 
----------------------------------------------------
-- Step 1: Pick 3 areas from previous analysis
-- 1. Revenue trend
-- 2. Customer segmentation
-- 3. Delivery performance
----------------------------------------------------
-- Step 2: Insights Summary
-- Insight 1: Revenue Trend
-- Monthly revenue shows fluctuation across the analysis period.
-- This suggests the business should monitor seasonal demand and growth consistency.

-- Insight 2: Customer Segmentation
-- Low-value customers generated the highest total revenue because of large customer volume.
-- High-value customers had much higher average spending and should be targeted for retention.

-- Insight 3: Delivery Performance
-- Delivery performance was generally stable, with most orders delivered earlier than expected.
-- However, late delivery rate should still be monitored because it can affect customer satisfaction.

-- Insight 4: Business Opportunity
-- Medium-value customers may represent a strong upselling opportunity.
-- The business could use targeted campaigns to move medium-value customers into high-value segments.

-- Insight 5: Dashboard Recommendation
-- The final dashboard should include revenue KPIs, customer segments, delivery KPIs, and trend metrics.


-- Step 3: Final insight table

-- Monthly Revenue KPI
SELECT
date_trunc('month', o.order_purchase_timestamp)::date AS order_month,
ROUND(SUM(p.payment_value), 2) AS monthly_revenue,
COUNT(DISTINCT o.order_id) AS total_orders,
ROUND(SUM(p.payment_value) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM orders o
JOIN order_payments p
ON o.order_id = p.order_id
GROUP BY date_trunc('month', o.order_purchase_timestamp)::date
ORDER BY order_month;

-- Customer segment KPI
WITH customer_spending AS (
SELECT
c.customer_unique_id,
ROUND(SUM(p.payment_value), 2) AS total_spending
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_payments p
ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
),

customer_segment AS (
SELECT
customer_unique_id,
total_spending,
CASE
WHEN total_spending >= 1000 THEN 'High Value'
WHEN total_spending >= 300 THEN 'Medium Value'
ELSE 'Low Value'
END AS segment
FROM customer_spending
)

SELECT
segment,
COUNT(*) AS total_customers,
ROUND(SUM(total_spending), 2) AS segment_revenue,
ROUND(AVG(total_spending), 2) AS avg_segment_revenue
FROM customer_segment
GROUP BY segment
ORDER BY segment_revenue DESC;

-- Delivery performance KPI
SELECT
date_trunc('month', order_purchase_timestamp)::date AS order_month,
COUNT(*) AS delivered_orders,
ROUND(
AVG(EXTRACT(EPOCH FROM (order_delivered_customer_date - order_purchase_timestamp)) / 86400),
2
) AS avg_delivery_days,
ROUND(
COUNT(*) FILTER (
WHERE order_delivered_customer_date > order_estimated_delivery_date
) * 100.0 / COUNT(*),
2
) AS late_delivery_rate
FROM orders
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NOT NULL
AND order_estimated_delivery_date IS NOT NULL
GROUP BY date_trunc('month', order_purchase_timestamp)::date
ORDER BY order_month;

-- State revenue KPI
SELECT
c.customer_state,
COUNT(DISTINCT o.order_id) AS total_orders,
ROUND(SUM(p.payment_value), 2) AS total_revenue,
ROUND(SUM(p.payment_value) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_payments p
ON o.order_id = p.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;

-- Dashboard summary KPI
SELECT
ROUND(SUM(p.payment_value), 2) AS total_revenue,
COUNT(DISTINCT o.order_id) AS total_orders,
COUNT(DISTINCT c.customer_unique_id) AS total_customers,
ROUND(SUM(p.payment_value) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN order_payments p
ON o.order_id = p.order_id
;

-----------------------------------------
select
'Revenue Trend' as insight_area,
'Monthly revenue analysis shows business performance changes over time.' as business_insight

union all

SELECT
'Customer Segmentation',
'Low-value customers drive total revenue volume, while high-value customers show strong retention potential.'

UNION ALL

SELECT
'Delivery Performance',
'Stable delivery performance supports customer experience, but late deliveries remain an operational risk.'

UNION ALL

SELECT
'Business Recommendation',
'Focus on retaining high-value customers and upselling medium-value customers.'

UNION ALL

select
'Dashboard Recommendation',
'The final dashboard should include revenue KPIs, customer segments, delivery KPIs, and trend metrics.'
;


