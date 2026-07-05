-- =====================================================================
-- Window Functions Analysis
-- =====================================================================

-- Query 1: Rank all customers by their total sales using ROW_NUMBER() and RANK() to show the difference.
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
    cs.customer_id,
    c.customer_name,
    ROUND(cs.total_sales, 2) AS total_sales,
    ROW_NUMBER() OVER (ORDER BY cs.total_sales DESC) AS sales_row_num,
    RANK() OVER (ORDER BY cs.total_sales DESC) AS sales_rank
FROM 
    customer_sales cs
JOIN 
    customers c ON cs.customer_id = c.customer_id
ORDER BY 
    total_sales DESC
LIMIT 10;


-- Query 2: Partition and rank customers within their respective customer segment by total sales.
-- This uses DENSE_RANK() partitioned by customer segment.
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
    cs.customer_id,
    c.customer_name,
    c.segment,
    ROUND(cs.total_sales, 2) AS total_sales,
    DENSE_RANK() OVER (PARTITION BY c.segment ORDER BY cs.total_sales DESC) AS segment_sales_rank
FROM 
    customer_sales cs
JOIN 
    customers c ON cs.customer_id = c.customer_id
ORDER BY 
    c.segment, 
    segment_sales_rank
LIMIT 15;
