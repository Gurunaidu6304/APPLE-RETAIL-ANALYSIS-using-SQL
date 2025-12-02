-- Apple Sales Project - 1m rows sales datasets
SELECT *FROM category;
SELECT *FROM products;
SELECT *FROM stores;
SELECT *FROM sales;
SELECT *FROM warranty;

-- EDA
SELECT DISTINCT repair_status FROM warranty;
SELECT COUNT(*) FROM sales;

-- Improving Query Performance  or Query optimization

-- et 60.377 ms
-- pt 0.15 ms
-- et after index 5 to 10 ms
EXPLAIN ANALYZE
SELECT *FROM sales
where product_id ='p-44'

CREATE INDEX sales_product_id ON sales(product_id);
CREATE INDEX sales_store_id ON sales(store_id);
CREATE INDEX sales_sale_date ON sales(sale_date);


-- et 74.347 ms
-- pt 0.12 ms
-- et after index 0 to 1 ms
EXPLAIN ANALYZE
SELECT *FROM sales
where store_id ='st-31'

-- Business problem
-- Medium
-- 1)Find the number of stores in each country.

SELECT DISTINCT country,COUNT(store_id) as total_stores
FROM stores
GROUP BY 1
ORDER BY 2 DESC;

-- 2)Calculate the total number of units sold by each store.

SELECT s.store_id,st.store_name,SUM(s.quantity) as total_unit_sold
FROM sales s
JOIN stores st
ON s.store_id=st.store_id
GROUP BY 1,2
ORDER BY 3;


-- 3)Identify how many sales occurred in December 2023.

SELECT COUNT(sale_id) as total_sales 
FROM sales
-- where sale_date > '2023-11-30' AND sale_date <= '2023-12-31';
WHERE TO_CHAR(sale_date, 'MM-YYYY')= '12-2023';

-- 4)Determine how many stores have never had a warranty claim filed.
SELECT COUNT(*) FROM stores 
WHERE store_id NOT IN (
SELECT DISTINCT store_id from sales s
RIGHT JOIN warranty w
ON s.sale_id=w.sale_id);

-- 5)Calculate the percentage of warranty claims marked as "Rejected".

SELECT
     ROUND(
      COUNT(claim_id)/(SELECT COUNT(*) FROM warranty)::numeric * 100,
	   2) as warranty_Reject_perecentage
FROM warranty
WHERE repair_status='Rejected';

-- 6)Identify which store had the highest total units sold in the last year.

SELECT 
  s.store_id,
  st.store_name,
 SUM(s.quantity)
 FROM sales as s
 JOIN stores as st
 ON s.store_id = st.store_id
 WHERE TO_CHAR(s.sale_date,'YYYY')='2024'
 GROUP BY 1,2
 ORDER BY 3 DESC
 LIMIT 1
;

-- 7)Count the number of unique products sold in the last year.

SELECT COUNT(DISTINCT product_id) FROM sales
WHERE TO_CHAR(sale_date,'YYYY')='2024';

-- 8)Find the average price of products in each category.

SELECT p.category_id,c.category_name,AVG(p.price) as AVG_product_price 
FROM products as p
JOIN category as c
ON p.category_id=c.category_id
GROUP BY 1,2
ORDER BY 3 DESC;

-- 9)How many warranty claims were filed in 2024?

SELECT COUNT(*) as warranty_claim FROM warranty
WHERE EXTRACT(YEAR FROM claim_date)='2024';

-- 10)For each store, identify the best-selling day based on highest quantity sold.

SELECT * FROM
 ( SELECT 
    store_id,
	TO_CHAR(sale_date,'Day') as day_name,
	SUM(quantity) as total_units_sold,
	RANK() OVER(PARTITION BY store_id ORDER BY SUM(quantity) DESC ) as rank
	FROM sales
	GROUP BY 1,2 ) as t1 
	WHERE rank=1;

-- Hard Problems

-- 11)Identify the least selling product in each country for each year based on total units sold.
   SELECT FROM  sales as s
   JOIN
   stores as st
   ON s.store_id=st.store_id
   JOIN
   produts

-- 12)Calculate how many warranty claims were filed within 180 days of a product sale.

  SELECT COUNT(*) FROM warranty w
LEFT JOIN
sales s
ON w.sale_id=s.sale_id
WHERE w.claim_date - s.sale_date <= 180;


-- 13)Determine how many warranty claims were filed for products launched in the last two years.
-- no claim
-- no sale

SELECT 
   p.product_name,COUNT(w.claim_id) as no_claim,COUNT(s.sale_id) as no_sale FROM warranty w
JOIN
sales s
ON w.sale_id=s.sale_id
RIGHT JOIN products p
ON p.product_id = s.product_id
WHERE p.launch_date >= CURRENT_DATE - INTERVAL '2 years'
GROUP BY 1
HAVING COUNT(w.claim_id) >0;

-- 14)List the months in the last three years where sales exceeded 19,000 units in the UNITED STATES.

SELECT 
   TO_CHAR(sale_date,'MM-YYYY') as month,
   SUM(s.quantity) as total_unit_sold
   FROM sales s
   JOIN
   stores st
   ON s.store_id=st.store_id
   WHERE st.country='United States' AND s.sale_date >= CURRENT_DATE - INTERVAL '3 years'
   GROUP BY 1
   HAVING SUM(s.quantity)>19000;



