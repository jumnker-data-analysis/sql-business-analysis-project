-- Day 15 question 
-- Rewrite one old query from day 9, day 10 or day 11
-- Rank employees by total completed revenue.
-- old query 
select 
o.employee_id,
e.first_name||' '||e.last_name as full_name,
sum(o.order_amount) as total_revenue,
rank() over(order by sum(o.order_amount) desc) as rank
from orders o
left join employees e
on e.employee_id = o.employee_id
where o.order_status = 'completed'
group by o.employee_id, e.first_name||' '||e.last_name
;


-- new query with CTE
-- it makes the logic more readable, it create CTE 
-- containstotal completed revenue then we decide 
-- what insight to focus

with CTE_emp_total_com_rev as
(
select 
o.employee_id,
e.first_name||' '||e.last_name as full_name,
sum(o.order_amount) as total_revenue
from orders o
left join employees e
on e.employee_id = o.employee_id
where o.order_status = 'completed'
group by o.employee_id, e.first_name||' '||e.last_name
)
select 
employee_id,
full_name,
total_revenue,
rank() over(order by total_revenue desc) as rank
from CTE_emp_total_com_rev
;

-- Day 15 Business insights 

-- 3. Create a CTE for employee revenue.
-- 4. Use the employee revenue CTE to rank employees.
-- Business insights:
-- Taylor, Lee and Walker generated the highest completed 
-- revenue among employees.


-- 5. Create a department revenue CTE.
-- 6. Use the department revenue CTE to find the top department.
-- Business insights:
-- Sales department generated the highest completed revenue  
-- across all departments.


-- 7. Create a customer spending CTE.
-- 8 Use the customer spending CTE to segment 
-- Business insights:
-- customers into Low / Medium / High.
-- High-spending cusotmers contributed disproportionately to 
-- total revenue.


-- 9. Create a CTE for monthly revenue.
-- 10. Use the monthly revenue CTE to calculate running total revenue.
-- Business insights:
-- Revenue trends increased significantly in January 


-- Day 16 — Advanced Ranking Analysis
-- Day 16 question 1  
-- Rank employees by completed revenue using RANK().

with CTE_emp_total_com_rev as
(
select 
o.employee_id,
e.first_name||' '||e.last_name as full_name,
sum(o.order_amount) as total_revenue
from orders o
left join employees e
on e.employee_id = o.employee_id
where o.order_status = 'completed'
group by o.employee_id, e.first_name||' '||e.last_name
)
select 
employee_id,
full_name,
total_revenue,
rank() over(order by total_revenue desc) as rnk
from CTE_emp_total_com_rev
;

-- Day 16 question 2 
-- Rank employees using DENSE_RANK().

with CTE_emp_total_com_rev as
(
select 
o.employee_id,
e.first_name||' '||e.last_name as full_name,
sum(o.order_amount) as total_revenue
from orders o
left join employees e
on e.employee_id = o.employee_id
where o.order_status = 'completed'
group by o.employee_id, e.first_name||' '||e.last_name
)
select 
employee_id,
full_name,
total_revenue,
dense_rank() over(order by total_revenue desc) as dense_rnk
from CTE_emp_total_com_rev
;

-- Day 16 question 3
-- Compare ROW_NUMBER() vs RANK().

with CTE_emp_total_com_rev as
(
select 
o.employee_id,
e.first_name||' '||e.last_name as full_name,
sum(o.order_amount) as total_revenue
from orders o
left join employees e
on e.employee_id = o.employee_id
where o.order_status = 'completed'
group by o.employee_id, e.first_name||' '||e.last_name
)
select 
employee_id,
full_name,
total_revenue,
rank() over(order by total_revenue desc) as rnk,
ROW_NUMBER() over(order by total_revenue desc) as dense_rnk
from CTE_emp_total_com_rev
;

-- the differnce between ROW_NUMBER() vs RANK() is that 
-- ROW_NUMBER() return the serial number for each rows of the   
-- column in order . RANK() return the serial number  when
-- same value occurs multiple times. RANK() return them
-- as the same number but ROW_NUMBER() return serial number of the 
-- posistion in order.


-- Day 16 question 4
-- Find top 5 customers by spending.

with CTE_completed_customer as 
(
    select
    distinct customer_name,
    sum(order_amount) 
    over(partition by customer_name) as customer_spending
    from orders
    where order_status = 'completed'
)
select *
from CTE_completed_customer
order by customer_spending desc
limit 5
;


-- Day 16 question 5
-- Rank departments by total revenue.

