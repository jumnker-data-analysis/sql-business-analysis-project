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

select
order_timestamp,
order_id,
order_status,
count(order_id) 
over(order by order_timestamp) as running_order_count
from orders
order by order_timestamp
;

-- Day 18 question 8
-- Compare cumulative completed vs pending orders.

select
order_timestamp,
order_status,
count(case when order_status = 'completed' then 1 end)
over(order by order_timestamp) as running_completed_orders,
count(case when order_status = 'pending' then 1 end)
over(order by order_timestamp) as running_pending_orders
from orders
where order_status in ('completed', 'pending')
order by order_timestamp
;

-- Day 18 question 9
-- Combine running totals with ranking.

select
order_timestamp,
order_id,
order_amount,
sum(order_amount) over(order by order_timestamp) as running_revenue,
rank() over(order by order_amount desc) as order_value_rank
from orders
where order_status = 'completed'
order by order_timestamp
;

-- Day 18 question 10
-- Write business insights from rolling metrics.

-- Business insights:
-- Running revenue shows how completed order revenue accumulates over time.
-- Rolling monthly averages help smooth short-term changes and reveal the overall trend.
-- Department cumulative revenue shows which teams contribute most consistently.
-- Customer growth analysis helps identify customers whose spending increases or decreases over time.
-- These rolling metrics are useful for monitoring business momentum instead of looking only at single-month performance.

---

-- Day 19 — Employee Performance Mini Project
-- Day 19 question 1: Create employee revenue CTE.

with CTE_completed_employee_revenue as
(
    select
    e.employee_id,
    e.first_name||' '||e.last_name as full_name,
    sum(o.order_amount) as emp_com_rev
    from orders o 
    join employees e
    on e.employee_id = o.employee_id
    where o.order_status = 'completed'
    group by e.employee_id, e.first_name, e.last_name
)
select *
from CTE_completed_employee_revenue
;

-- Day 19 question 2: Rank employees by completed revenue.

with CTE_completed_employee_revenue as
(
    select
    e.employee_id,
    e.first_name||' '||e.last_name as full_name,
    sum(o.order_amount) as emp_com_rev
    from orders o 
    join employees e
    on e.employee_id = o.employee_id
    where o.order_status = 'completed'
    group by e.employee_id, e.first_name, e.last_name
)
select
employee_id,
full_name,
emp_com_rev,
rank() over(order by emp_com_rev desc) as rank_emp_com_rev
from CTE_completed_employee_revenue
;


-- Day 19 question 3: Calculate cumulative employee revenue.
with CTE_completed_employee_running_revenue as
(
    select   
    e.employee_id,
    e.first_name||' '||e.last_name as full_name,
    o.order_amount,
    sum(o.order_amount) 
    over(partition by e.employee_id 
    order by o.order_timestamp) as running_employee_revenue
    from orders o 
    join employees e
    on e.employee_id = o.employee_id
    where o.order_status = 'completed'
)
select *
from CTE_completed_employee_running_revenue
;

-- Day 19 question 4: Compare employee monthly performance.

with CTE_completed_employee_monthly_revenue as
(
    select   
    e.employee_id,
    e.first_name||' '||e.last_name as full_name,
    extract(month from o.order_timestamp) as order_month,
    sum(o.order_amount) as monthly_revenue
    from orders o 
    join employees e
    on e.employee_id = o.employee_id
    where o.order_status = 'completed'
    group by e.employee_id, e.first_name||' '||e.last_name, 
    extract(month from o.order_timestamp)
)
select
employee_id,
full_name,
order_month,
monthly_revenue,
sum(monthly_revenue) 
over(partition by employee_id order by order_month) as emp_running_ttl
from CTE_completed_employee_monthly_revenue
;

