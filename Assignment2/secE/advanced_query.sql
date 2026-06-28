/*
===========================================
Section E - Advanced SQL
Topics:
- CASE
- ACID Properties
- Transactions
===========================================
*/

-- =========================================
-- Q24. Categorize orders based on total amount
-- =========================================

SELECT
    order_id,
    total_amount,
    CASE
        WHEN total_amount >= 5000 THEN 'High Value'
        WHEN total_amount >= 2000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS order_category
FROM orders
ORDER BY total_amount DESC;

-- =========================================
-- Q25. Count orders by category
-- =========================================

SELECT
    CASE
        WHEN total_amount >= 5000 THEN 'High Value'
        WHEN total_amount >= 2000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS order_category,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_category;

-- =========================================
-- Q26. ACID Properties
-- =========================================

/*
ACID Properties

1. Atomicity
   A transaction is completed entirely or rolled back completely.

2. Consistency
   Data remains valid before and after a transaction.

3. Isolation
   Concurrent transactions do not interfere with each other.

4. Durability
   Once a transaction is committed, the changes are permanently saved.
*/

-- =========================================
-- Q27. Transaction Example
-- =========================================

START TRANSACTION;

UPDATE products
SET stock_qty = stock_qty - 1
WHERE product_id = 201;

-- Check updated value
SELECT *
FROM products
WHERE product_id = 201;

-- Uncomment ONE of the following:

-- COMMIT;

-- ROLLBACK;