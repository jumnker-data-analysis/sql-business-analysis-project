-- Day 8 Question 1
-- Find all orders where 'order_amount' is higher
-- than the average order amount.

select *
from orders o
where order_amount > (
    select avg(order_amount)
    from orders
)
;

-- Day 8 Question 2
-- Find completed orders where 'order_amount' is higher
-- than the average completed order amount.

select *
from orders
where order_amount > (
    select avg(order_amount)
    from orders
    where order_status = 'completed'
)
and order_status = 'completed'
;

-- Day 8 Question 3
-- Find all employees whose salary is higher
-- than the average salary.

select *
from employees
where salary > (
    select avg(salary)
    from employees
)
;

-- Day 8 Question 4
-- Find all employees whose salary is higher than 
-- the average salary of all employees in their dapartment.

select *
from employees e
where salary > (
    select avg(salary)
    from employees
    where department_id= e.department_id
)
;

-- Day 8 Question 5
-- Find orders handled by employees who work in the
-- Sales department.

select count(order_id) as o_hld_dep 
from orders o 
join employees e
    on e.employee_id = o.employee_id
where department_id = (
    select department_id 
    from departments 
    where department_name = 'Sales'
)
;


-- Day 8 Question 6
-- Find departments that have at least one employee handling
-- completed orders.

select distinct department_name 
from orders o
join employees e
    on e.employee_id = o.employee_id
join departments d
    on d.department_id = e.department_id
where order_status = 'completed'
;

-- Day 8 Question 7
-- Find employees who handled at least one order above 300.
select e.employee_id,
(first_name||' '||last_name) as full_name
from employees e
where e.employee_id in (
    select distinct o.employee_id 
    from orders o
    where order_amount > 300
)
;

-- Day 8 Question 8
-- Business question: Which employees are handling unusually
-- high-value orders?


select o.employee_id,
e.first_name||' '||e.last_name as full_name,
d.department_name,
count(*) as high_value_orders,
sum(o.order_amount) as high_value_revenue
from orders o 
join employees e
    on o.employee_id = e.employee_id
join departments d 
    on e.department_id = d.department_id
where o.order_amount > (
    select avg(order_amount)
    from orders
)
group by d.department_name, o.employee_id, full_name
order by high_value_revenue desc
;

-- Day 9 Question 1
-- Find employees whose salary is higher than the average salary
-- in their own department.

select e.employee_id,
e.first_name||' '||e.last_name as full_name,
e.department_id
from employees e
where e.salary > (
    select avg(salary)
    from employees
    where department_id= e.department_id
)
;

-- Day 9 Question 2
-- Find orders where the amount is higher than the average order 
-- amount for that same employees

select o.order_id,
o.order_amount,
o.employee_id
from orders o
where o.order_amount > (
    select avg(order_amount)
    from orders
    where employee_id = o.employee_id
)
;


-- Day 9 Question 3
-- Find departments where average salary is higher than the 
-- company-wide average salary.

select d.department_name,
avg(e.salary) as avg_sal_dep
from employees e
join departments d
    on e.department_id = d.department_id
group by d.department_name
having avg(e.salary) >
(
select avg(salary) 
from employees
)
;


-- Day 9 Question 4
-- Find employees whose total completed revenue is above the average
-- completed revenue per employee.


select 
employee_id,
sum(order_amount) as ttl_com_emp_out
from orders o
where order_status = 'completed'
group by employee_id
having sum(order_amount) > 
(
    select avg(ttl_com_emp)
    from
    (
        select employee_id, 
        sum(order_amount) as ttl_com_emp
        from orders
        where order_status = 'completed'
        group by employee_id
    ) as ttl_com_emps
)

-- Day 9 Question 5
-- Find each employee's highest order.
select o.employee_id, 
o.order_id, 
o.order_amount
from orders o 
where (o.employee_id, o.order_amount) in  
(
    select employee_id, max(order_amount)
    from orders
    group by employee_id
    order by employee_id
)
order by employee_id
;
-- Day 9 Question 6
-- Find customers whose spending is higher than the average customer spending.

select 
o.customer_name,
sum(o.order_amount) as customer_spending
from orders o
group by customer_name
having sum(o.order_amount) > 
(
    select avg(customer_total)
    from
    (
        select customer_name, 
        sum(order_amount) as customer_total
        from orders
        group by customer_name
    ) as customer_totals
)


-- Day 9 Question 7
-- Find payment methods where total completed revenue is above the
-- average revenue by payment method.

