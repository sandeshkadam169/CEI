/*
===========================================
Section B - Filtering & Optimization
Topics:
- WHERE
- Indexes
- BETWEEN
- Date Filtering
===========================================
*/

-- =========================================
-- Q7. Display all delivered orders
-- =========================================

SELECT *
FROM orders
WHERE status = 'Delivered';

-- =========================================
-- Q8. Display Electronics products with
-- unit price greater than ₹2000
-- =========================================

SELECT *
FROM products
WHERE category = 'Electronics'
AND unit_price > 2000;

-- =========================================
-- Q9. Customers from Maharashtra
-- who joined in 2024
-- =========================================

SELECT *
FROM customers
WHERE state = 'Maharashtra'
AND join_date BETWEEN '2024-01-01' AND '2024-12-31';

-- =========================================
-- Q10. Orders between
-- 2024-08-10 and 2024-08-25
-- excluding cancelled orders
-- =========================================

SELECT *
FROM orders
WHERE order_date BETWEEN '2024-08-10' AND '2024-08-25'
AND status <> 'Cancelled';

-- =========================================
-- Q11. Explain idx_orders_date index
-- =========================================

/*
The idx_orders_date index is created on the
order_date column.

It improves query performance by allowing MySQL
to quickly locate records based on order_date
instead of scanning the entire orders table.

Example Query:
*/

SELECT *
FROM orders
WHERE order_date BETWEEN '2024-08-01' AND '2024-08-31';

-- =========================================
-- Q12. Index-Friendly (SARGable) Query
-- =========================================

/*
The following query is NOT index-friendly:

SELECT *
FROM customers
WHERE YEAR(join_date) = 2024;

Reason:
Applying YEAR() on the indexed column prevents
MySQL from efficiently using the index.

Index-Friendly Query:
*/

SELECT *
FROM customers
WHERE join_date >= '2024-01-01'
AND join_date < '2025-01-01';