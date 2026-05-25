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

## Day 19 – Employee Performance Mini Project

### Skills Practiced
- CTEs
- Window Functions
- RANK()
- Running Totals
- Revenue Trend Analysis
- Employee Segmentation
- Department Performance Analysis

### Business Questions Solved
1. Create employee revenue CTE
2. Rank employees by completed revenue
3. Calculate cumulative employee revenue
4. Compare employee monthly performance
5. Identify consistent top performers
6. Compare departments using employee data
7. Create employee performance segmentation
8. Find performance trends over time
9. Add business recommendations
10. Create final business summary comments



### Key Business Insights
- Top-performing employees consistently drive most revenue.
- Monthly ranking helps identify stable high performers.
- Department-level analysis highlights strong and weak teams.
- Revenue trend analysis helps detect business momentum changes.
- Employee segmentation supports better coaching and reward strategies.

## Day 20 – Customer Analytics Mini Project

### Topics practiced:
- Customer spending CTE
- Customer segmentation
- Customer spending ranking
- Cumulative customer spending
- Repeat customer analysis
- Highest monthly spending customers
- Customer growth trend analysis
- Customer behavior insights
- Final business summary

### Key SQL concepts:
- CTE
- CASE WHEN
- RANK()
- SUM() OVER()
- LAG()
- PARTITION BY
- HAVING
- Customer segmentation

### Business insights learned:
- How to identify high-value customers
- How to separate low, medium, and high spenders
- How to detect repeat customers
- How customer spending changes over time
- How SQL can support customer retention and marketing decisions

## Day 21 — Revenue Trend Dashboard Queries

Today focused on building dashboard-style SQL analytics using CTEs, window functions, ranking logic, and revenue trend analysis.

### Topics Practiced
- Monthly revenue aggregation
- Monthly order count analysis
- Revenue growth rate calculations
- Running revenue dashboards
- Department monthly trend comparisons
- Monthly performance ranking
- Strongest revenue growth period detection
- Weakest month identification
- Executive-style business insights
- Dashboard query organization

### SQL Concepts Used
- CTE (Common Table Expressions)
- Window Functions
- LAG()
- SUM() OVER()
- RANK()
- Running Totals
- Month-over-Month (MoM) Growth
- Revenue KPI Analysis
- Department Trend Analysis

### Key Business Insights
- Month 1 generated the highest revenue performance.
- Month 4 showed the weakest revenue growth.
- Revenue trends fluctuated significantly across months.
- Department 1 and Department 5 showed stronger cumulative growth.
- Dashboard queries were organized into executive reporting sections.

### Portfolio Progress
This day focused on transforming SQL practice into dashboard-style analytical reporting similar to real business intelligence workflows.

# SQL Learning Portfolio

## Overview
This repository contains my daily SQL practice projects using PostgreSQL.

The projects focus on:
- CTEs
- Window Functions
- Business Analysis
- Revenue Dashboards
- Customer Analytics

## Skills Practiced
- Aggregation
- JOINs
- CASE statements
- Window Functions
- Running Totals
- MoM Growth Analysis
- Ranking Functions

## Featured Projects

### Day 20 — Customer Analytics
- Customer segmentation
- Customer growth trends
- Revenue contribution analysis

### Day 21 — Revenue Trend Dashboard
- Monthly revenue KPIs
- Running revenue dashboard
- Department trend analysis
- Growth period analysis

## Tools
- PostgreSQL
- VS Code

## Goal
Building real-world SQL analysis skills for data analyst opportunities.

## Day 22 — Portfolio Optimization + Refactoring

### Topics Practiced
- Refactoring old SQL queries using CTEs
- Rewriting subqueries with window functions
- Improving query readability and formatting
- Reducing duplicated SQL logic
- Writing recruiter-friendly SQL comments
- Organizing SQL projects professionally
- Selecting portfolio-quality SQL queries

### Key Skills
- CTE optimization
- Window Functions
- SQL readability
- Professional SQL formatting
- GitHub portfolio structuring
- Business-focused SQL presentation

# Brazil Ecommerce Business Analysis Project (Olist Dataset)

## Project Overview
This project analyzes Brazil ecommerce business performance using PostgreSQL and the Olist Ecommerce Dataset.

The goal of this project is to simulate real-world business analysis workflows including:
- revenue analysis
- customer analytics
- delivery performance analysis
- KPI tracking
- dashboard-ready SQL development
- executive business insights

---

## Day 23 Progress — Project Initialization

### Completed Tasks
- Imported ecommerce CSV datasets into PostgreSQL
- Explored table structures and relationships
- Identified primary business flow between customers, orders, payments, and order items
- Built initial SQL JOIN queries
- Organized project folders and SQL workflow

### Current Dataset Tables
- customers
- orders
- order_items
- order_payments

---

## Main Business Questions
- Which months generate the highest revenue?
- Which customers contribute the most revenue?
- What are the delivery and payment trends?
- Which product orders generate the highest sales value?
- How can SQL support dashboard-style business analysis?

---

## Tools Used
- PostgreSQL
- pgAdmin 4
- VS Code
- SQL
- GitHub

