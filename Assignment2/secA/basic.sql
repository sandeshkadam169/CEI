/*
===========================================
Section A - SQL Basics
Topics:
- SELECT
- Primary Key
- Constraints
===========================================
*/

-- =========================================
-- Q1. Display all columns and rows from the customers table
-- =========================================

SELECT *
FROM customers;

-- =========================================
-- Q2. Display first name, last name and city of all customers
-- =========================================

SELECT first_name, last_name, city
FROM customers;

-- =========================================
-- Q3. Display all unique product categories
-- =========================================

SELECT DISTINCT category
FROM products;

-- =========================================
-- Q4. Identify the Primary Key of each table.
-- Explain why a Primary Key must be UNIQUE and NOT NULL.
-- =========================================

/*
Primary Keys

customers      -> customer_id
products       -> product_id
orders         -> order_id
order_items    -> item_id

Explanation:
A Primary Key uniquely identifies each record in a table.
It cannot contain duplicate values or NULL values because
every row must have a unique identifier.
*/

-- =========================================
-- Q5. Constraints on email column
-- =========================================

/*
Constraints Applied:

1. UNIQUE
2. NOT NULL

If a duplicate email is inserted,
MySQL throws a Duplicate Entry error because
the UNIQUE constraint is violated.
*/

-- Example

/*
INSERT INTO customers
VALUES
(
109,
'Rahul',
'Sharma',
'aarav.s@email.com',
'Pune',
'Maharashtra',
'2024-09-01',
TRUE
);
*/

-- =========================================
-- Q6. Insert a product with negative price
-- =========================================

/*
INSERT INTO products
VALUES
(
209,
'Test Product',
'Electronics',
'Test Brand',
-50,
100
);
*/

/*
Expected Result

The insertion fails because of the CHECK constraint:

CHECK (unit_price > 0)

The database does not allow a product price
less than or equal to zero.
*/