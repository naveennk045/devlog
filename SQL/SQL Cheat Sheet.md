# Complete SQL Cheat Sheet - E-Commerce Database

## Database Schema

```sql
-- Sample E-Commerce Database Schema
CREATE DATABASE ecommerce;

-- Users Table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(15),
    registration_date DATE,
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active'
);

-- Categories Table
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    parent_id INT,
    description TEXT,
    FOREIGN KEY (parent_id) REFERENCES categories(category_id)
);

-- Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(200) NOT NULL,
    category_id INT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    description TEXT,
    brand VARCHAR(100),
    created_date DATE,
    status ENUM('active', 'discontinued') DEFAULT 'active',
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2),
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    shipping_address TEXT,
    payment_method ENUM('credit_card', 'debit_card', 'paypal', 'cash_on_delivery'),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Order Items Table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) AS (quantity * unit_price),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Reviews Table
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    user_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
```

---

## Level 1: SQL Basics

### SELECT Basics

```sql
-- Basic SELECT
SELECT * FROM products;
SELECT product_name, price FROM products;

-- SELECT with aliases
SELECT product_name AS name, price AS cost FROM products;
SELECT p.product_name, p.price FROM products p;
```

### WHERE Clause

```sql
-- Basic filtering
SELECT * FROM products WHERE price > 100;
SELECT * FROM products WHERE category_id = 1;
SELECT * FROM products WHERE status = 'active';

-- Multiple conditions
SELECT * FROM products WHERE price BETWEEN 50 AND 200;
SELECT * FROM products WHERE brand IN ('Apple', 'Samsung', 'Sony');
SELECT * FROM products WHERE product_name LIKE '%phone%';
SELECT * FROM products WHERE price > 100 AND stock_quantity > 0;
SELECT * FROM products WHERE brand = 'Apple' OR brand = 'Samsung';

-- NULL handling
SELECT * FROM products WHERE description IS NOT NULL;
SELECT * FROM products WHERE description IS NULL;
```

### ORDER BY

```sql
-- Single column sorting
SELECT * FROM products ORDER BY price;
SELECT * FROM products ORDER BY price DESC;

-- Multiple column sorting
SELECT * FROM products ORDER BY category_id, price DESC;
SELECT * FROM users ORDER BY last_name, first_name;
```

### LIMIT

```sql
-- Basic limit
SELECT * FROM products LIMIT 10;
SELECT * FROM products ORDER BY price DESC LIMIT 5;

-- LIMIT with OFFSET
SELECT * FROM products LIMIT 10 OFFSET 20;
SELECT * FROM products ORDER BY created_date DESC LIMIT 5 OFFSET 10;
```

### Aggregate Functions

```sql
-- COUNT
SELECT COUNT(*) FROM products;
SELECT COUNT(DISTINCT category_id) FROM products;
SELECT COUNT(*) as total_products FROM products WHERE status = 'active';

-- SUM
SELECT SUM(price) FROM products;
SELECT SUM(total_amount) FROM orders WHERE status = 'delivered';

-- AVG
SELECT AVG(price) FROM products;
SELECT AVG(rating) FROM reviews;

-- MAX/MIN
SELECT MAX(price) FROM products;
SELECT MIN(registration_date) FROM users;
SELECT MAX(order_date), MIN(order_date) FROM orders;
```

### GROUP BY

```sql
-- Basic grouping
SELECT category_id, COUNT(*) FROM products GROUP BY category_id;
SELECT brand, AVG(price) FROM products GROUP BY brand;
SELECT status, COUNT(*) FROM orders GROUP BY status;

-- Multiple columns
SELECT category_id, brand, COUNT(*) 
FROM products 
GROUP BY category_id, brand;

-- With calculations
SELECT user_id, COUNT(*) as order_count, SUM(total_amount) as total_spent
FROM orders 
GROUP BY user_id;
```

### HAVING

```sql
-- Filter groups
SELECT category_id, COUNT(*) as product_count
FROM products 
GROUP BY category_id 
HAVING COUNT(*) > 5;

SELECT brand, AVG(price) as avg_price
FROM products 
GROUP BY brand 
HAVING AVG(price) > 500;

SELECT user_id, COUNT(*) as order_count
FROM orders 
GROUP BY user_id 
HAVING COUNT(*) >= 3;
```