with CTE_completed_department as
(
    select
    distinct d.department_name,
    d.department_id,
    sum(o.order_amount) 
    over(partition by d.department_name) as department_revenue
    from orders o 
    join employees e
    on e.employee_id = o.employee_id
    join departments d
    on d.department_id = e.department_id
    where o.order_status = 'completed'
)
select
rank() over(order by department_revenue desc) as rnk,
department_name,
department_id,
department_revenue
from CTE_completed_department
order by department_revenue desc
;

-- Day 16 question 6
-- Find the lowest-performing employees.

with tem_tbl as
(
    select
    distinct 
    e.department_id,
    e.employee_id,
    e.first_name,
    e.last_name,    
    sum(o.order_amount) 
    over(partition by e.employee_id) as employee_revenue
    from orders o 
    join employees e
    on e.employee_id = o.employee_id
    where o.order_status = 'completed'
),

CTE_completed_employee as
(
    select *
    from tem_tbl
    union
    select 
    department_id,
    employee_id,
    first_name,
    last_name,
    0 as employee_revenue
    from employees 
    where employee_id not in 
    (
        select employee_id
        from tem_tbl
    )
)
select
rank() over(order by employee_revenue desc) as rnk,
department_id,
employee_id,
employee_revenue,
last_name||' '||first_name as full_name
from CTE_completed_employee
order by employee_revenue
;

-- Day 16 question 7
-- Rank employees within each department.

with tem_tbl as 
(
    select
    distinct 
    d.department_id,
    e.employee_id,
    e.first_name||' '||e.last_name as full_name,
    sum(o.order_amount) 
    over(partition by e.employee_id) as employee_revenue
    from orders o 
    join employees e
    on e.employee_id = o.employee_id
    join departments d
    on d.department_id = e.department_id
    where o.order_status = 'completed'
),
CTE_completed_employee as
(
    select *
    from tem_tbl
    union
    select 
    department_id,
    employee_id,
    first_name||' '||last_name as full_name,
    0 as employee_revenue
    from employees 
    where employee_id not in 
    (
        select employee_id
        from tem_tbl
    )
)
select 
*,
rank() over(partition by department_id order by employee_revenue desc) as rnk,
case
    when department_id ='1' then 'Sales'
    when department_id ='2' then 'Operations'
    when department_id ='3' then 'Finance'
    when department_id ='4' then 'Analytics'
    else 'Human Resources'
    end as department_name
from CTE_completed_employee
;


-- Day 16 question 8
-- Find top monthly revenue by employee.

with employee_monthly_revenue as
(
    select
    extract(month from o.order_timestamp) as order_month,
    e.department_id,
    e.employee_id,
    e.first_name||' '||e.last_name as full_name,
    sum(o.order_amount) monthly_revenue
    from orders o
    inner join employees e
    on e.employee_id = o.employee_id
    where o.order_status = 'completed'
    group by 
        extract(month from o.order_timestamp),
        e.department_id,
        e.employee_id,
        full_name
),

ranked_employee_month as
(
    select 
    *,
    rank() over(partition by order_month order by monthly_revenue desc) as rnk
    from employee_monthly_revenue
)
select *
from ranked_employee_month
where rnk = '1'
;



-- Day 16 question 9
-- Build a leaderboard query with full names.

with employee_monthly_revenue as
(
    select
    extract(month from o.order_timestamp) as order_month,
    e.department_id,
    e.employee_id,
    e.first_name||' '||e.last_name as full_name,
    sum(o.order_amount) monthly_revenue
    from orders o
    inner join employees e
    on e.employee_id = o.employee_id
    where o.order_status = 'completed'
    group by 
        extract(month from o.order_timestamp),
        e.department_id,
        e.employee_id,
        full_name
),

ranked_employee_month as
(
    select 
    *,
    rank() over(partition by order_month order by monthly_revenue desc) as rnk
    from employee_monthly_revenue
)
select 
    order_month,    
    full_name,
    monthly_revenue,
    rnk,
    case
    when department_id ='1' then 'Sales'
    when department_id ='2' then 'Operations'
    when department_id ='3' then 'Finance'
    when department_id ='4' then 'Analytics'
    else 'Human Resources'
    end as department_name
from ranked_employee_month
where rnk in (1, 2, 3)
order by order_month, rnk
;


-- Day 16 question 10
-- Add business insights comments.

---

-- Day 17 — LEAD & LAG Trend Analysis
-- Day 17 question 1
-- Calculate monthly revenue.

select
extract(month from o.order_timestamp) as order_month,
sum(o.order_amount) monthly_revenue
from orders o
join employees e
on e.employee_id = o.employee_id
where o.order_status = 'completed'
group by extract(month from o.order_timestamp)
order by order_month
;

