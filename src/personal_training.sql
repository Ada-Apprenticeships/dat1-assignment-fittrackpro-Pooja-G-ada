-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Personal Training Queries

-- 1. List all personal training sessions for a specific trainer
-- TODO: Write a query to list all personal training sessions for a specific trainer

--------! List all personal training sessions for specific trainer "Ivy Irwin" !----------
SELECT 
    pts.session_id,
    m.first_name || ' ' || m.last_name AS member_name, --put first name and last name together 
    pts.session_date,
    pts.start_time,
    pts.end_time,
    s.first_name || ' ' || s.last_name AS staff_name
FROM personal_training_sessions pts
JOIN staff s ON pts.staff_id = s.staff_id
JOIN members m ON pts.member_id = m.member_id
WHERE staff_name LIKE 'Ivy Irwin';

-- ================================================================================================