-- 15)Identify the product category with the most warranty claims filed in the last two years.

 SELECT c.category_name,COUNT(w.claim_id) as most_warranty_claims FROM warranty w
 LEFT JOIN sales s
 ON w.sale_id=s.sale_id
 JOIN products p
 ON p.product_id=s.product_id
 JOIN category c
 ON c.category_id=p.category_id
 WHERE 
    w.claim_date >= CURRENT_DATE - INTERVAL '2 years'
 GROUP BY 1
 
    


-- complex problems

-- 16)Determine the percentage chance of receiving warranty claims after each purchase for each country.

SELECT country,
       total_unit_sold,
	   total_claims,
	   COALESCE(ROUND(total_claims::numeric/total_unit_sold::numeric * 100,4),0) as risk
	   FROM
(SELECT 
   st.country,
   SUM(s.quantity) as total_unit_sold,
   COUNT(w.claim_id) as total_claims
FROM sales s
JOIN stores st
ON s.store_id=st.store_id
LEFT JOIN 
warranty w
ON w.sale_id=s.sale_id
GROUP BY 1) t1
ORDER BY 4 DESC


-- 17)Analyze the year-by-year growth ratio for each store.

-- each store their yearly sale

WITH yearly_sales
 AS
(SELECT 
     s.store_id,
	 st.store_name,
	 EXTRACT( YEAR FROM sale_date) as year,
     SUM(s.quantity * p.price) as total_sale FROM sales s
JOIN products p
ON s.product_id=p.product_id 
JOIN stores st
ON st.store_id=s.store_id
GROUP BY 1,2,3
ORDER BY 2,3
),
growth_ratio
AS
( 
SELECT 
     store_name,
	 year,
	 LAG(total_sale,1) OVER(PARTITION BY store_name ORDER BY year) as last_year_sale,
	 total_sale as current_year_sale
	 FROM yearly_sales
	 )
 SELECT 
     store_name,
	 year,
	 last_year_sale,
	 current_year_sale,
	 ROUND(
	          (current_year_sale - last_year_sale)::numeric/
			                  last_year_sale:: numeric * 100,3) as growth_ratio
	 FROM growth_ratio
	 WHERE last_year_sale IS NOT NULL
	 AND 
	 YEAR <> EXTRACT(YEAR FROM CURRENT_DATE)

	 



-- 18)Calculate the correlation between product price and warranty claims for products sold in the last five years, segmented by price range.

SELECT 
      CASE 
	     WHEN p.price < 500 THEN 'Less Expensive Product'
		 WHEN p.price BETWEEN 500 AND 1000 THEN 'Mid Range Product'
		 ELSE 'Expensive Product'
	   END as price_segment,
       COUNT(w.claim_id) as total_claim
FROM warranty w
LEFT JOIN sales s
ON w.sale_id=s.sale_id
JOIN products p
ON p.product_id=s.product_id
WHERE w.claim_date >= CURRENT_DATE - INTERVAL'5 year'
GROUP BY 1

-- 19)Identify the store with the highest percentage of "PAID COMPLETED" claims relative to total claims filed.

WITH paid_repair_completed
AS
(SELECT 
     s.store_id,
	 COUNT(w.claim_id) as paid_repair_completed
FROM sales s
RIGHT JOIN
warranty w
ON s.sale_id=w.sale_id
WHERE w.repair_status= 'Completed'
GROUP BY 1
),
total_repaired
AS
(SELECT 
     s.store_id,
	 COUNT(w.claim_id) as total_repaired
FROM sales s
RIGHT JOIN
warranty w
ON s.sale_id=w.sale_id
GROUP BY 1
)
SELECT 
    tr.store_id,
	st.store_name,
	prc.paid_repair_completed,
	tr.total_repaired,
	ROUND(prc.paid_repair_completed::numeric/tr.total_repaired::numeric * 100,3) as percentage_repaired
FROM paid_repair_completed prc
JOIN total_repaired tr
ON prc.store_id=tr.store_id
JOIN stores as st
ON tr.store_id=st.store_id



-- 20)Write a query to calculate the monthly running total of sales for each store over the past four years and compare trends during this period.

WITH monthly_sales
AS
(SELECT 
      s.store_id,
	  EXTRACT(YEAR FROM sale_date) as year,
	  EXTRACT(MONTH FROM sale_date) as month,
	  SUM(p.price * s.quantity) as total_revenue
 FROM sales s
 JOIN
 products p
 ON s.product_id=p.product_id
 GROUP BY 1,2,3
 ORDER BY 1,2,3
 )
 SELECT 
       store_id,
	   month,
	   year,
	   total_revenue,
	   SUM(total_revenue) OVER(PARTITION BY store_id ORDER BY month,year) as running_total
 FROM monthly_sales

-- 21)Analyze product sales trends over time, segmented into key periods: from launch to 6 months, 6-12 months, 12-18 months, and beyond 18 months.

SELECT 
      p.product_name,
	 CASE
	      WHEN s.sale_date BETWEEN p.launch_date AND p.launch_date+ INTERVAL '6 month' THEN '0-6month'
		  WHEN s.sale_date BETWEEN p.launch_date+ INTERVAL '6 month' AND p.launch_date+ INTERVAL '12 month' THEN '6-12month'
		  WHEN s.sale_date BETWEEN p.launch_date+ INTERVAL '12 month' AND p.launch_date+ INTERVAL '18 month' THEN '12-18month'
		  ELSE '18+'
	 END AS plc,
	 SUM(s.quantity) as total_quantity_sale
FROM sales s
JOIN
products p
ON s.product_id=p.product_id
GROUP BY 1,2
ORDER BY 1,3 DESC