---

## Level 2: Joins

### INNER JOIN

```sql
-- Basic inner join
SELECT p.product_name, c.category_name, p.price
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id;

-- Multiple table join
SELECT u.username, o.order_date, p.product_name, oi.quantity
FROM users u
INNER JOIN orders o ON u.user_id = o.user_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id;
```

### LEFT JOIN

```sql
-- Show all categories, even without products
SELECT c.category_name, COUNT(p.product_id) as product_count
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name;

-- Users with their order count (including users with no orders)
SELECT u.username, COUNT(o.order_id) as order_count
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username;
```

### RIGHT JOIN

```sql
-- All products with their categories (if category exists)
SELECT p.product_name, c.category_name
FROM categories c
RIGHT JOIN products p ON c.category_id = p.category_id;
```

### FULL JOIN

```sql
-- MySQL doesn't support FULL JOIN directly, use UNION
SELECT u.username, o.order_id
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
UNION
SELECT u.username, o.order_id
FROM users u
RIGHT JOIN orders o ON u.user_id = o.user_id;
```

### Self Join

```sql
-- Find subcategories with their parent categories
SELECT c1.category_name as subcategory, c2.category_name as parent_category
FROM categories c1
INNER JOIN categories c2 ON c1.parent_id = c2.category_id;

-- Find users who registered on the same date
SELECT u1.username as user1, u2.username as user2, u1.registration_date
FROM users u1
INNER JOIN users u2 ON u1.registration_date = u2.registration_date 
WHERE u1.user_id < u2.user_id;
```

### Cross Join

```sql
-- All possible product-user combinations (usually not practical)
SELECT u.username, p.product_name
FROM users u
CROSS JOIN products p
LIMIT 20;
```

---

## Level 3: Subqueries

### Scalar Subqueries

```sql
-- Products with price above average
SELECT product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- Users who spent more than average
SELECT u.username, 
       (SELECT SUM(total_amount) FROM orders WHERE user_id = u.user_id) as total_spent
FROM users u
WHERE (SELECT SUM(total_amount) FROM orders WHERE user_id = u.user_id) > 
      (SELECT AVG(total_amount) FROM orders);
```

### Correlated Subqueries

```sql
-- Products that are the most expensive in their category
SELECT p1.product_name, p1.price, p1.category_id
FROM products p1
WHERE p1.price = (
    SELECT MAX(p2.price) 
    FROM products p2 
    WHERE p2.category_id = p1.category_id
);

-- Users with above-average order amounts
SELECT u.username
FROM users u
WHERE (SELECT AVG(o.total_amount) FROM orders o WHERE o.user_id = u.user_id) > 
      (SELECT AVG(total_amount) FROM orders);
```

### IN Operator

```sql
-- Products in specific categories
SELECT * FROM products 
WHERE category_id IN (SELECT category_id FROM categories WHERE category_name LIKE '%Electronics%');

-- Users who have placed orders
SELECT * FROM users 
WHERE user_id IN (SELECT DISTINCT user_id FROM orders);

-- Products that have been ordered
SELECT * FROM products 
WHERE product_id IN (SELECT DISTINCT product_id FROM order_items);
```

### EXISTS

```sql
-- Users who have placed at least one order
SELECT u.username, u.email
FROM users u
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.user_id = u.user_id);

-- Products that have reviews
SELECT p.product_name
FROM products p
WHERE EXISTS (SELECT 1 FROM reviews r WHERE r.product_id = p.product_id);
```

### NOT EXISTS

```sql
-- Users who haven't placed any orders
SELECT u.username, u.email
FROM users u
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.user_id = u.user_id);

-- Products without any reviews
SELECT p.product_name
FROM products p
WHERE NOT EXISTS (SELECT 1 FROM reviews r WHERE r.product_id = p.product_id);
```

---

## Level 4: Advanced SQL

### CASE Statements

