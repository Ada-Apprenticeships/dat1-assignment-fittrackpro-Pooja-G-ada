-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Membership Management Queries

-- ================================================================================================
-- 1. List all active memberships
-- TODO: Write a query to list all active memberships
SELECT
    ms.member_id,
    m.first_name,
    m.last_name,
    type AS membership_type,
    m.join_date,
    status
FROM memberships ms
JOIN members m ON ms.member_id = m.member_id
WHERE status LIKE 'Active';


-- ================================================================================================
-- 2. Calculate the average duration of gym visits for each membership type
-- TODO: Write a query to calculate the average duration of gym visits for each membership type
SELECT 
    ms.type AS membership_type,
    --use AVG() function to calculate average after grouping by type, and ROUND() to round the average duration to the nearest minute
    ROUND(AVG(strftime('%s', check_out_time) - strftime('%s', check_in_time)) / 60.0) AS avg_visit_duration_minutes
FROM attendance a
JOIN members m ON a.member_id = m.member_id
JOIN memberships ms ON a.member_id = ms.member_id
GROUP BY membership_type;


-- ================================================================================================
-- 3. Identify members with expiring memberships this year
-- TODO: Write a query to identify members with expiring memberships this year

SELECT 
    ms.member_id,
    m.first_name,
    m.last_name,
    m.email,
    ms.end_date
FROM memberships ms
JOIN members m ON ms.member_id = m.member_id
WHERE ms.end_date <= '2025-12-31';

-- ================================================================================================