select 
o.payment_method,
sum(o.order_amount) as per_method_total_out
from orders o
group by o.payment_method
having sum(o.order_amount) >
(
    select avg(per_method_total)
    from
    (
        select 
        payment_method,
        sum(order_amount) as per_method_total
        from orders
        where order_status = 'completed'
        group by payment_method
    ) as per_method_totals
)

-- Day 9 Question 8
-- Business question: Which employees outperform their department
-- or peer group.

select e.department_id, avg(salary)
from orders o 
left join employees e 
on o.employee_id = e.employee_id
where 
group by e.department_id


-- Day 10 Question 1
-- Categorize orders by value:
-- Low: below 100
-- Medium: 100–299.99
-- High: 300 and above

select 
o.order_id,
case
    when o.order_amount < 100 then 'Low'
    when o.order_amount between 100 and 299.99 then 'Medium'
    else 'High'
end as value_category
from orders o


-- Day 10 Question 2
-- Count orders in each value category.
select 
count(*),
case
    when o.order_amount < 100 then 'Low'
    when o.order_amount between 100 and 299.99 then 'Medium'
    else 'High'
end as value_category
from orders o
group by (case
    when o.order_amount < 100 then 'Low'
    when o.order_amount between 100 and 299.99 then 'Medium'
    else 'High'
end)


-- Day 10 Question 3
-- Calculate completed revenue by value category.

select
sum(o.order_amount) as ttl_com_order_amt,
case
    when o.order_amount < 100 then 'Low'
    when o.order_amount between 100 and 299.99 then 'Medium'
    else 'High'
end as order_category
from orders o
where o.order_status = 'completed'
group by (case
    when o.order_amount < 100 then 'Low'
    when o.order_amount between 100 and 299.99 then 'Medium'
    else 'High'
end)


-- Day 10 Question 4
-- Categorize employees by salary:
-- Junior: below 55000
-- Mid: 55000–69999
-- Senior: 70000 and above

select 
e.employee_id,
case
    when e.salary < 55000 then 'Junior'
    when e.salary between 55000 and 69999 then 'Mid'
    else 'Senior'
end as emp_category
from employees e


-- Day 10 Question 5
-- Count employees in each salary category.

select 
count(*),
case
    when e.salary < 55000 then 'Junior'
    when e.salary between 55000 and 69999 then 'Med'
    else 'Senior'
end as emp_category
from employees e
group by (case
    when e.salary < 55000 then 'Junior'
    when e.salary between 55000 and 69999 then 'Med'
    else 'Senior'
end)

-- Day 10 Question 6
-- Create customer spending tiers:
-- Low spender -- Medium spender -- High spender

select 
customer_name,
case
    when customer_total_spending < 500 then 'Low spender'
    when customer_total_spending between 500 and 799.99 then 'Medium spender'
    else 'High spender'
end as order_category
from (
    select customer_name,
    sum(order_amount) as customer_total_spending
    from orders
    group by customer_name
) 


-- Day 10 Question 7
-- Show each order with:
-- order amount
-- payment method
-- order status
-- value category

select 
o.order_amount,
o.payment_method,
o.order_status,
case
    when o.order_amount < 100 then 'Low'
    when o.order_amount between 100 and 299.99 then 'Medium'
    else 'High'
end as value_category
from orders o

-- Day 10 Question 8
-- Business question: Which customer/order segment 
-- should the business focus on?

-- Ans: High-value orders coontribute majority of revenue.
-- Focus marketing on customers with high total spending 



-- Day 11 Question 1
-- Rank employees by total completed revenue.

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
-- Day 11 Question 2
-- Rank departments by completed revenue.

select 
d.department_name,
sum(o.order_amount) as total_revenue,
rank() over(order by sum(o.order_amount) desc) as rank
from orders o
join employees e
on e.employee_id = o.employee_id
join departments d 
on d.department_id = e.department_id
where o.order_status = 'completed'
group by d.department_name
;

-- Day 11 Question 3
-- Rank orders by order amount from highest to lowest.

select 
order_id,
order_amount,
rank() over(order by order_amount desc)
from orders
;

-- Day 11 Question 4
-- Show top 3 orders per payment method.
select *
from 
(
select
order_amount,
payment_method,
rank() over(partition by payment_method 
order by order_amount desc) as rnk 
from orders
) as rank_table
where rnk <= 3
;


-- Day 11 Question 5
-- Show top employee per department by completed revenue.
select *
from
(
select 
o.employee_id,
d.department_name,
e.first_name||' '||e.last_name as full_name,
sum(o.order_amount) as total_revenue,
rank() over(partition by d.department_name 
order by sum(o.order_amount) desc) as rnk
from orders o
join employees e
on e.employee_id = o.employee_id
join departments d 
on d.department_id = e.department_id
where o.order_status = 'completed'
group by d.department_name, o.employee_id, e.first_name||' '||e.last_name

) as rnk_table
where rnk =1
;