-- Day 17 question 2
-- Compare current month vs previous month using LAG().

select 
order_month,
monthly_revenue,
lag(monthly_revenue) over(order by order_month)
from (
    select
    extract(month from o.order_timestamp) as order_month,
    sum(o.order_amount) monthly_revenue
    from orders o
    join employees e
    on e.employee_id = o.employee_id
    where o.order_status = 'completed'
    group by extract(month from o.order_timestamp)
    order by order_month
) as temp_com_mon
;

-- Day 17 question 3
-- Compare current month vs next month using LEAD().

select 
order_month,
monthly_revenue,
lead(monthly_revenue) over(order by order_month)
from (
    select
    extract(month from o.order_timestamp) as order_month,
    sum(o.order_amount) monthly_revenue
    from orders o
    join employees e
    on e.employee_id = o.employee_id
    where o.order_status = 'completed'
    group by extract(month from o.order_timestamp)
    order by order_month
) as temp_com_mon
;

-- Day 17 question 4
-- Find revenue growth difference month-to-month.

select 
order_month,
monthly_revenue,
lag(monthly_revenue) 
over(order by order_month) as pre_monthly_revenue,
(monthly_revenue-lag(monthly_revenue) 
over(order by order_month)) as MoM_growth
from (
    select
    extract(month from o.order_timestamp) as order_month,
    sum(o.order_amount) monthly_revenue
    from orders o
    join employees e
    on e.employee_id = o.employee_id
    where o.order_status = 'completed'
    group by extract(month from o.order_timestamp)
    order by order_month
) as temp_com_mon
;

-- Day 17 question 5
-- Find largest revenue increase.

select
*
from(
    select 
    order_month,
    monthly_revenue,
    lag(monthly_revenue) 
    over(order by order_month) as pre_monthly_revenue,
    (monthly_revenue-lag(monthly_revenue) 
    over(order by order_month)) as MoM_growth
    from 
    (
        select
        extract(month from o.order_timestamp) as order_month,
        sum(o.order_amount) monthly_revenue
        from orders o
        join employees e
        on e.employee_id = o.employee_id
        where o.order_status = 'completed'
        group by extract(month from o.order_timestamp)
        order by order_month
    ) as temp_com_mon
) as temp_com_mon_growth
where mom_growth is not null
order by mom_growth desc
limit 1
;

-- Day 17 question 6
-- Find largest revenue decrease.

select
*
from(
    select 
    order_month,
    monthly_revenue,
    lag(monthly_revenue) 
    over(order by order_month) as pre_monthly_revenue,
    (monthly_revenue-lag(monthly_revenue) 
    over(order by order_month)) as MoM_growth
    from 
    (
        select
        extract(month from o.order_timestamp) as order_month,
        sum(o.order_amount) monthly_revenue
        from orders o
        join employees e
        on e.employee_id = o.employee_id
        where o.order_status = 'completed'
        group by extract(month from o.order_timestamp)
        order by order_month
    ) as temp_com_mon
) as temp_com_mon_growth
where mom_growth is not null
order by mom_growth asc
limit 1
;

-- Day 17 question 7
-- Compare customer spending trends over time.

select
customer_name,
order_month,
monthly_spending,
lag(monthly_spending) 
over(partition by customer_name order by order_month) 
as previous_month_spending,
monthly_spending - lag(monthly_spending) 
over(partition by customer_name order by order_month) 
as mom_customer_growth
from (
    select
    customer_name,
    extract(month from order_timestamp) as order_month,
    sum(order_amount) as monthly_spending
    from orders
    where order_status = 'completed'
    group by customer_name, extract(month from order_timestamp)
) as customer_monthly
;

-- Day 17 question 8
-- Compare department monthly performance.

select 
department_id,
order_month,
monthly_revenue,
lag(monthly_revenue) 
over(partition by department_id order by order_month) 
as pre_monthly_revenue,
(monthly_revenue-lag(monthly_revenue) 
over(partition by department_id order by order_month)) as MoM_growth
from (
    select
    department_id,
    extract(month from o.order_timestamp) as order_month,
    sum(o.order_amount) monthly_revenue
    from orders o
    join employees e
    on e.employee_id = o.employee_id
    where o.order_status = 'completed'
    group by 
    extract(month from o.order_timestamp),
    department_id
    order by department_id, order_month
) as temp_com_mon
order by department_id, order_month
;

-- Day 17 question 9
-- Create revenue momentum insights.

