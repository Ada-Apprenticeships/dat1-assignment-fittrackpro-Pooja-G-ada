-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Equipment Management Queries

-- =========================================================== [TASK 3.1] ====================================================================================
-- ===========================================================================================================================================================

-- 1. Find equipment due for maintenance
-- TODO: Write a query to find equipment due for maintenance

SELECT '***********  <<< [SQL QUERY RESULT] for 3.1 >>> ***********' AS '--------------------------------------------------'; -- Comment to print on console
--      ***********  <<< [SQL QUERY SOLUTION] for 3.1 >>> *********** 
SELECT 
    equipment_id,
    name,
    next_maintenance_date AS next_maintenance_date_in_next_30_days
FROM equipment
WHERE next_maintenance_date >= DATE('now', '+1 day') -- skip today
   AND next_maintenance_date < DATE('now', '+30 days'); -- 30 days starting tomorrow


-- =========================================================== [TASK 3.2] ====================================================================================
-- ===========================================================================================================================================================

-- 2. Count equipment types in stock
-- TODO: Write a query to count equipment types in stock

SELECT '***********  <<< [SQL QUERY RESULT] for 3.2 >>> ***********' AS '--------------------------------------------------'; -- Comment to print on console
--      ***********  <<< [SQL QUERY SOLUTION] for 3.2 >>> *********** 
SELECT 
    type AS equipment_type, 
    COUNT(*) AS count
FROM equipment
GROUP BY type;


-- =========================================================== [TASK 3.3] ====================================================================================
-- ===========================================================================================================================================================

-- 3. Calculate average age of equipment by type (in days)
-- TODO: Write a query to calculate average age of equipment by type (in days)

SELECT '***********  <<< [SQL QUERY RESULT] for 3.3 >>> ***********' AS '--------------------------------------------------'; -- Comment to print on console
--      ***********  <<< [SQL QUERY SOLUTION] for 3.3 >>> *********** 
SELECT 
    type AS equipment_type,
    -- JULIANDAY() function converts the date to Julian Day numbers (numeric representations of dates)
    -- AVG() function returns the average value of the age/days of the equipment, 
    -- then GROUP BY gets the aevarge by the equipment type
    AVG(JULIANDAY(CURRENT_DATE) - JULIANDAY(purchase_date)) AS avg_age_days -- JULIANDAY() function converts the date to Julian Day numbers (numeric representations of dates)
FROM equipment
GROUP BY type;

-- ===========================================================================================================================================================
-- ===========================================================================================================================================================
