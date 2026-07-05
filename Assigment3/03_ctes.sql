-- =====================================================================
-- Common Table Expressions (CTEs) Analysis
-- =====================================================================

-- Query: Use a CTE to compute aggregations (total sales, total orders, total quantity) per customer.
-- This groups orders by customer_id in a CTE, then joins with the customers table for names and segments.
WITH customer_aggregates AS (
    SELECT 
        customer_id, 
        SUM(sales) AS total_sales,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(quantity) AS total_items
    FROM 
        orders
    GROUP BY 
        customer_id
)
SELECT 
    ca.customer_id,
    c.customer_name,
    c.segment,
    ROUND(ca.total_sales, 2) AS total_sales,
    ca.total_orders,
    ca.total_items
FROM 
    customer_aggregates ca
JOIN 
    customers c ON ca.customer_id = c.customer_id
ORDER BY 
    total_sales DESC
LIMIT 10;