```sql
-- Product price categories
SELECT product_name, price,
    CASE 
        WHEN price < 50 THEN 'Budget'
        WHEN price BETWEEN 50 AND 200 THEN 'Mid-range'
        WHEN price > 200 THEN 'Premium'
        ELSE 'Unknown'
    END as price_category
FROM products;

-- Order status summary
SELECT order_id, status,
    CASE status
        WHEN 'pending' THEN 'Waiting for processing'
        WHEN 'processing' THEN 'Being prepared'
        WHEN 'shipped' THEN 'On the way'
        WHEN 'delivered' THEN 'Completed'
        ELSE 'Unknown status'
    END as status_description
FROM orders;
```

### Conditional Functions (MySQL specific)

```sql
-- IF function
SELECT product_name, stock_quantity,
    IF(stock_quantity > 0, 'In Stock', 'Out of Stock') as availability
FROM products;

-- IFNULL
SELECT product_name, IFNULL(description, 'No description available') as description
FROM products;

-- COALESCE (works across different SQL databases)
SELECT product_name, COALESCE(description, brand, 'No info available') as info
FROM products;
```

### Window Functions

```sql
-- ROW_NUMBER
SELECT product_name, price, category_id,
    ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) as price_rank
FROM products;

-- RANK and DENSE_RANK
SELECT product_name, price,
    RANK() OVER (ORDER BY price DESC) as price_rank,
    DENSE_RANK() OVER (ORDER BY price DESC) as dense_price_rank
FROM products;

-- Running totals
SELECT order_id, order_date, total_amount,
    SUM(total_amount) OVER (ORDER BY order_date) as running_total
FROM orders
ORDER BY order_date;

-- Moving averages
SELECT product_id, created_date, price,
    AVG(price) OVER (ORDER BY created_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as moving_avg
FROM products
ORDER BY created_date;
```

### Common Table Expressions (CTE)

```sql
-- Basic CTE
WITH expensive_products AS (
    SELECT * FROM products WHERE price > 500
)
SELECT ep.product_name, c.category_name
FROM expensive_products ep
JOIN categories c ON ep.category_id = c.category_id;

-- Multiple CTEs
WITH category_stats AS (
    SELECT category_id, COUNT(*) as product_count, AVG(price) as avg_price
    FROM products
    GROUP BY category_id
),
top_categories AS (
    SELECT * FROM category_stats WHERE product_count > 5
)
SELECT c.category_name, tc.product_count, tc.avg_price
FROM top_categories tc
JOIN categories c ON tc.category_id = c.category_id;

-- Recursive CTE (for hierarchical data)
WITH RECURSIVE category_hierarchy AS (
    -- Base case: root categories
    SELECT category_id, category_name, parent_id, 0 as level
    FROM categories
    WHERE parent_id IS NULL
    
    UNION ALL
    
    -- Recursive case: child categories
    SELECT c.category_id, c.category_name, c.parent_id, ch.level + 1
    FROM categories c
    JOIN category_hierarchy ch ON c.parent_id = ch.category_id
)
SELECT * FROM category_hierarchy ORDER BY level, category_name;
```

---

## Level 5: DDL & DML

### CREATE Operations

```sql
-- Create table with constraints
CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('active', 'inactive') DEFAULT 'active'
);

-- Create table with foreign keys
CREATE TABLE product_suppliers (
    product_id INT,
    supplier_id INT,
    supply_price DECIMAL(10,2),
    PRIMARY KEY (product_id, supplier_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) ON DELETE CASCADE
);
```

### ALTER Operations

```sql
-- Add column
ALTER TABLE products ADD COLUMN weight DECIMAL(5,2);
ALTER TABLE users ADD COLUMN last_login DATETIME;

-- Modify column
ALTER TABLE products MODIFY COLUMN description TEXT;
ALTER TABLE users MODIFY COLUMN phone VARCHAR(20);

-- Drop column
ALTER TABLE products DROP COLUMN weight;

-- Add constraint
ALTER TABLE products ADD CONSTRAINT chk_price CHECK (price > 0);
ALTER TABLE reviews ADD CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES users(user_id);

-- Drop constraint
ALTER TABLE products DROP CONSTRAINT chk_price;
```

