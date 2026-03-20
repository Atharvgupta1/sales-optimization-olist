--- Creating Tables

CREATE TABLE sales_data (

    order_id TEXT,
    customer_unique_id TEXT,
    product_id TEXT,

    product_category_name TEXT,
    customer_state TEXT,

    payment_type TEXT,

    price NUMERIC,
    freight_value NUMERIC,
    revenue NUMERIC,
    total_order_value NUMERIC,

    review_score INT,

    order_purchase_timestamp TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,

    delivery_time INT,
    delivery_delay INT,

    order_month TEXT);

-- Row count
SELECT COUNT(*) FROM sales_data;

-- Preview data
SELECT * FROM sales_data LIMIT 5;

--- Revenue Check

SELECT 
    MIN(revenue) AS min_revenue,
    MAX(revenue) AS max_revenue,
    AVG(revenue) AS avg_revenue
FROM sales_data;

--- BUSINESS ANALYSIS QUERIES

-- Top 10 Products by Revenue
SELECT product_id,
       ROUND(SUM(revenue), 2) AS total_revenue
FROM sales_data
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 10;

--- Revenue by Category
SELECT product_category_name,
       ROUND(SUM(revenue), 2) AS total_revenue
FROM sales_data
GROUP BY product_category_name
ORDER BY total_revenue DESC;

-- Top Customers
SELECT customer_unique_id,
       ROUND(SUM(revenue), 2) AS total_spent
FROM sales_data
GROUP BY customer_unique_id
ORDER BY total_spent DESC
LIMIT 10;

-- Payment Method Analysis
SELECT payment_type,
 COUNT(DISTINCT order_id) AS total_orders,
 ROUND(SUM(revenue), 2) AS total_revenue,
 ROUND(AVG(revenue), 2) AS avg_order_value
FROM sales_data
GROUP BY payment_type
ORDER BY total_revenue DESC;

-- Delivery Delay Impact
SELECT CASE WHEN delivery_delay > 0 THEN 'Delayed' ELSE 'On Time'
END AS delivery_status,
    
ROUND(AVG(review_score), 2) AS avg_review,
COUNT(order_id) AS total_orders

FROM sales_data
GROUP BY delivery_status;

-- Review vs Revenue
SELECT review_score,COUNT(order_id) AS total_orders, ROUND(AVG(revenue), 2) AS avg_revenue
FROM sales_data
GROUP BY review_score
ORDER BY review_score;

-- Monthly Revenue Trend
SELECT order_month,
       ROUND(SUM(revenue), 2) AS monthly_revenue
FROM sales_data
GROUP BY order_month
ORDER BY order_month;

-- Rank Top Customers
SELECT customer_unique_id,
       SUM(revenue) AS total_spent,
       RANK() OVER (ORDER BY SUM(revenue) DESC) AS rank
FROM sales_data
GROUP BY customer_unique_id
LIMIT 20;

-- Customer Segmentation
SELECT customer_unique_id, SUM(revenue) AS total_spent, CASE 
      WHEN SUM(revenue) > 1000 THEN 'High Value'
      WHEN SUM(revenue) > 500 THEN 'Medium Value'
      ELSE 'Low Value'
      END AS customer_segment
FROM sales_data
GROUP BY customer_unique_id;

-- Top Products per Category
SELECT product_category_name, product_id,
       SUM(revenue) AS total_revenue,
       RANK() OVER (PARTITION BY product_category_name ORDER BY SUM(revenue) DESC) AS rank
FROM sales_data
GROUP BY product_category_name, product_id;