-- Day 11 Question 6
-- Show each employee’s orders and rank their orders by amount.

select 
employee_id,
order_id,
order_amount,
rank() over(partition by employee_id 
order by order_amount desc)
from orders
;


-- Day 11 Question 7
-- Use `ROW_NUMBER()` to find each employee’s highest-value order.
select *
from
(
select 
employee_id,
order_id,
order_amount,
ROW_NUMBER() over(partition by employee_id 
order by order_amount desc) as row_num
from orders

)
where row_num = 1
;

-- Day 11 Question 8
-- Compare `RANK()` and `DENSE_RANK()` using employee revenue.

select 
employee_id,
sum(order_amount),
rank() over(order by sum(order_amount) desc),
dense_rank() over(order by sum(order_amount) desc)
from orders
group by employee_id
;


### Stretch
Business question:
> Who are the top performers, and are they concentrated in one department?

select 
o.employee_id,
d.department_name,
sum(o.order_amount),
rank() over(order by sum(o.order_amount) desc),
dense_rank() over(order by sum(o.order_amount) desc)
from orders o
join employees e
on e.employee_id = o.employee_id
join departments d 
on d.department_id = e.department_id
group by o.employee_id, d.department_name
;

-- the top performers are concentrated at 3 deparments 
-- sales 3, operations 2 and finance 2. it seems shows sales 
-- department dominately perfomce the best over the period. 



-- Day 12 Question 1
-- Calculate monthly completed revenue.

select 
extract(month from order_timestamp) as order_month,
sum(order_amount) as monthly_revenue
from orders 
where order_status = 'completed'
group by extract(month from order_timestamp)
order by order_month
;

-- Day 12 Question 2
-- Calculate running total revenue by month.

select
order_month,
monthly_revenue,
sum(monthly_revenue) over(
    order by order_month
    rows between unbounded preceding and current row
) as running_monthly_revenue
from
(
    select 
    extract(month from order_timestamp) as order_month,
    sum(order_amount) as monthly_revenue
    from orders 
    where order_status = 'completed'
    group by extract(month from order_timestamp)
    order by order_month
)
;

-- Day 12 Question 3
-- Calculate monthly order count.


select 
extract(month from order_timestamp) as order_month,
count(*) as monthly_orders
from orders
where order_status = 'completed'
group by extract(month from order_timestamp)
order by order_month
;


-- Day 12 Question 4
-- Calculate running total order count by month.

select
order_month,
monthly_orders,
sum(monthly_orders) over(order by order_month)
from
(
    select 
    extract(month from order_timestamp) as order_month,
    count(*) as monthly_orders
    from orders
    where order_status = 'completed'
    group by extract(month from order_timestamp)
    order by order_month
)
;


-- Day 12 Question 5
-- Calculate completed revenue by department and month.

select 
e.department_id,
extract(month from o.order_timestamp) as order_month,
sum(o.order_amount) as dep_monthly_revenue
from orders o
join employees e
on e.employee_id = o.employee_id
where o.order_status = 'completed'
group by e.department_id, extract(month from o.order_timestamp)
;


-- Day 12 Question 6
-- Calculate running revenue by department over time.

select
department_id,
order_month,
dep_monthly_revenue,
sum(dep_monthly_revenue) over(partition by department_id
order by order_month) as dep_monthly_revenue_running
from
(
    select 
    e.department_id,
    extract(month from o.order_timestamp) as order_month,
    sum(o.order_amount) as dep_monthly_revenue
    from orders o
    join employees e
    on e.employee_id = o.employee_id
    where o.order_status = 'completed'
    group by e.department_id, 
    extract(month from o.order_timestamp)
)
;

-- Day 12 Question 7
-- Show each order with:
-- order amount
-- order month
-- cumulative revenue so far

select
order_id,
order_timestamp,
extract(month from order_timestamp) as order_month,
order_amount,
sum(order_amount) over(order by order_timestamp)
from 
orders
;

-- Day 12 Question 8
-- Business question: Which month had the strongest 
-- revenue momentum?

-- according to monthly completed revenue.
select 
order_month,
sum(order_amount) as monthly_revenue
from
    (
    select *,
    extract(month from order_timestamp) as order_month
    from orders 
    )
where order_status = 'completed'
group by order_month
;
-- January shows the strongest revenue momentum, indicating 
-- peak csutomer demand successful campaigns during this
-- period.  
.



-- Day 13 — CTEs: Clean Query Structure

-- Goal
-- Use `WITH` statements to make complex business queries easier to read.