### DROP Operations

```sql
-- Drop table
DROP TABLE IF EXISTS product_suppliers;

-- Drop database
DROP DATABASE IF EXISTS test_db;

-- Drop index
DROP INDEX idx_product_name ON products;
```

### INSERT Operations

```sql
-- Single row insert
INSERT INTO categories (category_name, description) 
VALUES ('Electronics', 'Electronic devices and gadgets');

-- Multiple rows insert
INSERT INTO categories (category_name, parent_id, description) VALUES
('Smartphones', 1, 'Mobile phones and accessories'),
('Laptops', 1, 'Portable computers'),
('Tablets', 1, 'Tablet computers');

-- Insert from another table
INSERT INTO archived_orders (order_id, user_id, order_date, total_amount)
SELECT order_id, user_id, order_date, total_amount
FROM orders
WHERE order_date < '2023-01-01';

-- Insert with ON DUPLICATE KEY UPDATE
INSERT INTO products (product_name, price, stock_quantity)
VALUES ('iPhone 14', 999.99, 50)
ON DUPLICATE KEY UPDATE price = VALUES(price), stock_quantity = VALUES(stock_quantity);
```

### UPDATE Operations

```sql
-- Basic update
UPDATE products SET price = 899.99 WHERE product_id = 1;

-- Update multiple columns
UPDATE users 
SET first_name = 'John', last_name = 'Doe', phone = '123-456-7890'
WHERE user_id = 1;

-- Update with JOIN
UPDATE products p
JOIN categories c ON p.category_id = c.category_id
SET p.status = 'discontinued'
WHERE c.category_name = 'Old Electronics';

-- Conditional update
UPDATE products 
SET status = CASE 
    WHEN stock_quantity = 0 THEN 'out_of_stock'
    WHEN stock_quantity < 10 THEN 'low_stock'
    ELSE 'in_stock'
END;
```

### DELETE Operations

```sql
-- Basic delete
DELETE FROM reviews WHERE rating < 2;

-- Delete with JOIN
DELETE p FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Discontinued';

-- Delete with subquery
DELETE FROM users 
WHERE user_id NOT IN (SELECT DISTINCT user_id FROM orders WHERE user_id IS NOT NULL);
```

### TRUNCATE vs DELETE

```sql
-- TRUNCATE (faster, resets auto-increment, can't use WHERE)
TRUNCATE TABLE temp_data;

-- DELETE (slower, preserves auto-increment, can use WHERE)
DELETE FROM temp_data;
```

---

## Level 6: Indexes, Views, and Triggers

### Indexes

```sql
-- Create single column index
CREATE INDEX idx_product_name ON products(product_name);
CREATE INDEX idx_user_email ON users(email);

-- Create composite index
CREATE INDEX idx_order_user_date ON orders(user_id, order_date);
CREATE INDEX idx_product_category_price ON products(category_id, price);

-- Create unique index
CREATE UNIQUE INDEX idx_username ON users(username);

-- Show indexes
SHOW INDEX FROM products;

-- Drop index
DROP INDEX idx_product_name ON products;
```

### Views

```sql
-- Simple view
CREATE VIEW active_products AS
SELECT product_id, product_name, price, stock_quantity
FROM products
WHERE status = 'active';

-- Complex view with joins
CREATE VIEW order_summary AS
SELECT 
    o.order_id,
    u.username,
    o.order_date,
    o.total_amount,
    o.status,
    COUNT(oi.order_item_id) as item_count
FROM orders o
JOIN users u ON o.user_id = u.user_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, u.username, o.order_date, o.total_amount, o.status;

-- View with aggregations
CREATE VIEW category_performance AS
SELECT 
    c.category_name,
    COUNT(p.product_id) as product_count,
    AVG(p.price) as avg_price,
    SUM(COALESCE(oi.quantity, 0)) as total_sold
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY c.category_id, c.category_name;

-- Use views
SELECT * FROM active_products WHERE price > 100;
SELECT * FROM order_summary WHERE order_date >= '2024-01-01';

-- Update through view (if updatable)
UPDATE active_products SET price = price * 1.1 WHERE price < 50;

-- Drop view
DROP VIEW IF EXISTS active_products;
```

