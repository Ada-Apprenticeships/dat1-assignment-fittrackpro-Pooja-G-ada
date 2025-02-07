-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Attendance Tracking Queries

-- ================================================================================================
-- 1. Record a member's gym visit
-- TODO: Write a query to record a member's gym visit

--------! [MY OWN TESTING]: 1.1. DELETE QUERY SO THAT SAME ROW DOES NOT GET ADDED/DUPLICATED EVERYTIME I RE-RAN THIS SQL FILE!-----
DELETE 
FROM attendance
WHERE member_id = 7 AND location_id = 1;

-------- *****  [MAIN QUERY/FINAL SOLUTION]: 1.2. Insert a new attendance record for member with ID 7 at Downtown Fitness ***** ----------
INSERT INTO attendance (member_id, location_id)
VALUES (7, 1);

-- -----! [MY OWN TESTING]: 1.3. DISPLAYS THE NEW RECORD ADDED !-----
SELECT * 
FROM attendance
ORDER BY check_in_time DESC
LIMIT 1;


-- ================================================================================================
-- 2. Retrieve a member's attendance history
-- TODO: Write a query to retrieve a member's attendance history

--------! attendance history for member with ID 5 !----------
SELECT
    strftime('%Y-%m-%d', check_in_time) AS visit_date, --extracts year, month and date in YYYY-MM-DD FORMAT.
    check_in_time,
    check_out_time
FROM attendance
WHERE member_id = 5;


-- ================================================================================================
-- 3. Find the busiest day of the week based on gym visits
-- TODO: Write a query to find the busiest day of the week based on gym visits

--------! Identify the busiest day of the week based on gym visits !----------
SELECT
    -- to get date as day of the week
    -- Use CASE to name to display full day name
    CASE strftime('%w', check_in_time)
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END AS day_of_week,
    COUNT(*) AS visit_count
FROM attendance
GROUP BY day_of_week
ORDER BY visit_count DESC
LIMIT 1;
    

-- ================================================================================================
-- 4. Calculate the average daily attendance for each location
-- TODO: Write a query to calculate the average daily attendance for each location

--------! [MY OWN TESTING]: 4.1. SUB QUERY TO FIND daily_count COLUMN WHICH COUNTS VISITS GROUPED BY DATE & LOCATION !----------
SELECT 
        location_id, 
        strftime('%Y-%m-%d', check_in_time) AS check_in_date, 
        COUNT(*) AS daily_count
FROM attendance
GROUP BY location_id, check_in_date

-------- *****  [MAIN QUERY/FINAL SOLUTION]: 4.2. USE SUBQUERY FROM 4.1. IN MAIN QUERY TO CALCULATE AVERAGE ***** ----------
--------! Calculate the average daily attendance for each location !----------
SELECT 
    l.name AS location_name,
    CAST(AVG(daily_count) AS INTEGER) AS avg_daily_attendance -- CAST AVG TO WHOLE NO.
FROM (
    -- SUB QUERY: Count check-ins per location per day
    SELECT 
        location_id, 
        strftime('%Y-%m-%d', check_in_time) AS check_in_date, 
        COUNT(*) AS daily_count
    FROM attendance
    GROUP BY location_id, check_in_date
) AS daily_attendance
JOIN locations l ON daily_attendance.location_id = l.location_id
GROUP BY location_name;

-- ================================================================================================