-- Day 13 Question 1
-- Create a CTE for completed orders only.

with CTE_completed as 
(
    select *
    from orders
    where order_status = 'completed'
)
select *
from CTE_completed
;

-- Day 13 Question 2
-- Use that CTE to calculate total completed revenue.

with CTE_completed as 
(
    select *
    from orders
    where order_status = 'completed'
)
select sum(order_amount) as total_completed_revenue
from CTE_completed
;

-- Day 13 Question 3.
-- Create a CTE for employee revenue.

with CTE_completed_employee as
(
    select
    distinct e.employee_id,
    e.first_name,
    e.last_name, 
    sum(o.order_amount) 
    over(partition by e.employee_id) as employee_revenue
    from orders o 
    join employees e
    on e.employee_id = o.employee_id
    where o.order_status = 'completed'
)
select *
from CTE_completed_employee
;

-- Day 13 Question 4
-- Use the employee revenue CTE to rank employees.

with CTE_completed_employee as
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
)
select
rank() over(order by employee_revenue desc) as rnk,
department_id,
employee_id,
employee_revenue,
last_name||' '||first_name as full_name
from CTE_completed_employee
;

-- Day 13 Question 5
-- Create a department revenue CTE.

with CTE_completed_department as
(
    select
    distinct d.department_name,
    sum(o.order_amount) 
    over(partition by d.department_name) as deparment_revenue
    from orders o 
    join employees e
    on e.employee_id = o.employee_id
    join departments d
    on d.department_id = e.department_id
    where o.order_status = 'completed'
)
select *
from CTE_completed_department
;

-- Day 13 Question 6
-- Use the department revenue CTE to find the top department.

with CTE_completed_department as
(
    select
    distinct d.department_name,
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
department_revenue
from CTE_completed_department
order by department_revenue desc
limit 1
;

-- Day 13 Question 7
-- Create a customer spending CTE.

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
;

-- Day 13 Question 8
-- Use the customer spending CTE to segment customers 
-- into Low / Medium / High.

with CTE_completed_customer as 
(
    select
    distinct customer_name,
    sum(order_amount) 
    over(partition by customer_name) as customer_spending
    from orders
    where order_status = 'completed'
)
select 
customer_name,
customer_spending,
case
    when customer_spending < 500 then 'Low spender'
    when customer_spending between 500 and 799.99 then 'Medium spender'
    else 'High spender'
end as customer_category
from CTE_completed_customer
;
-- High-spending cusotmers contributed disproportionately to 
-- total revenue.

-- Day 13 Question 9
-- Create a CTE for monthly revenue.

with CTE_completed_month as 
(
    select
    distinct extract(month from order_timestamp) as order_month,
    sum(order_amount) 
    over(partition by extract(month from order_timestamp)) as monthly_revenue
    from orders
    where order_status = 'completed'
)
select *
from CTE_completed_month
;

-- Day 13 Question 10
--Use the monthly revenue CTE to calculate running total revenue.

with CTE_completed_month as 
(
    select
    distinct extract(month from order_timestamp) as order_month,
    sum(order_amount) 
    over(partition by extract(month from order_timestamp)) as monthly_revenue
    from orders
    where order_status = 'completed'
)
select
order_month,
sum(monthly_revenue) over(order by order_month 
rows between unbounded preceding and current row
) as running_monthly_revenue
from CTE_completed_month
;

### Stretch
Rewrite one Day 7 query using a CTE and compare readability.

---

## Day 14 — Mini Project: Business Performance Analysis

### Goal
Combine JOIN, GROUP BY, CASE WHEN, CTE, and window functions into one mini project.

### Mini Project Theme
**Small Business Revenue & Employee Performance Analysis**

### Required Questions
1. What is the total completed revenue?
2. What is the completed order count?
3. What is the average completed order value?
4. Which department generated the most completed revenue?
5. Which employee generated the most completed revenue?
6. Which employee handled the most completed orders?
7. Which payment method generated the most completed revenue?
8. Which customer occupation generated the most revenue?
9. Which month generated the highest completed revenue?
10. Which employees had zero completed revenue?
11. Which department has the highest average order value?
12. Which order value segment contributes the most revenue?
13. Rank employees by completed revenue.
14. Rank departments by completed revenue.
15. Write 3 business recommendations based on your SQL results.

### Final Deliverable
Create a file:

```text
day14_business_performance_analysis.sql
```

Include:
- clean comments
- final SQL queries only
- readable aliases
- business insight comments under each major query

Example comment:

```sql
-- Insight:
-- Sales generated the highest completed revenue, suggesting stronger customer-facing activity.
```