-- Day 19 question 5: Identify consistent top performers.
with CTE_completed_employee_monthly_revenue as
(
    select   
    e.employee_id,
    e.first_name||' '||e.last_name as full_name,
    extract(month from o.order_timestamp) as order_month,
    sum(o.order_amount) as monthly_revenue
    from orders o 
    join employees e
    on e.employee_id = o.employee_id
    where o.order_status = 'completed'
    group by e.employee_id, extract(month from o.order_timestamp)
),
CTE_completed_employee_monthly_revenue_rnk as
(
    select
    employee_id,
    full_name,
    order_month,
    monthly_revenue,
    rank() 
    over(partition by order_month order by monthly_revenue desc) as emp_mon_rank
    from CTE_completed_employee_monthly_revenue
)
select *
from CTE_completed_employee_monthly_revenue_rnk
where emp_mon_rank <= 3
order by order_month, emp_mon_rank
;
-- Michael Lee shows top 3 performance for 3 months within 4 months

-- Day 19 question 6: Compare departments using employee data.

with CTE_completed_employee_revenue as
(
    select     
    e.employee_id,
    e.department_id,
    e.first_name||' '||e.last_name as full_name,
    sum(o.order_amount) as emp_com_rev
    from orders o 
    join employees e
    on e.employee_id = o.employee_id
    where o.order_status = 'completed'
    group by e.employee_id, e.department_id, e.first_name, e.last_name
)
select
department_id,
sum(emp_com_rev) deparment_revenue 
from CTE_completed_employee_revenue
group by department_id
;


-- Day 19 question 7: Create employee performance segmentation.

with CTE_completed_employee_revenue as
(
    select    
    e.employee_id,
    e.department_id,
    e.first_name||' '||e.last_name as full_name,
    sum(o.order_amount) as emp_com_rev
    from orders o 
    join employees e
    on e.employee_id = o.employee_id
    where o.order_status = 'completed'
    group by e.employee_id, e.department_id, e.first_name, e.last_name
)
select
*,
rank() 
over(partition by department_id order by emp_com_rev desc) as rnk
from CTE_completed_employee_revenue
;

-- Day 19 question 8: Find performance trends over time.

with CTE_completed_revenue as
(
    select
    order_timestamp,
    order_amount,
    round(((lag(order_amount) over(order by order_timestamp)-order_amount)
    /order_amount)*100,2) as growth_trend
    from orders    
    where order_status = 'completed'
)
select *
from CTE_completed_revenue
;


-- Day 19 question 9: Add business recommendations.

-- Business recommendation 1:
-- Reward and retain top-performing employees 
-- because they generate the highest completed revenue.

-- The business can use bonuses, recognition, 
-- or promotion opportunities to keep them motivated.

-- Business recommendation 2:
-- Study the sales approach of employees who consistently rank in the 
-- top 3 each month.

-- Their communication style, customer handling, or selling process 
-- can be shared with other team members.

-- Business recommendation 3:
-- Provide extra coaching or support to lower-performing employees.

-- This can help improve overall department revenue and reduce the 
-- performance gap between employees.

-- Business recommendation 4:
-- Compare department-level revenue to identify which teams contribute 
-- most to business performance.

-- High-performing departments can become internal benchmarks for other 
-- departments.

-- Business recommendation 5:
-- Monitor revenue trends over time to quickly identify drops in completed 
-- order revenue.

-- If revenue decreases, management should investigate possible causes such 
-- as customer demand, employee availability, or sales process issues.

-- Day 19 question 10: Create final business summary comments.

-- Final business summary:
-- This employee performance analysis helps the business understand which 
-- employees and departments generate the most completed revenue.

-- The analysis identified total employee revenue, employee rankings, 
-- cumulative revenue, monthly performance, consistent top performers, 
-- department revenue, performance segments, and revenue trends over time.

-- These insights can help management make better decisions about rewards, 
-- training, staffing, and performance improvement.

-- Overall, the business should focus on retaining top performers, 
-- supporting low performers, and using monthly performance trends to
-- monitor business momentum.


---