### Triggers

```sql
-- Before INSERT trigger
DELIMITER //
CREATE TRIGGER before_product_insert
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    IF NEW.price < 0 THEN
        SET NEW.price = 0;
    END IF;
    SET NEW.created_date = CURDATE();
END//
DELIMITER ;

-- After UPDATE trigger (audit trail)
CREATE TABLE product_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    old_price DECIMAL(10,2),
    new_price DECIMAL(10,2),
    changed_by VARCHAR(100),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER after_product_price_update
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
    IF OLD.price != NEW.price THEN
        INSERT INTO product_audit (product_id, old_price, new_price, changed_by)
        VALUES (NEW.product_id, OLD.price, NEW.price, USER());
    END IF;
END//
DELIMITER ;

-- Before DELETE trigger
DELIMITER //
CREATE TRIGGER before_user_delete
BEFORE DELETE ON users
FOR EACH ROW
BEGIN
    -- Archive user data before deletion
    INSERT INTO deleted_users (user_id, username, email, deletion_date)
    VALUES (OLD.user_id, OLD.username, OLD.email, NOW());
END//
DELIMITER ;

-- Show triggers
SHOW TRIGGERS;

-- Drop trigger
DROP TRIGGER IF EXISTS before_product_insert;
```

---

## Level 7: Real-World Scenarios & Query Optimization

### Complex Business Queries

#### Top Selling Products

```sql
-- Top 10 best-selling products with revenue
SELECT 
    p.product_name,
    SUM(oi.quantity) as total_sold,
    SUM(oi.total_price) as total_revenue,
    AVG(r.rating) as avg_rating
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
LEFT JOIN reviews r ON p.product_id = r.product_id
WHERE o.status = 'delivered'
GROUP BY p.product_id, p.product_name
ORDER BY total_sold DESC
LIMIT 10;
```

#### Customer Lifetime Value

```sql
-- Customer lifetime value analysis
WITH customer_metrics AS (
    SELECT 
        u.user_id,
        u.username,
        u.registration_date,
        COUNT(o.order_id) as total_orders,
        SUM(o.total_amount) as total_spent,
        AVG(o.total_amount) as avg_order_value,
        MAX(o.order_date) as last_order_date,
        DATEDIFF(CURDATE(), u.registration_date) as days_since_registration
    FROM users u
    LEFT JOIN orders o ON u.user_id = o.user_id
    WHERE o.status IN ('delivered', 'shipped')
    GROUP BY u.user_id, u.username, u.registration_date
),
customer_segments AS (
    SELECT *,
        CASE 
            WHEN total_spent > 1000 AND total_orders > 5 THEN 'VIP'
            WHEN total_spent > 500 AND total_orders > 3 THEN 'Premium'
            WHEN total_spent > 100 AND total_orders > 1 THEN 'Regular'
            ELSE 'New'
        END as customer_segment
    FROM customer_metrics
)
SELECT 
    customer_segment,
    COUNT(*) as customer_count,
    AVG(total_spent) as avg_lifetime_value,
    AVG(total_orders) as avg_orders_per_customer
FROM customer_segments
GROUP BY customer_segment
ORDER BY avg_lifetime_value DESC;
```

#### Monthly Sales Report

```sql
-- Monthly sales performance
SELECT 
    YEAR(o.order_date) as year,
    MONTH(o.order_date) as month,
    MONTHNAME(o.order_date) as month_name,
    COUNT(DISTINCT o.order_id) as total_orders,
    COUNT(DISTINCT o.user_id) as unique_customers,
    SUM(o.total_amount) as total_revenue,
    AVG(o.total_amount) as avg_order_value,
    SUM(oi.quantity) as total_items_sold
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'delivered'
    AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
GROUP BY YEAR(o.order_date), MONTH(o.order_date)
ORDER BY year DESC, month DESC;
```

#### Product Recommendation Query

