/*
===========================================
Section D - Joins & Relationships
Topics:
- INNER JOIN
- LEFT JOIN
- Foreign Keys
===========================================
*/

-- =========================================
-- Q19. Display each order with customer details
-- =========================================

SELECT
    o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    o.total_amount
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id
ORDER BY o.order_id;

-- =========================================
-- Q20. Display all customers and their orders
-- using LEFT JOIN
-- =========================================

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_date,
    o.status
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- =========================================
-- Q21. Display order details with product information
-- =========================================

SELECT
    oi.order_id,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.discount_pct
FROM order_items oi
INNER JOIN products p
ON oi.product_id = p.product_id
ORDER BY oi.order_id, p.product_name;

-- =========================================
-- Q22. Difference between LEFT JOIN and RIGHT JOIN
-- =========================================

/*
LEFT JOIN:
Returns all records from the left table and
matching records from the right table.

Example:
customers LEFT JOIN orders

RIGHT JOIN:
Returns all records from the right table and
matching records from the left table.

Example:
customers RIGHT JOIN orders

FULL OUTER JOIN:
Returns all matching and non-matching rows
from both tables.

Note:
MySQL does not support FULL OUTER JOIN directly.
It can be simulated using LEFT JOIN
UNION
RIGHT JOIN.
*/

-- =========================================
-- Q23. Foreign Key Relationships
-- =========================================

/*
Foreign Keys

orders.customer_id
    references customers.customer_id

order_items.order_id
    references orders.order_id

order_items.product_id
    references products.product_id

If we try:

INSERT INTO orders
VALUES
(1011,999,'2024-09-01','Pending',1000);

MySQL will throw a Foreign Key Constraint Error
because customer_id = 999 does not exist
in the customers table.
*/