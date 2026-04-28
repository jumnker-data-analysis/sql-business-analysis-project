drop table if exists orders;
drop table if exists departments;
drop table if exists employeess;

select current_database(); 

CREATE TABLE departments (
department_id SERIAL PRIMARY KEY,
department_name TEXT
);

CREATE TABLE employees (
employee_id SERIAL PRIMARY KEY,
first_name TEXT not null,
last_name TEXT not null,
age INT not null,
salary NUMERIC not null,
department_id INT not null,
hire_date DATE not null,
job_title text not null
);

CREATE TABLE orders (
order_id SERIAL PRIMARY KEY,
employee_id INT not null,
customer_name TEXT not null,
customer_occupation TEXT not null,
order_amount NUMERIC not null,
order_status TEXT not null,
payment_method TEXT not null,
order_timestamp TIMESTAMP not null
);

select table_name
from information_schema.tables
where table_schema = 'public';


copy employees 
from 'C:\\data\employees.csv'
delimiter ','
csv header;

alter table employees
add column job_title text;


copy orders 
from 'C:\\data\orders.csv'
delimiter ','
csv header;

copy departments 
from 'C:\\data\departments.csv'
delimiter ','
csv header;


select * from employees;

select * from orders;

select * from departments;


select count(*) from employees;

select count(*) from orders;

select count(*) from departments;

-- Day 3 Question 1
-- How many successfull orders did the company complete??

select count(*)
from orders
where order_status = 'completed';

-- Day 3 Question 2
-- which orders are high value(>300)??
select order_id  
from orders
where order_amount > 300;

-- Day 3 Question 3
-- Who works in Analytics??

select *
from employees 
where department_id = '2'


-- Day 3 Question 4
-- recent hires(2021-01-01)??

select * 
from employees 
where hire_date > '2021-01-01'

-- Day 3 Question 5
-- Show all orders paid  by 'e-wallet'

select *
from orders
where payment_method = 'e_wallet';

-- Day 3 Question 6
-- Show all orders that are either 'cancelled' or 'refunded'

select *
from orders
where order_status in ('cancelled', 'refunded');


-- Day 3 Question 7
-- Show all customers whose name starts with 'P' are either 'cancelled' or 'refunded'

select *
from orders
where customer_name like 'P%';


-- Day 3 Question 8
-- Show all employees aged between 30 and 40.

select *
from employees
where (age > 30 and age <40);


-- Day 4 Aggregates and KPIs

select * from employees;

select * from orders;

select * from departments;


-- Day 4 Question 1
-- Count total orders.

select count(*)
from orders;

-- Day 4 Question 2
-- Count only completed orders.

select count(*)
from orders
where order_status = 'completed';

-- Day 4 Question 3
-- Find total revenue from completed only.

select sum(order_amount) as total_revenue
from orders
where order_status = 'completed';

-- Day 4 Question 4
-- Find average order amount for all orders.

select avg(order_amount) as avg_amt
from orders
where order_status = 'completed';

-- Day 4 Question 5
-- Find highest and lowest average order amount .

select max(order_amount) as max_amt,
min(order_amount) as min_amt
from orders
where order_status = 'completed';

-- Day 4 Question 6
-- Find average employee salary.

select avg(salary) as avg_sal
from employees;

-- Day 4 Question 7
-- Count how many employees are in each department.

select count(department_name), department_name
from employees
inner join departments on employees.department_id = departments.department_id
group by department_name
;

-- Day 4 Question 8
-- Find total payroll cost (sum of employee salaries).

select sum(salary) as total_payroll
from employees;

-- Day 5 Question 1
-- Count orders by status.
select * from employees;
select * from orders;
select * from departments;

select order_status, count(*) 
from orders
group by order_status
;

-- Day 5 Question 2
-- Count orders by payment method.

select payment_method, count(*) 
from orders
group by payment_method
;

-- Day 5 Question 3
-- Total revenue by payment method.

select payment_method, sum(order_amount) 
from orders
group by payment_method
;

-- Day 5 Question 4
-- Average order amount by status.

select order_status, avg(order_amount) 
from orders
group by order_status
;

-- Day 5 Question 5
-- Count customers by occupation.

select customer_occupation, count(distinct customer_name) 
from orders
group by customer_occupation
;

-- Day 5 Question 6
-- Count employees by department.

select department_name, count(*)
from employees
inner join departments on employees.department_id = departments.department_id
group by department_name
;

-- Day 5 Question 7
-- Average salary by department.

select department_name, avg(salary)
from employees
inner join departments on employees.department_id = departments.department_id
group by department_name
;

-- Day 5 Question 8
-- Total order revenue handled by each employee.

select employees.employee_id, employees.first_name, sum(orders.order_amount) as total_revenue
from orders
join employees on orders.employee_id = employees.employee_id
group by employees.employee_id
;

-- Day 5 Question 9
-- Monthly order count using 'DATE_TRUNC('month',order_timestamp)'.

select DATE_TRUNC('month',order_timestamp) as order_month, count(*)
from orders
group by DATE_TRUNC('month',order_timestamp)
;


-- Day 6 Question 1
-- Top 5 highest value orders.

select * from employees;
select * from orders;
select * from departments;

select order_id, customer_name, order_amount
from orders
order by order_amount desc
limit 5;

-- Day 6 Question 2
-- Top 3 employees by total completed revenue.

