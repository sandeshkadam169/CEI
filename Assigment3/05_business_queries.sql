-- =====================================================================
-- Business Queries using JOINs, CTEs, and Window Functions
-- =====================================================================

-- Query 1: Combined Query (JOIN + CTE + Window Functions)
-- Groups customer sales and ranks them using a window function, joining customer metadata.
WITH customer_sales_rank AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        c.segment,
        SUM(o.sales) AS total_sales,
        RANK() OVER (ORDER BY SUM(o.sales) DESC) AS customer_rank
    FROM 
        customers c
    JOIN 
        orders o ON c.customer_id = o.customer_id
    GROUP BY 
        c.customer_id, c.customer_name, c.segment
)
SELECT 
    customer_name,
    segment,
    ROUND(total_sales, 2) AS total_sales,
    customer_rank
FROM 
    customer_sales_rank
ORDER BY 
    customer_rank;


-- Query 2: Top Customers (Top 10 by total sales)
WITH customer_sales AS (
    SELECT 
        customer_id,
        SUM(sales) AS total_sales
    FROM 
        orders
    GROUP BY 
        customer_id
)
SELECT 
    c.customer_id,
    c.customer_name,
    ROUND(cs.total_sales, 2) AS total_sales
FROM 
    customers c
JOIN 
    customer_sales cs ON c.customer_id = cs.customer_id
ORDER BY 
    cs.total_sales DESC
LIMIT 10;


-- Query 3: Low Customers (Bottom 10 by total sales)
WITH customer_sales AS (
    SELECT 
        customer_id,
        SUM(sales) AS total_sales
    FROM 
        orders
    GROUP BY 
        customer_id
)
SELECT 
    c.customer_id,
    c.customer_name,
    ROUND(cs.total_sales, 2) AS total_sales
FROM 
    customers c
JOIN 
    customer_sales cs ON c.customer_id = cs.customer_id
ORDER BY 
    cs.total_sales ASC
LIMIT 10;


-- Query 4: Single-Order Customers (Customers who have placed only a single distinct order)
WITH customer_orders AS (
    SELECT 
        customer_id,
        COUNT(DISTINCT order_id) AS distinct_order_count
    FROM 
        orders
    GROUP BY 
        customer_id
)
SELECT 
    c.customer_id,
    c.customer_name,
    co.distinct_order_count AS total_orders
FROM 
    customers c
JOIN 
    customer_orders co ON c.customer_id = co.customer_id
WHERE 
    co.distinct_order_count = 1;


-- Query 5: Above-Average Order Total Sales
-- Finds orders where the SUM of sales for that order ID is greater than the average order total across all orders.
WITH order_totals AS (
    SELECT 
        order_id,
        SUM(sales) AS total_sales
    FROM 
        orders
    GROUP BY 
        order_id
),
average_order_value AS (
    SELECT 
        AVG(total_sales) AS avg_sales
    FROM 
        order_totals
)
SELECT 
    ot.order_id,
    ROUND(ot.total_sales, 2) AS total_sales,
    ROUND(aov.avg_sales, 2) AS average_order_sales
FROM 
    order_totals ot
CROSS JOIN 
    average_order_value aov
WHERE 
    ot.total_sales > aov.avg_sales
ORDER BY 
    ot.total_sales DESC
LIMIT 10;
