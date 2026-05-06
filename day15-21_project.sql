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