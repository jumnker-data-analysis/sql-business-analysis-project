# 📊 SQL Analytics Mini Project (PostgreSQL)

## 📌 Project Overview
This project analyzes a small business dataset using PostgreSQL.

It demonstrates SQL skills including:
- Joins (INNER, LEFT)
- Aggregations (SUM, COUNT, AVG)
- Conditional logic (CASE WHEN)
- Grouping and filtering
- Business KPI analysis

---

## 🗂️ Dataset
The dataset includes:
- Employees (employee details)
- Orders (transactions and revenue)
- Departments (organizational structure)

---

## 🔍 Key Analysis

### 1. Revenue Analysis
- Total revenue by department
- Revenue by payment method
- Monthly revenue trends

### 2. Employee Performance
- Orders handled per employee
- Completed revenue per employee
- Employees with no completed orders

### 3. Business Insights
- Highest performing department
- Top employees by revenue
- Customer behavior patterns

---

## 🛠️ Tools Used
- PostgreSQL
- VS Code
- SQL

---

##  Progress 
- ✅ Day 1-7 SQL fundamentals
- ✅ Day 8-9 Subqueries & correlated queries
- ✅ Day 10 CASE statemens & segmentation
## Day 11 - Window Functions

- Used RANK() to rank employees and departments by revenue
- Applied ROW_NUMBER() to find top orders per employee
- Implemented PARTITION BY for grouped ranking
- Business insight: Top performers concentrated in key departments

## Day 12 - Monthly Revenue & Running Totals

In Day 12, I practiced time-based SQL analysis using PostgreSQL.

### Skills practiced
- EXTRACT(MONTH FROM timestamp)
- Monthly revenue analysis
- Monthly order count
- Running totals using SUM() OVER()
- Revenue by department and month
- Business insight writing

### Key business insight
January had the strongest completed revenue, suggesting stronger customer demand or stronger sales activity during that period.

## Day 13 - Introduction to CTE

### Topics
- Basic CTE structure
- Creating temporary result sets
- Simple revenue aggregation

### Key learning
CTE works like a temporary table that improves query readability.


## Day 14 - Advanced CTE Applications

### Topics
- Employee revenue ranking (RANK)
- Department revenue analysis
- Customer segmentation (CASE)
- Monthly revenue CTE
- Running totals with window functions

## Day 15
- Refactored old SQL queries
- Improved readable using CTEs
- Added business insights from previous challenges
- Practiced writing cleaner and more maintainable SQL

## Day 16 — Advanced Ranking Analysis

## Skills Practiced
- CTE (Common Table Expressions)
- RANK()
- DENSE_RANK()
- ROW_NUMBER()
- PARTITION BY
- Running totals
- Monthly leaderboard analysis
- Employee performance ranking
- Department revenue analysis
- Business insight generation

## Challenges Completed
1. Rank employees by completed revenue
2. Compare RANK() vs DENSE_RANK()
3. Compare ROW_NUMBER() vs RANK()
4. Find top 5 customers by spending
5. Rank departments by total revenue
6. Find lowest-performing employees
7. Rank employees within each department
8. Find top monthly revenue by employee
9. Build monthly employee leaderboard
10. Add business insight comments

## Key Learning
Today focused heavily on analytical SQL using window functions and CTEs to simulate real business reporting scenarios.

## Day 17 — LEAD & LAG Trend Analysis

### Skills Practiced
- LEAD()
- LAG()
- Month-to-month revenue comparison
- Revenue increase/decrease analysis
- Department monthly performance trends
- Business trend explanation

### Key Insight
Monthly completed revenue showed unstable momentum, with the strongest revenue in Month 1 and the largest decline in Month 4.

## Day 18 – Running Totals + Rolling Analysis

Topics practiced:
- Running total revenue
- Running customer spending
- Cumulative department revenue
- Rolling monthly averages
- Running order counts
- Cumulative completed vs pending orders
- Combining running totals with ranking
- Customer growth trend analysis

Key SQL concepts:
- Window Functions
- SUM() OVER()
- AVG() OVER()
- PARTITION BY
- LEAD()
- Rolling metrics
- Running cumulative calculations

Business insights learned:
- How revenue accumulates over time
- How rolling averages smooth business trends
- How departments contribute differently to revenue growth
- How customer spending changes across time periods
---

## 📈 Key Learning Outcomes
- Handling one-to-many relationships
- Avoiding aggregation errors
- Writing business-oriented SQL queries
- Structuring SQL projects for real-world use

---

## 📎 Author
Yu-Jheng Su
🔗 LinkedIn: www.linkedin.com/in/yujhengsu
🔗 GitHub: https://github.com/jumnker-data-analysi