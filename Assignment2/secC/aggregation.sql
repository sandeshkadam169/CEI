/*
===========================================
Section C - Aggregation
Topics:
- GROUP BY
- COUNT()
- SUM()
- AVG()
- MIN()
- MAX()
===========================================
*/

-- =========================================
-- Q13. Count the number of customers
-- =========================================

SELECT COUNT(*) AS total_customers
FROM customers;

-- =========================================
-- Q14. Calculate total sales amount
-- =========================================

SELECT SUM(total_amount) AS total_sales
FROM orders;

-- =========================================
-- Q15. Calculate average product price
-- =========================================

SELECT AVG(unit_price) AS average_product_price
FROM products;

-- =========================================
-- Q16. Display highest and lowest product price
-- =========================================

SELECT
    MAX(unit_price) AS highest_price,
    MIN(unit_price) AS lowest_price
FROM products;

-- =========================================
-- Q17. Display total sales by order status
-- =========================================

SELECT
    status,
    SUM(total_amount) AS total_sales
FROM orders
GROUP BY status;

-- =========================================
-- Q18. Display total orders placed by each customer
-- =========================================

SELECT
    customer_id,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC;