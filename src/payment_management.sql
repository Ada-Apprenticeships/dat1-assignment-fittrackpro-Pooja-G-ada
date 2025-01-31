-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Payment Management Queries

-- 1. Record a payment for a membership
-- TODO: Write a query to record a payment for a membership

-- -----! DELETE QUERY SO THAT SAME ROW DOES NOT GET ADDED EVERYTIME I RE-RAN THIS SQL FILE!-----
DELETE 
FROM payments 
WHERE member_id = 15 AND payment_date = '2025-01-20 11:00:00';

INSERT INTO payments (member_id, amount, payment_date, payment_method, payment_type)
VALUES (15, 50.00, '2025-01-20 11:00:00', 'Credit Card', 'Monthly membership fee');


-- 2. Calculate total revenue from membership fees for each month of the last year
-- TODO: Write a query to calculate total revenue from membership fees for each month of the current year
SELECT SUM(amount) AS total_revenue_from_membership_fee_of_last_year_2024 
FROM payments
WHERE payment_date LIKE '%2024%';

-- 3. Find all day pass purchases
-- TODO: Write a query to find all day pass purchases
SELECT * 
FROM payments
WHERE payment_type LIKE 'Day Pass';