-- 1. Create customers table
CREATE TABLE IF NOT EXISTS customers (
    customer_id TEXT PRIMARY KEY,
    customer_name TEXT,
    segment TEXT
);

-- 2. Create products table
CREATE TABLE IF NOT EXISTS products (
    product_id TEXT PRIMARY KEY,
    category TEXT,
    sub_category TEXT,
    product_name TEXT
);

-- 3. Create orders table
CREATE TABLE IF NOT EXISTS orders (
    row_id INTEGER PRIMARY KEY,
    order_id TEXT,
    order_date TEXT,
    ship_date TEXT,
    ship_mode TEXT,
    customer_id TEXT,
    product_id TEXT,
    sales REAL,
    quantity INTEGER,
    discount REAL,
    profit REAL,
    country TEXT,
    city TEXT,
    state TEXT,
    postal_code TEXT,
    region TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 4. Populate customers
INSERT OR IGNORE INTO customers (customer_id, customer_name, segment)
SELECT DISTINCT customer_id, customer_name, segment
FROM superstore_raw;

-- 5. Populate products (resolving duplicates of product_id by ignoring already inserted keys)
INSERT OR IGNORE INTO products (product_id, category, sub_category, product_name)
SELECT DISTINCT product_id, category, sub_category, product_name
FROM superstore_raw;

-- 6. Populate orders
INSERT OR IGNORE INTO orders (
    row_id, order_id, order_date, ship_date, ship_mode,
    customer_id, product_id, sales, quantity, discount, profit,
    country, city, state, postal_code, region
)
SELECT DISTINCT 
    row_id, order_id, order_date, ship_date, ship_mode,
    customer_id, product_id, sales, quantity, discount, profit,
    country, city, state, postal_code, region
FROM superstore_raw;
