-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Class Scheduling Queries

-- ================================================================================================
-- 1. List all classes with their instructors
-- TODO: Write a query to list all classes with their instructors

SELECT 
    cs.class_id,
    c.name AS class_name,
    s.first_name || ' ' || s.last_name AS instructor_name
FROM class_schedule cs
JOIN classes c on cs.class_id = c.class_id
JOIN staff s on cs.staff_id = s.staff_id;


-- ================================================================================================
-- 2. Find available classes for a specific date
-- TODO: Write a query to find available classes for a specific date

SELECT 
    cs.class_id,
    c.name,
    cs.start_time,
    cs.end_time,
    c.capacity AS available_spots
FROM class_schedule cs
JOIN classes c on cs.class_id = c.class_id
-- strftime('%Y-%m-%d', cs.start_time) --> extracts the year, month & day from the start_time column. 
--The format string '%Y-%m-%d' returns in YYYY-MM--DD format.
WHERE strftime('%Y-%m-%d', cs.start_time) LIKE '2025-02-01';


-- ================================================================================================
-- 3. Register a member for a class
-- TODO: Write a query to register a member for a class

--------! [MY OWN TESTING]: 3.1. DELETE QUERY SO THAT SAME ROW DOES NOT GET ADDED/DUPLICATED EVERYTIME I RE-RAN THIS SQL FILE !----------
DELETE 
FROM class_attendance 
WHERE member_id = 11 AND attendance_status = 'Registered';

-------- *****  [FINAL SOLUTION]: 1.2. Register member with ID 11 for the Spin Class (class_id 3) on '2025-02-01'  ***** -----
INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
VALUES (7, 11, 'Registered');

--------! [MY OWN TESTING]: 3.3. TO CHECK IF THE NEW RECORD ADDED !----------
SELECT 
    ca.member_id,
    ca.schedule_id,
    ca.attendance_status,
    strftime('%Y-%m-%d', cs.start_time) AS class_date
FROM class_attendance ca
JOIN class_schedule cs on ca.schedule_id = cs.schedule_id
WHERE ca.member_id = 11 AND class_date = '2025-02-01';


-- ================================================================================================
-- 4. Cancel a class registration
-- TODO: Write a query to cancel a class registration

--------! [MY OWN TESTING]: 4.1. QUERY BELOW IS TO CHECK TOTAL YOGA BASIC CLASS ATTENDEES BEFORE CANCELLATION/DELETION !----------
--------! THIS SHOWS 3 RECORDS WHICH HAS schedule_id = 7 BEFORE DELETION !-----
SELECT 
    ca.member_id,
    c.name AS class_name,
    cs.schedule_id
FROM class_attendance ca
JOIN class_schedule cs ON ca.schedule_id = cs.schedule_id
JOIN classes c ON cs.class_id = c.class_id
WHERE cs.schedule_id = 7;

-------- *****  [MAIN QUERY/FINAL SOLUTION]: 4.2. Cancel the registration for member with ID 2 from the Scheduled Yoga Basics class (schedule_id 7) ***** -----
DELETE 
FROM class_attendance
WHERE member_id = 2 AND schedule_id = 7;

--------! [MY OWN TESTING]: 4.3. QUERY BELOW IS TO CHECK TOTAL YOGA BASIC CLASS ATTENDEES BEFORE CANCELLATION/DELETION !----------
--------! DOESNT SHOW RECORD WEHRE member_id = 2 & schedule_id = 7 AFTER DELETION !-----
SELECT 
    ca.member_id,
    c.name AS class_name,
    cs.schedule_id
FROM class_attendance ca
JOIN class_schedule cs ON ca.schedule_id = cs.schedule_id
JOIN classes c ON cs.class_id = c.class_id
WHERE cs.schedule_id = 7;

-- ================================================================================================
-- 5. List top 5 most popular classes
-- TODO: Write a query to list top 5 most popular classes

SELECT 
    c.class_id,
    c.name AS class_name,
    count(*) AS registration_count
FROM class_attendance ca
JOIN class_schedule cs ON ca.schedule_id = cs.schedule_id
JOIN classes c ON cs.class_id = c.class_id
GROUP BY c.class_id --counts within group --> class
ORDER BY registration_count DESC
LIMIT 5;

-- ================================================================================================
-- 6. Calculate average number of classes per member
-- TODO: Write a query to calculate average number of classes per member

--COUNT(*) counts all attendance records (total classes attended).
--COUNT(DISTINCT member_id) counts unique members who attended at least one class.

SELECT 
    ROUND((COUNT(*) * 1.0) / COUNT(DISTINCT member_id), 1) AS avg_classes_per_member
FROM class_attendance;


-- ================================================================================================
