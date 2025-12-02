<img width="1024" height="573" alt="image" src="https://github.com/user-attachments/assets/e13ef9ad-e30e-4390-af3c-99c2e41df3ea" />


📊 Apple Retail Sales Analysis (1M+ Rows SQL Project)

A comprehensive SQL-based analytics project built using 1 million+ rows of simulated Apple retail sales data. This repository includes complete database schemas, advanced SQL queries, performance tuning, and business insights derived from real-world analytical scenarios.

🗂️ Project Overview

This project demonstrates end-to-end data analysis using SQL, covering data modeling, query optimization, exploratory analysis, business problem-solving, and advanced analytical SQL techniques.
It includes:

Entity Relationship Diagram (ERD)

<img width="1310" height="776" alt="image" src="https://github.com/user-attachments/assets/2e449b2f-bb09-4819-a4a6-7573296d8747" />



Retail store information

Product catalog & categories

Sales transactions

Warranty claims

All datasets are analyzed through optimized SQL to generate meaningful business insights.

🧱 Database Schema Included

The schema file (tables.sql) contains:

The project uses five main tables:

1)stores: Contains information about Apple retail stores.

store_id: Unique identifier for each store.
store_name: Name of the store.
city: City where the store is located.
country: Country of the store.

2)category: Holds product category information.

category_id: Unique identifier for each product category.
category_name: Name of the category.

3)products: Details about Apple products.

product_id: Unique identifier for each product.
product_name: Name of the product.
category_id: References the category table.
launch_date: Date when the product was launched.
price: Price of the product.

4)sales: Stores sales transactions.

sale_id: Unique identifier for each sale.
sale_date: Date of the sale.
store_id: References the store table.
product_id: References the product table.
quantity: Number of units sold.

5)warranty: Contains information about warranty claims.

claim_id: Unique identifier for each warranty claim.
claim_date: Date the claim was made.
sale_id: References the sales table.
repair_status: Status of the warranty claim (e.g.,Completed,Rejected,Pending,Progress).

Each table includes primary keys and foreign keys to maintain relational integrity.

📈 Key Analytics Performed
🔍 Exploratory Data Analysis

Total rows analysis

Distinct claim statuses

Unique product counts

Time-based sales insights

⚡ Query Optimization

Indexed product_id, store_id, sale_date

Reduced query execution times from 60–70ms to <5ms

Used EXPLAIN ANALYZE for tuning

📌 Business Use Case Queries

Store performance across countries

Total units sold per store

Monthly & yearly sales trends

Warranty rejection percentages

Best-selling days by store

Declining and growing product trends

📊 Advanced Analytical SQL

Window functions: RANK, LAG, running totals

CTE-based multi-step analysis

Year-over-year store growth

Warranty risk probability by country

Product lifecycle sales segmentation

Price-range wise warranty correlation

🧠 Complexity Level Coverage

✔️ Beginner Queries – Counts, aggregations, joins
✔️ Intermediate – Trends, grouping, monthly/yearly analysis
✔️ Advanced – Multi-CTE pipelines, window functions, optimization
✔️ Expert-Level – YOY growth ratios, correlation analysis, lifecycle modeling

📜 Files in This Repository
📁 tables.sql

Creates all core tables

Defines schema, keys, relationships

Drops and recreates tables for easy re-run

📁 queries.sql

20+ real-world analytics queries

Performance optimization experiments

Hard & complex business problem solutions

Warranty, sales, pricing, lifecycle analytics

🛠️ Tech Stack

PostgreSQL (recommended)

SQL (CTEs, Window Functions, Joins, Indexing, Aggregations)

🚀 How to Use

Run tables.sql to create the full database schema

Load your data (CSV or ETL pipeline)

Execute queries.sql to explore insights and performance tuning

Modify the queries for your own analysis use cases

🤝 Contributions

Feel free to fork, improve queries, add datasets, or extend analysis areas.


