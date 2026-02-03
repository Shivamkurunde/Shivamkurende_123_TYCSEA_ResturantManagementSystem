-- ============================================
-- SQL Queries Reference for Teacher Demo
-- Restaurant Management System
-- ============================================

-- Run these queries in phpMyAdmin → SQL tab
-- Copy and paste any query to show data

-- ===========================================
-- BASIC QUERIES (शुरुआती queries)
-- ============================================

-- 1. Show all registered users
SELECT * FROM users;

-- 2. Show all cart items
SELECT * FROM cart_items;

-- 3. Show all orders
SELECT * FROM orders;

-- 4. Show all order items
SELECT * FROM order_items;

-- 5. Show all OTPs
SELECT * FROM otps;


-- ============================================
-- ADVANCED QUERIES (Advanced queries)
-- ============================================

-- 6. Show users with their order count
SELECT 
    u.id,
    u.name,
    u.email,
    COUNT(o.id) as total_orders
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id;

-- 7. Show all orders with customer details
SELECT 
    o.id as order_id,
    u.name as customer_name,
    u.email,
    o.total_amount,
    o.status,
    o.phone_number,
    o.created_at
FROM orders o
JOIN users u ON o.user_id = u.id
ORDER BY o.created_at DESC;

-- 8. Show order items with order and customer details
SELECT 
    oi.id,
    o.id as order_id,
    u.name as customer_name,
    oi.item_name,
    oi.item_price,
    oi.quantity,
    (oi.item_price * oi.quantity) as item_total,
    oi.category
FROM order_items oi
JOIN orders o ON oi.order_id = o.id
JOIN users u ON o.user_id = u.id;

-- 9. Show cart items with user details
SELECT 
    c.id,
    u.name as customer_name,
    u.email,
    c.item_name,
    c.item_price,
    c.quantity,
    (c.item_price * c.quantity) as total,
    c.added_at
FROM cart_items c
JOIN users u ON c.user_id = u.id;


-- ============================================
-- STATISTICS QUERIES (आंकड़े दिखाने के लिए)
-- ============================================

-- 10. Total number of users
SELECT COUNT(*) as total_users FROM users;

-- 11. Total number of orders
SELECT COUNT(*) as total_orders FROM orders;

-- 12. Total revenue (all orders)
SELECT SUM(total_amount) as total_revenue FROM orders;

-- 13. Total revenue (excluding cancelled orders)
SELECT SUM(total_amount) as total_revenue 
FROM orders 
WHERE status != 'Cancelled';

-- 14. Orders by status
SELECT 
    status,
    COUNT(*) as order_count,
    SUM(total_amount) as total_amount
FROM orders
GROUP BY status;

-- 15. Most ordered items
SELECT 
    item_name,
    SUM(quantity) as times_ordered,
    SUM(item_price * quantity) as total_revenue
FROM order_items
GROUP BY item_name
ORDER BY times_ordered DESC;

-- 16. Revenue by category
SELECT 
    category,
    COUNT(*) as items_sold,
    SUM(item_price * quantity) as revenue
FROM order_items
GROUP BY category
ORDER BY revenue DESC;

-- 17. Average order value
SELECT AVG(total_amount) as average_order_value FROM orders;

-- 18. Today's orders
SELECT * FROM orders 
WHERE DATE(created_at) = CURDATE();

-- 19. This month's revenue
SELECT SUM(total_amount) as monthly_revenue 
FROM orders 
WHERE MONTH(created_at) = MONTH(CURDATE()) 
AND YEAR(created_at) = YEAR(CURDATE());


-- ============================================
-- SPECIFIC QUERIES (खास जानकारी के लिए)
-- ============================================

-- 20. Pending orders
SELECT 
    o.id,
    u.name,
    o.total_amount,
    o.phone_number,
    o.delivery_address,
    o.created_at
FROM orders o
JOIN users u ON o.user_id = u.id
WHERE o.status = 'Pending'
ORDER BY o.created_at DESC;

-- 21. Delivered orders
SELECT * FROM orders WHERE status = 'Delivered';

-- 22. Cancelled orders
SELECT * FROM orders WHERE status = 'Cancelled';

-- 23. Users who never placed an order
SELECT u.* 
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE o.id IS NULL;

-- 24. Users with items in cart
SELECT DISTINCT u.name, u.email
FROM users u
JOIN cart_items c ON u.id = c.user_id;

-- 25. Top 5 customers by order value
SELECT 
    u.name,
    u.email,
    COUNT(o.id) as total_orders,
    SUM(o.total_amount) as total_spent
FROM users u
JOIN orders o ON u.id = o.user_id
GROUP BY u.id
ORDER BY total_spent DESC
LIMIT 5;


-- ============================================
-- DETAILED REPORT QUERIES (विस्तृत रिपोर्ट)
-- ============================================

-- 26. Complete order details with all items
SELECT 
    o.id as order_id,
    u.name as customer_name,
    u.email,
    u.phone_number as user_phone,
    o.phone_number as delivery_phone,
    o.delivery_address,
    oi.item_name,
    oi.item_price,
    oi.quantity,
    (oi.item_price * oi.quantity) as item_total,
    o.total_amount as order_total,
    o.status,
    o.created_at
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN order_items oi ON o.id = oi.order_id
ORDER BY o.created_at DESC;

-- 27. Daily sales report
SELECT 
    DATE(created_at) as date,
    COUNT(*) as total_orders,
    SUM(total_amount) as daily_revenue
FROM orders
GROUP BY DATE(created_at)
ORDER BY date DESC;

-- 28. Category-wise sales
SELECT 
    oi.category,
    COUNT(DISTINCT o.id) as orders_count,
    SUM(oi.quantity) as items_sold,
    SUM(oi.item_price * oi.quantity) as revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.id
WHERE o.status != 'Cancelled'
GROUP BY oi.category
ORDER BY revenue DESC;


-- ============================================
-- DATA MODIFICATION QUERIES (सावधानी से use करें!)
-- ============================================

-- 29. Update order status (example)
-- UPDATE orders SET status = 'Confirmed' WHERE id = 1;

-- 30. Delete a cart item (example)
-- DELETE FROM cart_items WHERE id = 1;

-- 31. Clear all cart items for a user (example)
-- DELETE FROM cart_items WHERE user_id = 1;


-- ============================================
-- USEFUL QUERIES FOR DEBUGGING
-- ============================================

-- 32. Check database structure
SHOW TABLES;

-- 33. Check table structure
DESCRIBE users;
DESCRIBE cart_items;
DESCRIBE orders;
DESCRIBE order_items;
DESCRIBE otps;

-- 34. Count records in each table
SELECT 'users' as table_name, COUNT(*) as record_count FROM users
UNION ALL
SELECT 'cart_items', COUNT(*) FROM cart_items
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'otps', COUNT(*) FROM otps;


-- ============================================
-- NOTES FOR TEACHER DEMO
-- ============================================

/*
1. Start with basic queries (1-5) to show all data
2. Then show advanced queries (6-9) to demonstrate JOINs
3. Show statistics (10-19) to impress with data analysis
4. Show specific queries (20-25) for practical use cases
5. End with detailed reports (26-28) to show complete system

TIPS:
- Copy one query at a time
- Paste in phpMyAdmin → SQL tab
- Click "Go" button
- Show results to teacher
- Explain what the query does

IMPRESSIVE QUERIES TO SHOW:
- Query 7: Orders with customer details
- Query 15: Most ordered items
- Query 16: Revenue by category
- Query 25: Top 5 customers
- Query 26: Complete order details
*/
