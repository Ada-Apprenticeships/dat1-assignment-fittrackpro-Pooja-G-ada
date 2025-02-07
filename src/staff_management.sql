-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Staff Management Queries

-- 1. List all staff members by role
-- TODO: Write a query to list all staff members by role

SELECT 
    staff_id,
    first_name,
    last_name,
    position AS role
FROM staff
ORDER BY role; -- order the staff by their role

-- 2. Find trainers with one or more personal training session in the next 30 days
-- TODO: Write a query to find trainers with one or more personal training session in the next 30 days

--------! 2.1FIRST SUBQUERY TO FIND SESSIONS IN NEXT 30 DAYS !----------
SELECT
    staff_id AS trainer_id,
    session_date
FROM personal_training_sessions
WHERE session_date >= DATE('now') -- from today
   AND session_date < DATE('now', '+30 days'); -- 30 days starting tomorrow

--------! 2.2 USE JOIN TABLE ON SUBQUERY TABLE TO GET trainer name !----------
SELECT
    pts.staff_id AS trainer_id,
    s.first_name || ' ' || s.last_name AS trainer_name,
    pts.session_date
FROM personal_training_sessions pts
JOIN staff s ON pts.staff_id = s.staff_id
WHERE session_date >= DATE('now') -- from today
   AND session_date < DATE('now', '+30 days'); -- 30 days starting tomorrow

--------! 2.3 USE SUBQURY TABLE FORM 2.2 TO GET trainers with one or more personal training session !----------
--------! FINAL QUERY !----------
SELECT
    trainer_id,
    trainer_name,
    COUNT(*) AS session_count
FROM (
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
HAVING COUNT(*) = 1 OR COUNT(*) = 2;

