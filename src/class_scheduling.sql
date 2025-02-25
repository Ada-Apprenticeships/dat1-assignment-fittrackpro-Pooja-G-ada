-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Class Scheduling Queries

-- =========================================================== [TASK 4.1] ====================================================================================
-- ===========================================================================================================================================================

-- 1. List all classes with their instructors
-- TODO: Write a query to list all classes with their instructors

SELECT '*********** <<< [SQL QUERY RESULT] for 4.1 >>> *********** ' AS '---------------------------------------------------'; -- Comment to print on console
--      *********** <<< [SQL QUERY SOLUTION] for 4.1 >>> *********** 
SELECT DISTINCT
    cs.class_id,
    c.name AS class_name,
    s.first_name || ' ' || s.last_name AS instructor_name
FROM class_schedule cs
JOIN classes c on cs.class_id = c.class_id
JOIN staff s on cs.staff_id = s.staff_id;

-- Print separator between queries for terminal output
SELECT '' AS '--------------------------------------------------';


-- =========================================================== [TASK 4.2] ====================================================================================
-- ===========================================================================================================================================================

-- 2. Find available classes for a specific date
-- TODO: Write a query to find available classes for a specific date

SELECT '*********** <<< [SQL QUERY RESULT] for 4.2 >>> *********** ' AS '---------------------------------------------------'; -- Comment to print on console
--      *********** <<< [SQL QUERY SOLUTION] for 4.2 >>> *********** 
SELECT 
    cs.class_id,
    c.name,
    cs.start_time,
    cs.end_time,
    (c.capacity - COUNT(ca.class_attendance_id)) AS available_spots
FROM class_schedule cs
JOIN classes c on cs.class_id = c.class_id
JOIN class_attendance ca ON cs.schedule_id = ca.schedule_id
-- strftime('%Y-%m-%d', cs.start_time) --> extracts the year, month & day from the start_time column. 
--The format string '%Y-%m-%d' returns in YYYY-MM--DD format.
WHERE strftime('%Y-%m-%d', cs.start_time) LIKE '2025-02-01'
GROUP BY c.class_id, c.name, cs.start_time, cs.end_time, c.capacity;

-- Print separator between queries for terminal output
SELECT '' AS '--------------------------------------------------';


-- =========================================================== [TASK 4.3] ====================================================================================
-- ===========================================================================================================================================================

-- 3. Register a member for a class
-- TODO: Write a query to register a member for a class

--      -------------! [MY OWN TESTING QUERY] for 4.3: DELETE QUERY SO THAT SAME ROW DOES NOT GET ADDED/DUPLICATED EVERYTIME I RE-RAN THIS SQL FILE !--------
DELETE 
FROM class_attendance 
WHERE member_id = 11 AND attendance_status = 'Registered';


--      *********** <<< [SQL QUERY SOLUTION] for 4.3 >>> *********** 
--      *********** <<<  Register member with ID 11 for the Spin Class (class_id 3) on '2025-02-01'  >>> ***********
INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
VALUES (7, 11, 'Registered');


SELECT '------------- [MY OWN TESTING RESULT] for 4.3 ------------- ' AS '-------------------------------------------------'; -- Comment to print on console
--      ------------! [MY OWN TESTING QUERY] for 4.3: TO CHECK IF THE NEW RECORD ADDED !--------
SELECT 
    ca.member_id,
    ca.schedule_id,
    ca.attendance_status,
    strftime('%Y-%m-%d', cs.start_time) AS class_date
FROM class_attendance ca
JOIN class_schedule cs on ca.schedule_id = cs.schedule_id
WHERE ca.member_id = 11 AND class_date = '2025-02-01';

-- Print separator between queries for terminal output
SELECT '' AS '--------------------------------------------------';


-- =========================================================== [TASK 4.4] ====================================================================================
-- ===========================================================================================================================================================
-- 4. Cancel a class registration
-- TODO: Write a query to cancel a class registration

SELECT '----- [MY OWN TESTING RESULT] for 4.4 before deletion ------ ' AS '--------------------------------------------------'; -- Comment to print on console
--      -------------! [[MY OWN TESTING] for 4.4: TO CHECK TOTAL YOGA BASIC CLASS ATTENDEES BEFORE CANCELLATION/DELETION !--------
--      -------------! THIS SHOWS ALL RECORDs WHICH HAS schedule_id = 7 *BEFORE* DELETION !-----
SELECT 
    ca.member_id,
    c.name AS class_name,
    cs.schedule_id
FROM class_attendance ca
JOIN class_schedule cs ON ca.schedule_id = cs.schedule_id
JOIN classes c ON cs.class_id = c.class_id
WHERE cs.schedule_id = 7;


--      *********** <<< [SQL QUERY SOLUTION] for 4.4 >>> *********** 
--      *********** <<< Cancel the registration for member with ID 2 from the Scheduled Yoga Basics class (schedule_id 7) >>> *********** 
DELETE 
FROM class_attendance
WHERE member_id = 2 AND schedule_id = 7;

-- Print separator between queries for terminal output
SELECT '' AS '--------------------------------------------------';

SELECT '------ [MY OWN TESTING RESULT] for 4.4 after deletion ----- ' AS '--------------------------------------------------'; -- Comment to print on console
--      -------------! [[MY OWN TESTING] for 4.4: QUERY BELOW IS TO CHECK TOTAL YOGA BASIC CLASS ATTENDEES BEFORE CANCELLATION/DELETION !--------
--      -------------! THIS SHOWS ALL RECORDs WHICH HAS schedule_id = 7 *AFTER* DELETION !-----
SELECT 
    ca.member_id,
    c.name AS class_name,
    cs.schedule_id
FROM class_attendance ca
JOIN class_schedule cs ON ca.schedule_id = cs.schedule_id
JOIN classes c ON cs.class_id = c.class_id
WHERE cs.schedule_id = 7;

-- Print separator between queries for terminal output
SELECT '' AS '--------------------------------------------------';


-- =========================================================== [TASK 4.5] ====================================================================================
-- ===========================================================================================================================================================

-- 5. List top 3 most popular classes
-- TODO: Write a query to list top 3 most popular classes

SELECT '*********** <<< [SQL QUERY RESULT] for 4.5 >>> *********** ' AS '---------------------------------------------------'; -- Comment to print on console
--      *********** <<< [SQL QUERY SOLUTION] for 4.5 >>> *********** 
SELECT 
    c.class_id,
    c.name AS class_name,
    count(*) AS registration_count
FROM class_attendance ca
JOIN class_schedule cs ON ca.schedule_id = cs.schedule_id
JOIN classes c ON cs.class_id = c.class_id
GROUP BY c.class_id --counts within group --> class
ORDER BY registration_count DESC
LIMIT 3;

-- Print separator between queries for terminal output
SELECT '' AS '--------------------------------------------------';


-- =========================================================== [TASK 4.6] ====================================================================================
-- ===========================================================================================================================================================

-- 6. Calculate average number of classes per member
-- TODO: Write a query to calculate average number of classes per member


SELECT '*********** <<< [SQL QUERY RESULT] for 4.6 >>> *********** ' AS '---------------------------------------------------'; -- Comment to print on console
--      *********** <<< [SQL QUERY SOLUTION] for 4.6 >>> *********** 
SELECT 
    ROUND((COUNT(*) * 1.0) / --COUNT(*) counts all attendance records (total classes attended)
    COUNT(DISTINCT member_id), 1) AS avg_classes_per_member --COUNT(DISTINCT member_id) counts unique members who attended at least one class
FROM class_attendance;


-- ===========================================================================================================================================================
-- ===========================================================================================================================================================