---

## Project Goal
Transform raw ecommerce data into business insights and portfolio-ready SQL analytics projects.

## Day 24 — Data Cleaning + Validation

### Overview
Today focused on preparing clean and analysis-ready ecommerce data using PostgreSQL before starting KPI and business analysis.

### Tasks Completed
- Checked table row counts
- Validated NULL values
- Investigated missing delivery dates
- Checked duplicate records
- Analyzed order status distribution
- Analyzed payment method distribution
- Built cleaned CTE datasets
- Created first analysis-ready JOIN dataset

---

### SQL Concepts Practiced
- COUNT()
- GROUP BY
- HAVING
- IS NULL
- CTE (Common Table Expressions)
- JOIN
- Basic revenue validation

---

### Key Business Insights
- Most orders were successfully delivered
- Credit card was the dominant payment method
- Some orders contained missing delivery dates
- Cancelled orders should be excluded from revenue analysis
- Clean datasets are essential before business reporting

---

### Project Progress
This stage focused on transforming raw ecommerce data into structured and analysis-ready datasets for future KPI dashboards and business intelligence analysis.

## Day 25 — Revenue KPI Analysis

### Overview
Today focused on building core business KPI analysis queries using PostgreSQL and the Brazil Ecommerce (Olist) dataset.

The analysis explored:
- total revenue
- average order value
- monthly revenue trends
- payment method performance
- state-level revenue analysis
- seller revenue performance

---

### Tasks Completed
- Calculated total business revenue
- Calculated average order value
- Analyzed revenue by payment type
- Built monthly revenue trend queries
- Compared revenue by customer state
- Identified top-performing sellers
- Analyzed freight and shipping costs
- Built first KPI-focused CTE queries

---

### SQL Concepts Practiced
- SUM()
- AVG()
- GROUP BY
- ORDER BY
- EXTRACT()
- JOIN
- CTE (Common Table Expressions)
- Revenue aggregation

---

### Key Business Insights
- Credit card payments generated the highest revenue contribution
- Revenue performance varied across months
- Some states contributed significantly higher sales volume
- Seller performance distribution was uneven
- Freight costs represented an important operational expense

---

### Project Progress
This stage focused on transforming raw ecommerce transaction data into business KPI metrics and dashboard-style analytical queries.

---

## Day 26 — Customer Segmentation Analysis (Olist Ecommerce SQL Project)

### Project Progress
Today focused on customer segmentation analysis using PostgreSQL and the Brazil Olist Ecommerce dataset.

### Skills Practiced
- SQL aggregation
- CASE WHEN segmentation
- Customer behavior analysis
- Revenue KPI analysis
- Business insight reporting
- GROUP BY analytics
- Ecommerce customer segmentation

### SQL Concepts Used
- SUM()
- COUNT()
- AVG()
- CASE WHEN
- GROUP BY
- ROUND()
- CTEs

### Business Questions Answered
- Which customer segment generates the highest revenue?
- How many customers belong to each spending category?
- What is the average spending behavior by segment?
- Which customer group provides the best long-term business opportunity?

### Customer Segmentation Logic
Customers were divided into:
- Low Value Customers
- Medium Value Customers
- High Value Customers

based on total customer spending behavior.

### Key Business Insights
- Most ecommerce revenue came from a large number of low-value customers.
- High-value customers represented a small portion of the customer base but generated very high average spending.
- Medium-value customers showed strong potential for upselling opportunities.
- The ecommerce business currently operates on a high-volume customer model.
- Customer retention strategies could significantly improve long-term profitability.

### Tools Used
- PostgreSQL
- VS Code
- pgAdmin
- Olist Brazil Ecommerce Dataset

### Project Progress
This project is part of my 30-Day SQL & Data Analytics Portfolio Challenge focused on building real-world business analysis projects for data analyst roles.

---
## Day 27 — Delivery Performance Analysis (Olist Ecommerce SQL Project)

### Project Progress
Today focused on ecommerce logistics and delivery performance analysis using PostgreSQL and the Olist dataset.

### Skills Practiced
- Delivery KPI analysis
- Operational performance analysis
- Ecommerce logistics analytics
- State-level delivery comparison
- Delivery trend reporting
- SQL aggregation and ranking
- Business insight generation

### SQL Concepts Used
- AVG()
- COUNT()
- CASE WHEN
- FILTER
- EXTRACT()
- RANK()
- CTEs
- JOIN
- Delivery date calculations

### Business Questions Answered
- How long does delivery usually take?
- What percentage of deliveries are late?
- Which states have the slowest delivery performance?
- Which regions show stronger logistics efficiency?
- How does delivery performance change over time?

### Delivery Performance Metrics
- Average delivery days
- Late delivery rate
- On-time vs late delivery comparison
- State-level delivery ranking
- Monthly delivery performance trends

### Key Business Insights
- Delivery performance is one of the most important operational KPIs in ecommerce.
- Some customer regions experienced significantly slower delivery times.
- Late delivery rates can negatively impact customer satisfaction and retention.
- Geographic logistics performance varied across states.
- Faster delivery regions may indicate stronger logistics infrastructure and operational efficiency.