select employees.first_name, sum(orders.order_amount) as com_emp_ttl_rev
from orders
inner join employees on orders.employee_id = employees.employee_id
where orders.order_status = 'completed'
group by employees.employee_id, employees.first_name
order by sum(order_amount) desc
limit 3
;

-- Day 6 Question 3
-- Bottom 3 emplyees by total completed revenue.

select employees.first_name, sum(orders.order_amount) as com_emp_ttl_rev
from orders
inner join employees on orders.employee_id = employees.employee_id
where orders.order_status = 'completed'
group by employees.employee_id, employees.first_name
order by sum(order_amount) asc
limit 3
;

-- Day 6 Question 4
-- Top 5 customer occupations by total spending.

select customer_occupation, sum(order_amount)
from orders
where orders.order_status = 'completed'
group by customer_occupation
order by sum(order_amount) desc
limit 5 
;

-- Day 6 Question 5
-- Which payment method genetared the most completed revenue?

select payment_method, sum(order_amount)
from orders
where order_status = 'completed'
group by payment_method
order by sum(order_amount) desc
limit 1
;

-- Day 6 Question 6
-- Which month had the highest completed revenue?

select date_trunc('month', order_timestamp) as month,
sum(order_amount) as Total_revenue
from orders
where order_status = 'completed'
group by date_trunc('month', order_timestamp)
order by sum(order_amount) desc
limit 1
;

-- Day 6 Question 7
-- Show the 10 most recent orders.

select *
from orders
order by order_timestamp desc
limit 10
;




-- Day 7 Question 1
-- Show each employee with their department name.

select employees.employee_id,
employees.first_name||' '||employees.last_name as full_name,
departments.department_name
from orders
inner join employees 
    on orders.employee_id = employees.employee_id
inner join departments
    on departments.department_id = employees.department_id
group by employees.employee_id, full_name, departments.department_name
order by employees.employee_id 
;

-- Day 7 Question 2
-- Show each order with employee full name and department name.

select order_id,
employees.employee_id,
employees.first_name||' '||employees.last_name as full_name,
departments.department_name
from orders
inner join employees 
    on orders.employee_id = employees.employee_id
inner join departments
    on departments.department_id = employees.department_id
;

-- Day 7 Question 3
-- Total completed revenue by department.

select
departments.department_name,
sum(orders.order_amount) as total_revenue
from orders
inner join employees 
    on orders.employee_id = employees.employee_id
inner join departments
    on departments.department_id = employees.department_id
where order_status = 'completed'
group by departments.department_name
;

-- Day 7 Question 4
-- Average completed order value by department.

select
departments.department_name,
Sum(orders.order_amount)/count(orders.order_amount) avg_amt
from orders
inner join employees 
    on orders.employee_id = employees.employee_id
inner join departments
    on departments.department_id = employees.department_id
where order_status = 'completed'
group by departments.department_name
;

-- Day 7 Question 5
-- Count completed orders by department.

select
departments.department_name as dep_name, 
count(orders.order_amount) as com_orders
from orders
inner join employees 
    on orders.employee_id = employees.employee_id
inner join departments
    on departments.department_id = employees.department_id
where order_status = 'completed'
group by departments.department_name
;

-- Day 7 Question 6
-- which department handled the highest completed revenue.

select
departments.department_name,
sum(orders.order_amount) as total_revenue
from orders
inner join employees 
    on orders.employee_id = employees.employee_id
inner join departments
    on departments.department_id = employees.department_id
where order_status = 'completed'
group by departments.department_name
order by sum(orders.order_amount) desc
limit 1 
;

-- Day 7 Question 7
-- Show employees who have not handled any completed orders.

select 
employees.employee_id,
employees.first_name||' '||employees.last_name as full_name
from orders
inner join employees 
    on orders.employee_id = employees.employee_id
inner join departments
    on departments.department_id = employees.department_id
where (order_status = 'pending' 
or order_status = 'cancelled' 
or order_status = 'refunded') 
and order_status != 'completed'
group by employees.employee_id, full_name
;

-- Day 7 Question 8
-- Show each department's average employee salary and total completed revenue together.

select 
departments.department_name,
avg(distinct employees.salary) as avg_salary,
sum(orders.order_amount) as Total_revenue
from orders
inner join employees 
    on orders.employee_id = employees.employee_id
inner join departments
    on departments.department_id = employees.department_id
where order_status = 'completed'
group by 
departments.department_name
;


-- Day 7 Question 9
-- For each employees, show: 
-- -full name
-- -department name
-- -number of orders handled 
-- -total completed revenue

select 
employees.employee_id,
employees.first_name||' '||employees.last_name as full_name,
departments.department_name,
count(orders.order_id) as order_handled,
sum(case when orders.order_status = 'completed' 
    then orders.order_amount 
    else 0 
    end) as completed_revenue
from employees 
inner join departments
    on departments.department_id = employees.department_id
left join orders 
    on orders.employee_id = employees.employee_id
group by employees.employee_id,
full_name,
departments.department_name
order by employees.employee_id
;



-- Day 7 Question 10
-- Find the highest-value completed order and the employee responsible.

select 
employees.employee_id,
employees.first_name||' '||employees.last_name as full_name,
departments.department_name,
count(orders.order_id) as order_handled,
sum(orders.order_amount) as emp_rev,
orders.order_status
from employees 
inner join departments
    on departments.department_id = employees.department_id
inner join orders 
    on orders.employee_id = employees.employee_id
group by orders.order_status,
departments.department_name, 
employees.employee_id,
full_name
having orders.order_status = 'completed'
order by emp_rev desc
limit 1
;