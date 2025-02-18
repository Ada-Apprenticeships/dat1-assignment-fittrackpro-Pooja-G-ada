-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Payment Management Queries

-- =========================================================== [TASK 2.1] ====================================================================================
-- ===========================================================================================================================================================

-- 1. Record a payment for a membership
-- TODO: Write a query to record a payment for a membership

--------! [MY OWN TESTING QUERY] for 2.1: DELETE QUERY SO THAT SAME ROW DOES NOT GET ADDED/DUPLICATED EVERYTIME I RE-RAN THIS SQL FILE !----------
DELETE 
FROM payments 
WHERE member_id = 11 AND payment_date = CURRENT_TIMESTAMP;


--      *********** <<< [SQL QUERY SOLUTION] for 2.1 >>> *********** 
INSERT INTO payments (member_id, amount, payment_date, payment_method, payment_type)
VALUES (11, 50.00, CURRENT_TIMESTAMP, 'Credit Card', 'Monthly membership fee');


SELECT '----- [MY OWN TESTING RESULT] for 2.1 ----- ' AS '--------------------------------------------------'; -- Comment to print on console
--  --------! [MY OWN TESTING QUERY] for 2.1: TO CHECK IF THE NEW RECORD IS ADDED !----------
SELECT * 
FROM payments 
ORDER BY payment_date DESC
LIMIT 1;

-- Print separator between queries for terminal output
SELECT '' AS '--------------------------------------------------';


-- =========================================================== [TASK 2.2] ====================================================================================
-- ===========================================================================================================================================================

-- 2. Calculate total revenue from membership fees for each month of the last year
-- TODO: Write a query to calculate total revenue from membership fees for each month of the current year

SELECT '*********** <<< [SQL QUERY RESULT] for 2.2 >>> *********** ' AS '---------------------------------------------------'; -- Comment to print on console
--      **********  <<< [SQL QUERY SOLUTION] for 2.2 >>>  ***********
--      **********  <<< last year mean 2024 >>>  ***********

SELECT 
    strftime('%Y-%m', payment_date) AS month, --extracts the year and month from the payment_date column. The format string '%Y-%m' returns the year and month in YYYY-MM format.
    SUM(amount) AS total_revenue
FROM payments
WHERE payment_date LIKE '%2024%'
GROUP BY month
ORDER BY month;

-- Print separator between queries for terminal output
SELECT '' AS '--------------------------------------------------';


-- =========================================================== [TASK 2.3] ====================================================================================
-- ===========================================================================================================================================================

-- 3. Find all day pass purchases
-- TODO: Write a query to find all day pass purchases

SELECT '*********** <<< [SQL QUERY RESULT] for 2.3 >>> *********** ' AS '---------------------------------------------------'; -- Comment to print on console
--      **********  <<< [SQL QUERY SOLUTION] for 2.3 >>>  ***********
SELECT 
    payment_id,
    amount,
    payment_date,
    payment_method
FROM payments
WHERE payment_type LIKE 'Day Pass';

-- ===========================================================================================================================================================
-- ===========================================================================================================================================================