### Tools Used
- PostgreSQL
- pgAdmin
- VS Code
- Olist Brazil Ecommerce Dataset

### Project Progres
This project continues building a portfolio-ready ecommerce business intelligence workflow using SQL and PostgreSQL.

---

## Day 28 — Advanced Revenue Trend Analysis (Olist Ecommerce SQL Project)

### Project Progress
Today focused on advanced trend analysis and dashboard-style KPI reporting using PostgreSQL and the Olist ecommerce dataset.

### Skills Practiced
- Trend analysis
- Revenue growth analysis
- Dashboard-style SQL reporting
- Window function analytics
- Time-series business analysis
- KPI trend reporting
- Business intelligence workflow

### SQL Concepts Used
- SUM() OVER()
- AVG() OVER()
- LAG() OVER()
- LEAD() OVER()
- Running totals
- Rolling averages
- Window functions
- CTEs
- Month-over-month growth calculations

### Business Questions Answered
- How does revenue change month over month?
- Which month had the strongest revenue growth?
- Which month experienced the weakest performance?
- What are the long-term revenue trends?
- How can rolling averages smooth short-term fluctuations?
- How can dashboard-style trend metrics support business decisions?

### Trend Metrics Built
- Monthly revenue
- Running revenue
- Previous month revenue
- Next month revenue
- Month-over-month growth %
- Rolling 3-month average
- Best growth month
- Worst growth month

### Key Business Insights
- Revenue trends varied significantly across different months.
- Running revenue analysis showed cumulative business growth over time.
- Month-over-month growth analysis revealed both strong growth periods and weaker business cycles.
- Rolling averages helped smooth short-term volatility and highlighted broader revenue patterns.
- LEAD and LAG functions enabled easier comparison between historical and future business performance periods.
- Trend analysis is essential for dashboard reporting and executive-level business intelligence.

### Tools Used
- PostgreSQL
- pgAdmin
- VS Code
- Olist Brazil Ecommerce Dataset

### Project Progres
This stage focused on building dashboard-ready SQL outputs and advanced business intelligence reporting workflows.

---

# Day 29 — KPI Export Preparation for Power BI

## Project Focus
Prepared dashboard-ready KPI tables using PostgreSQL for Power BI visualization and executive business reporting.

---

## Objectives
- Transform raw e-commerce data into business-ready KPI outputs
- Build reusable SQL queries for dashboard integration
- Prepare CSV exports for Power BI visualization
- Generate business insights from analytical results

---

# KPI Tables Created

## 1. Monthly Revenue KPI
Generated monthly revenue trends including:
- Total revenue
- Total orders
- Average order value

### Business Purpose
Track overall business growth and seasonal performance trends.

---

## 2. Customer Segment KPI
Built customer segmentation analysis:
- High-value customers
- Medium-value customers
- Low-value customers

### Business Purpose
Support retention strategy and identify upselling opportunities.

---

## 3. Delivery Performance KPI
Created operational delivery metrics:
- Average delivery days
- Late delivery rate
- Delivered order volume

### Business Purpose
Monitor logistics performance and customer satisfaction risks.

---

## 4. State Revenue KPI
Analyzed regional sales performance:
- Revenue by customer state
- Total orders by state
- Average order value by region

### Business Purpose
Identify high-performing regions and support regional business strategy.

---

## 5. Dashboard Summary KPI
Prepared executive KPI summary:
- Total revenue
- Total orders
- Total customers
- Average order value

### Business Purpose
Support executive dashboard overview and decision-making.

---

# CSV Export Workflow

Exported all KPI tables as CSV files for Power BI dashboard integration.

### Exported Files
- monthly_revenue_kpi.csv
- customer_segment_kpi.csv
- delivery_performance_kpi.csv
- state_revenue_kpi.csv
- dashboard_summary_kpi.csv

---

# Key Business Insights

- Revenue trends show fluctuations across the analysis period, indicating potential seasonality.
- Low-value customers contribute the largest total revenue volume due to customer quantity.
- High-value customers generate significantly higher average spending and represent strong retention opportunities.
- Delivery performance remains relatively stable with manageable delay rates.
- Regional sales analysis highlights concentration of revenue in selected states.

---

# Skills Practiced
- PostgreSQL
- CTEs
- Aggregations
- KPI reporting
- Customer segmentation
- Business analytics
- CSV export workflow
- Dashboard preparation
- Business storytelling

---

# Next Step
Build a Power BI executive dashboard using exported KPI tables.

---

## Day 30 — Power BI Dashboard & Portfolio Finalization

### Project Progress
Today focused on transforming SQL KPI outputs into a Power BI dashboard and finalizing the analytics project for portfolio presentation.

### Dashboard Sections
- Executive KPI Summary
- Monthly Revenue Trend
- Customer Segmentation
- Delivery Performance
- State Revenue Analysis

### Tools Used
- PostgreSQL
- Power BI
- CSV Export
- GitHub

### Key Learning
This final step connected SQL analysis with business visualization.
The project now demonstrates a complete analytics workflow from raw ecommerce data to dashboard-ready insights.


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