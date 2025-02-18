-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Staff Management Queries

-- =========================================================== [TASK 7.1] ====================================================================================
-- ===========================================================================================================================================================

-- 1. List all staff members by role
-- TODO: Write a query to list all staff members by role

SELECT '*********** <<< [SQL QUERY RESULT] for 7.1 >>> *********** ' AS '----------------------------------------------------------'; -- Comment to print on console
--      *********** <<< [SQL QUERY SOLUTION] for 7.1 >>> *********** 
SELECT 
    staff_id,
    first_name,
    last_name,
    position AS role
FROM staff
ORDER BY role; -- order the staff by their role

-- Print separator between queries for terminal output
SELECT '' AS '----------------------------------------------------------------';


-- =========================================================== [TASK 7.2] ====================================================================================
-- ===========================================================================================================================================================

-- 2. Find trainers with one or more personal training session in the next 30 days
-- TODO: Write a query to find trainers with one or more personal training session in the next 30 days

SELECT '----------- [MY OWN TESTING 1 RESULT] for 7.2 ----------- ' AS '--------------------------------------------------------'; -- Comment to print on console
--      -------------! [MY OWN TESTING] SUB QUERY 7.2.1.: TO FIND SESSIONS IN NEXT 30 DAYS !--------
SELECT
    staff_id AS trainer_id,
    session_date
FROM personal_training_sessions
WHERE session_date >= DATE('now') -- from today
   AND session_date < DATE('now', '+30 days'); -- 30 days starting tomorrow

SELECT '----------- [MY OWN TESTING 2 RESULT] for 7.2 ----------- ' AS '--------------------------------------------------------'; -- Comment to print on console
--      -------------! [MY OWN TESTING] SUB QUERY 7.2.2.: USE JOIN TABLE ON SUBQUERY TABLE FORM 7.2.1 TO GET trainer name !--------
SELECT
    pts.staff_id AS trainer_id,
    s.first_name || ' ' || s.last_name AS trainer_name,
    pts.session_date
FROM personal_training_sessions pts
JOIN staff s ON pts.staff_id = s.staff_id
WHERE session_date >= DATE('now') -- from today
   AND session_date < DATE('now', '+30 days'); -- 30 days starting tomorrow

-- Print separator between queries for terminal output
SELECT '' AS '----------------------------------------------------------------';


SELECT '*********** <<< [SQL QUERY RESULT] for 7.2 >>> *********** ' AS '----------------------------------------------------------'; -- Comment to print on console
--      *********** <<< [SQL QUERY SOLUTION] for 7.2 >>> *********** 
--      *********** <<< Find trainers with one or more personal training session in the next 30 days - using SUBQUERY 7.2.2 >>> *********** 
SELECT
    trainer_id,
    trainer_name,
    COUNT(*) AS session_count
FROM (
    -- Inner query: Retrieves trainer details (ID, first_name, last_name) and their scheduled sessions
    -- Filters sessions occurring within the next 30 days from today
    -- Joins 'personal_training_sessions' with 'staff' to get trainer names
    SELECT
        pts.staff_id AS trainer_id,
        s.first_name || ' ' || s.last_name AS trainer_name,
        pts.session_date
    FROM personal_training_sessions pts
    JOIN staff s ON pts.staff_id = s.staff_id
    WHERE session_date >= DATE('now') 
    AND session_date < DATE('now', '+30 days')
)
GROUP BY trainer_id, trainer_name
HAVING COUNT(*) >= 1; -- one or more training sessions

-- ===========================================================================================================================================================
-- ===========================================================================================================================================================