-- Day 20 — Customer Analytics Mini Project
-- Day 20 question 1: Create customer spending CTE.
with CTE_completed_customer_spending as 
(
    select    
    customer_name,
    sum(order_amount) as customer_spending
    from orders
    where order_status = 'completed'
    group by customer_name
)
select *
from CTE_completed_customer_spending
;
-- Day 20 question 2: Segment customers into Low / Medium / High.
with CTE_completed_customer_spending as 
(
    select    
    customer_name,
    sum(order_amount) as customer_spending
    from orders
    where order_status = 'completed'
    group by customer_name
)
select *,
case
    when customer_spending < 500 then 'Low spender'
    when customer_spending between 500 and 799.99 then 'Medium spender'
    else 'High spender'
end as customer_category
from CTE_completed_customer_spending
;


-- Day 20 question 3: Rank top customers.

with CTE_completed_customer_spending as 
(
    select    
    customer_name,
    sum(order_amount) as customer_spending
    from orders
    where order_status = 'completed'
    group by customer_name
)
select *,
case
    when customer_spending < 500 then 'Low spender'
    when customer_spending between 500 and 799.99 then 'Medium spender'
    else 'High spender'
end as customer_category,
rank() over(order by customer_spending desc ) as customer_spending_rank
from CTE_completed_customer_spending
;
-- Day 20 question 4: Calculate cumulative customer spending.

select    
customer_name,
order_timestamp,
sum(order_amount) 
over(partition by customer_name order by order_timestamp)
as cumulative_customer_spending
from orders
where order_status = 'completed'
;

-- Day 20 question 5: Analyze repeat customers.

select
customer_name,
count(order_id) as total_orders,
sum(order_amount) as total_spending,
avg(order_amount) as avg_order_amount
from orders
where order_status = 'completed'
group by customer_name
having count(order_id) > 1
order by total_spending desc
;

-- Day 20 question 6: Find highest monthly spending customers.

with CTE_completed_customer_monthly_spending as
(
    select    
    customer_name,
    extract(month from order_timestamp) as order_month,
    sum(order_amount) as customer_spending
    from orders
    where order_status = 'completed'
    group by customer_name, extract(month from order_timestamp)
),
CTE_completed_customer_monthly_spending_rank as 
(
    select
    customer_name,
    order_month,
    customer_spending,
    rank() over(partition by order_month order by customer_spending desc) monthly_rank
    from CTE_completed_customer_monthly_spending
)
select *
from CTE_completed_customer_monthly_spending_rank
where monthly_rank = 1
;

-- Day 20 question 7: Compare customer growth trends.

with CTE_spending as
(
    select    
    customer_name,
    order_timestamp,
    sum(order_amount) 
    over(partition by customer_name 
    order by order_timestamp)as customer_spending
    from orders
    where order_status = 'completed'
),
CTE_spending_growth as(
    select
    customer_name,
    customer_spending,
    lag(customer_spending) 
    over(partition by customer_name) as previous_order
    from CTE_spending
    )
select 
customer_name,
round(((customer_spending-previous_order)/nullif(previous_order,0))*100,2) 
as customer_growth
from CTE_spending_growth
;

-- Day 20 question 8: Identify top revenue contributors.
-- After few analisus 
-- Daniel R., Kevin H., Sara L., Mint A., Ploy K., Jane C. 
-- are top revenue contributors.



-- Day 20 question 9: Add customer behavior insights.

-- From previous analysis, top 5 spending customers are Daniel R., Kevin H.
-- Sara L., Mint A., Ploy K. And highest monthly spending customers are 
-- Mint A., Jane C., Sara L., Daniel R. and their growth trends are postive
-- growth by time. We should focus on these high-value customers. Provide them 
-- specified sevice and supports


-- Day 20 question 10: Create final business summary.

-- After evaluating the key metrics, we do identify few high-value customers
-- their behaviour seems to increase order amount by time. Besides offering
-- additional service support,the business should survey high-value customers
-- to understand their needs.
-- For examaple, we should seek their demand that we have not provided. Or
-- any products they are interested in.


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