-- Business insight:
-- Monthly completed revenue shows unstable momentum.
-- Revenue decreased sharply from month 1 to month 2,
-- recovered slightly in month 3,
-- then dropped strongly again in month 4.
-- This suggests the business should investigate why revenue declined
-- after the strongest month.
-- Month 1 generated the highest completed revenue.
-- Month 2 decreased by 1098.21 compared with Month 1.
-- Month 3 slightly recovered by 59.03 compared with Month 2.
-- Month 4 had the largest decrease, dropping by 2065.79.

-- Day 17 question 10
-- Add business explanations for trends.

-- Business explanation:
-- The strongest revenue period was Month 1.
-- The biggest negative movement happened in Month 4.
-- Possible reasons could include fewer completed orders,
-- lower average order value,
-- weaker customer demand,
-- or lower employee/department performance.
-- The business should compare order count, average order amount,
-- department revenue, and customer spending to explain the drop.


---

-- Day 18 — Running Totals + Rolling Analysis
-- Day 18 question 1
-- Create running total revenue.

select
order_timestamp,
order_amount,
sum(order_amount) over(order by order_timestamp)
from orders o
where order_status = 'completed'
;



-- Day 18 question 2
-- Create running customer spending.

select
order_timestamp,
order_amount,
customer_name,
sum(order_amount) 
over(partition by customer_name order by order_timestamp)
from orders
where order_status = 'completed'
;

-- Day 18 question 3
-- Create cumulative department revenue.

select
o.order_timestamp,
o.order_amount,
department_id,
sum(o.order_amount) 
over(partition by e.department_id order by o.order_timestamp)
from orders o
join employees e
on e.employee_id = o.employee_id
where o.order_status = 'completed'
;

-- Day 18 question 4
-- Build rolling monthly averages.

select
monthly_revenue,
avg(monthly_revenue) 
over(order by order_month 
rows between 1 preceding and current row) as rolling_mon_avg
from
(
    select
    extract(month from order_timestamp) as order_month,
    sum(order_amount) as monthly_revenue
    from orders o
    where order_status = 'completed'
    group by extract(month from order_timestamp)
)
;


-- Day 18 question 5
-- Compare cumulative revenue by department.

select
o.order_timestamp,
o.order_amount,
department_id,
sum(o.order_amount) 
over(partition by e.department_id order by o.order_timestamp)
from orders o
join employees e
on e.employee_id = o.employee_id
where o.order_status = 'completed'
;

-- Day 18 question 6
-- Track customer growth over time.

select
customer_name,
round(((lead_amount-order_amount)/order_amount)*100, 2) 
as cus_grw_percentage
from
(
    select
    order_timestamp,
    order_amount,
    customer_name,
    lead(order_amount)
    over(partition by customer_name order by order_timestamp) 
    as lead_amount
    from orders
    where order_status = 'completed'
)
where (lead_amount-order_amount)/order_amount  is not null
;

-- Day 18 question 7
-- Create running order counts.


-- Day 18 question 8
-- Compare cumulative completed vs pending orders.


-- Day 18 question 9
-- Combine running totals with ranking.


-- Day 18 question 10
-- Write business insights from rolling metrics.

---

## Day 19 — Employee Performance Mini Project
1. Create employee revenue CTE.
2. Rank employees by completed revenue.
3. Calculate cumulative employee revenue.
4. Compare employee monthly performance.
5. Identify consistent top performers.
6. Compare departments using employee data.
7. Create employee performance segmentation.
8. Find performance trends over time.
9. Add business recommendations.
10. Create final business summary comments.

---

## Day 20 — Customer Analytics Mini Project
1. Create customer spending CTE.
2. Segment customers into Low / Medium / High.
3. Rank top customers.
4. Calculate cumulative customer spending.
5. Analyze repeat customers.
6. Find highest monthly spending customers.
7. Compare customer growth trends.
8. Identify top revenue contributors.
9. Add customer behavior insights.
10. Create final business summary.

---

## Day 21 — Revenue Trend Dashboard Queries
1. Build monthly revenue table.
2. Build monthly order count table.
3. Compare revenue growth rates.
4. Create running revenue dashboard query.
5. Compare department monthly trends.
6. Rank monthly performance.
7. Find strongest growth periods.
8. Find weakest months.
9. Add executive-style business insights.
10. Organize queries into dashboard sections.

---

## Day 22 — Portfolio Optimization + Refactoring
1. Rewrite an old query using CTE.
2. Rewrite a subquery using window functions.
3. Improve alias naming consistency.
4. Improve query readability and spacing.
5. Reduce duplicated logic.
6. Add professional SQL comments.
7. Add business insights sections.
8. Create recruiter-friendly README notes.
9. Organize SQL files professionally.
10. Select best portfolio queries for GitHub.