```sql
-- Products frequently bought together
SELECT 
    p1.product_name as product_a,
    p2.product_name as product_b,
    COUNT(*) as times_bought_together
FROM order_items oi1
JOIN order_items oi2 ON oi1.order_id = oi2.order_id AND oi1.product_id < oi2.product_id
JOIN products p1 ON oi1.product_id = p1.product_id
JOIN products p2 ON oi2.product_id = p2.product_id
GROUP BY oi1.product_id, oi2.product_id, p1.product_name, p2.product_name
HAVING COUNT(*) >= 3
ORDER BY times_bought_together DESC;
```

### Query Optimization Techniques

#### Performance Tips

```sql
-- 1. Use EXPLAIN to analyze query execution
EXPLAIN SELECT * FROM products WHERE price > 100;

-- 2. Index commonly filtered columns
CREATE INDEX idx_price ON products(price);
CREATE INDEX idx_status ON orders(status);
CREATE INDEX idx_user_date ON orders(user_id, order_date);

-- 3. Avoid SELECT * in production
-- Bad
SELECT * FROM products WHERE category_id = 1;

-- Good
SELECT product_id, product_name, price FROM products WHERE category_id = 1;

-- 4. Use LIMIT for large result sets
SELECT product_name, price 
FROM products 
ORDER BY price DESC 
LIMIT 10;

-- 5. Use EXISTS instead of IN for subqueries when possible
-- Less efficient
SELECT * FROM users 
WHERE user_id IN (SELECT user_id FROM orders);

-- More efficient
SELECT * FROM users u
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.user_id = u.user_id);
```

#### Partitioning Example

```sql
-- Partition orders table by year
CREATE TABLE orders_partitioned (
    order_id INT AUTO_INCREMENT,
    user_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled'),
    PRIMARY KEY (order_id, order_date)
) PARTITION BY RANGE (YEAR(order_date)) (
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);
```

### Sample Data for Testing

```sql
-- Insert sample data
INSERT INTO categories (category_name, description) VALUES
('Electronics', 'Electronic devices'),
('Clothing', 'Apparel and accessories'),
('Books', 'Books and literature'),
('Home & Garden', 'Home improvement items');

INSERT INTO users (username, email, first_name, last_name, registration_date) VALUES
('john_doe', 'john@email.com', 'John', 'Doe', '2024-01-15'),
('jane_smith', 'jane@email.com', 'Jane', 'Smith', '2024-02-20'),
('bob_wilson', 'bob@email.com', 'Bob', 'Wilson', '2024-03-10');

INSERT INTO products (product_name, category_id, price, stock_quantity, brand) VALUES
('iPhone 14', 1, 999.99, 25, 'Apple'),
('Samsung Galaxy S23', 1, 899.99, 30, 'Samsung'),
('MacBook Pro', 1, 1999.99, 15, 'Apple'),
('Nike Running Shoes', 2, 129.99, 50, 'Nike'),
('Programming Book', 3, 49.99, 100, 'TechBooks');
```

## Quick Reference Commands

### Database Operations

```sql
SHOW DATABASES;
USE database_name;
SHOW TABLES;
DESCRIBE table_name;
SHOW CREATE TABLE table_name;
```

### Data Types (MySQL)

- **Numeric**: INT, BIGINT, DECIMAL(p,s), FLOAT, DOUBLE
- **String**: VARCHAR(n), CHAR(n), TEXT, LONGTEXT
- **Date/Time**: DATE, TIME, DATETIME, TIMESTAMP
- **Others**: BOOLEAN, ENUM, JSON

### Common Functions

```sql
-- String functions
CONCAT(str1, str2), SUBSTRING(str, start, length), UPPER(str), LOWER(str)

-- Date functions
NOW(), CURDATE(), CURTIME(), DATE_ADD(date, INTERVAL n DAY)

-- Numeric functions
ROUND(n, decimals), CEILING(n), FLOOR(n), ABS(n)

-- Conditional functions
IF(condition, true_value, false_value), COALESCE(val1, val2, ...)
```

This cheat sheet covers all the essential SQL concepts with practical examples using a realistic e-commerce database. Practice these queries and modify them to understand how different SQL features work together!