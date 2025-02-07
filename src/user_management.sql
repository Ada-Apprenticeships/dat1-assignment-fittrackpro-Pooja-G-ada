-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- User Management Queries

-- 1. Retrieve all members
-- TODO: Write a query to retrieve all members
SELECT 
    member_id,
    first_name,
    last_name,
    email,
    join_date
FROM members;

-- 2. Update a member's contact information
-- TODO: Write a query to update a member's contact information
UPDATE members
SET phone_number = '555-9876', email = 'emily.jones.updated@email.com'
WHERE member_id = 5;

-- --------! MY OWN TESTING TO CHECK IF CONTACT INFO/PHONE NO UPDATED IN THE members TABLE !--------
SELECT *  
FROM members
WHERE member_id = 5;

-- 3. Count total number of members
-- TODO: Write a query to count the total number of members
SELECT COUNT() AS total_no_of_members
FROM members;

-- 4. Find member with the most class registrations
-- TODO: Write a query to find the member with the most class registrations
SELECT 
    cl.member_id,
    first_name, 
    last_name, 
    COUNT(cl.member_id) AS registration_count
FROM class_attendance cl 
LEFT JOIN members me
ON cl.member_id = me.member_id
GROUP BY me.member_id
HAVING registration_count = (
    SELECT MAX(registration_count)
    FROM (
        SELECT COUNT(cl.member_id) AS registration_count
        FROM class_attendance cl 
        LEFT JOIN members me
        ON cl.member_id = me.member_id 
        GROUP BY me.member_id
    )
); 
-- 5. Find member with the least class registrations
-- TODO: Write a query to find the member with the least class registrations
SELECT 
    cl.member_id,
    first_name, 
    last_name, 
    COUNT(cl.member_id) AS registration_count
FROM class_attendance cl 
LEFT JOIN members me
ON cl.member_id = me.member_id
GROUP BY me.member_id
HAVING registration_count = (
    SELECT MIN(registration_count)
    FROM (
        SELECT COUNT(cl.member_id) AS registration_count
        FROM class_attendance cl 
        LEFT JOIN members me
        ON cl.member_id = me.member_id 
        GROUP BY me.member_id
    )
);

-- 6. Calculate the percentage of members who have attended at least one class
-- TODO: Write a query to calculate the percentage of members who have attended at least one class
SELECT 
    (SUM(registration_count) * 100) / ( SELECT COUNT(*) FROM members ) AS percentage_of_members_who_attended_at_least_one_class
FROM (
    SELECT COUNT(member_id) AS registration_count
    FROM class_attendance
    GROUP BY member_id
    HAVING registration_count = 1
);

