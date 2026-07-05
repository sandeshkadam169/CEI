-- =====================================================================
-- Subqueries Analysis
-- =====================================================================

-- Query 1: Find all order items where the sales amount is above the overall average sales.
-- This uses a subquery to compute the overall average sales.
SELECT 
    order_id, 
    customer_id, 
    product_id, 
    sales
FROM 
    orders
WHERE 
    sales > (SELECT AVG(sales) FROM orders)
ORDER BY 
    sales DESC
LIMIT 10; -- Limited to top 10 for display purposes in queries, but runner will retrieve full counts.


-- Query 2: Find the highest single-item sale record (highest line-item sales) for each customer.
-- This uses a correlated subquery to identify the maximum sale for each customer.
SELECT 
    o1.customer_id, 
    o1.order_id, 
    o1.product_id, 
    o1.sales
FROM 
    orders o1
WHERE 
    o1.sales = (
        SELECT MAX(o2.sales)
        FROM orders o2
        WHERE o2.customer_id = o1.customer_id
    )
ORDER BY 
    o1.sales DESC
LIMIT 10; -- Limited to top 10 for quick preview, runner will show count and sample.
