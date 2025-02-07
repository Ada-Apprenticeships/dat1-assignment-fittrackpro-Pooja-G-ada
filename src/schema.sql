-- FitTrack Pro Database Schema

-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- PRAGMA foreign_keys;
-- Enable foreign key support
PRAGMA foreign_keys = ON;
DROP TABLE IF EXISTS equipment_maintenance_log;
DROP TABLE IF EXISTS member_health_metrics;
DROP TABLE IF EXISTS personal_training_sessions;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS class_attendance;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS memberships;
DROP TABLE IF EXISTS class_schedule;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS locations;



-- Create your tables here
-- Example:
-- CREATE TABLE table_name (
--     column1 datatype,
--     column2 datatype,
--     ...
-- );

-- TODO: Create the following tables:
-- ======================================================================================================================
-- 1. locations
CREATE TABLE locations (
    location_id     INTEGER     PRIMARY KEY,
    name            TEXT        NOT NULL                    CHECK (LENGTH(name) <= 50),
    address         TEXT        NOT NULL                    CHECK (LENGTH(address) BETWEEN 10 AND 200),
    phone_number    TEXT        NOT NULL        UNIQUE      CHECK(phone_number GLOB '555-[0-9][0-9][0-9][0-9]'),
    email           TEXT        NOT NULL        UNIQUE      CHECK(email LIKE'%@%'),
    opening_hours   TEXT        NOT NULL                    CHECK (LENGTH(opening_hours) <= 11),
    CHECK (
        opening_hours GLOB '[0-2][0-9]:[0-5][0-9]-[0-2][0-9]:[0-5][0-9]' OR
        opening_hours GLOB '[0-9]:[0-5][0-9]-[0-2][0-9]:[0-5][0-9]' OR
        opening_hours GLOB '[0-2][0-9]:[0-5][0-9]-[0-9]:[0-5][0-9]' OR
        opening_hours GLOB '[0-9]:[0-5][0-9]-[0-9]:[0-5][0-9]'
        )
);


-- ======================================================================================================================
-- 2. members
CREATE TABLE members (
    member_id               INTEGER     PRIMARY KEY,
    first_name              TEXT        NOT NULL                                CHECK (LENGTH(first_name) <= 50),
    last_name               TEXT        NOT NULL        DEFAULT 'No Surname'    CHECK (LENGTH(last_name) <= 50),       
    email                   TEXT        NOT NULL        UNIQUE                  CHECK(email LIKE'%@%'),
    phone_number            TEXT        NOT NULL        UNIQUE                  CHECK(phone_number GLOB '555-[0-9][0-9][0-9][0-9]'),
    date_of_birth           DATE        NOT NULL,
    join_date               DATE        NOT NULL        DEFAULT (CURRENT_DATE),
    emergency_contact_name  TEXT        NOT NULL,
    emergency_contact_phone TEXT        NOT NULL                                CHECK(phone_number LIKE'___-____')
);


-- ======================================================================================================================
-- 3. staff
CREATE TABLE staff (
    staff_id        INTEGER     PRIMARY KEY,
    first_name      TEXT        NOT NULL                                CHECK (LENGTH(first_name) <= 50),
    last_name       TEXT        NOT NULL        DEFAULT 'No Surname'    CHECK (LENGTH(first_name) <= 50),
    email           TEXT        NOT NULL        UNIQUE                  CHECK(email LIKE'%@%'),
    phone_number    TEXT        NOT NULL        UNIQUE                  CHECK(phone_number GLOB '555-[0-9][0-9][0-9][0-9]'),
    position        TEXT                                                CHECK(position IN ('Trainer','Manager','Receptionist','Maintenance')),
    hire_date       DATE        DEFAULT (CURRENT_DATE),
    location_id     REFERENCES locations(location_id)                   ON DELETE SET NULL  -- Example: If a location is deleted, set location_id in staff to NULL
);


-- ======================================================================================================================
-- 4. equipment
CREATE TABLE equipment (
    equipment_id            INTEGER     PRIMARY KEY,
    name                    TEXT        NOT NULL,
    type                    TEXT                                CHECK(type IN ('Cardio', 'Strength')),
    purchase_date           DATE        NOT NULL                DEFAULT (CURRENT_DATE),
    last_maintenance_date   DATE        NOT NULL                DEFAULT (CURRENT_DATE),
    next_maintenance_date   DATE        NOT NULL                CHECK(next_maintenance_date > last_maintenance_date),
    location_id             REFERENCES locations(location_id)   ON DELETE SET NULL  -- Example: If a location is deleted, set location_id in equipment to NULL
);


-- ======================================================================================================================
-- 5. classes
CREATE TABLE classes (
    class_id        INTEGER     PRIMARY KEY,
    name            TEXT        NOT NULL,
    description     TEXT,
    capacity        INTEGER     NOT NULL,
    duration        INTEGER     NOT NULL,
    location_id     REFERENCES locations(location_id)       ON DELETE SET NULL  -- Example: If a location is deleted, set location_id in classes to NULL
);


-- ======================================================================================================================
-- 6. class_schedule
CREATE TABLE class_schedule (
    schedule_id     INTEGER     PRIMARY KEY,
    class_id        REFERENCES classes(class_id)    ON DELETE SET NULL,  -- Example: If a class is deleted, set class_id in class_schedule to NULL
    staff_id        REFERENCES staff(staff_id)      ON DELETE SET NULL,  -- Example: If a staff is deleted, set staff_id in class_schedule to NULL
    start_time      DATETIME    DEFAULT CURRENT_TIMESTAMP,
    end_time        DATETIME    DEFAULT CURRENT_TIMESTAMP 
);


-- ======================================================================================================================
-- 7. memberships
CREATE TABLE memberships (
    membership_id       INTEGER     PRIMARY KEY,
    member_id           REFERENCES members(member_id)   ON DELETE SET NULL,  -- Example: If a member is deleted, set member_id in memberships to NULL
    type                TEXT        NOT NULL, 
    start_date          DATE        NOT NULL            DEFAULT (CURRENT_DATE),
    end_date            DATE        NOT NULL            CHECK(end_date > start_date),
    status              CHECK(status in ('Active', 'Inactive'))
);


-- ======================================================================================================================
-- 8. attendance
CREATE TABLE attendance (
    attendance_id       INTEGER     PRIMARY KEY,
    member_id           REFERENCES members(member_id)       ON DELETE SET NULL,  -- Example: If a member is deleted, set member_id in attendance to NULL
    location_id         REFERENCES locations(location_id)   ON DELETE SET NULL,  -- Example: If a location is deleted, set location_id in attendance to NULL
    check_in_time       DATETIME    DEFAULT CURRENT_TIMESTAMP,                 
    check_out_time      DATETIME    DEFAULT CURRENT_TIMESTAMP                 
);


-- ======================================================================================================================
-- 9. class_attendance
CREATE TABLE class_attendance (
    class_attendance_id     INTEGER     PRIMARY KEY,
    schedule_id             REFERENCES class_schedule(schedule_id)  ON DELETE SET NULL,  -- Example: If a schedule is deleted, set class_schedule in class_attendance to NULL
    member_id               REFERENCES members(member_id)           ON DELETE SET NULL,  -- Example: If a member is deleted, set member_id in class_attendance to NULL
    attendance_status       TEXT        CHECK(attendance_status IN ('Registered', 'Attended', 'Unattended'))
);


-- ======================================================================================================================
-- 10. payments
CREATE TABLE payments (
    payment_id      INTEGER     PRIMARY KEY,
    member_id       REFERENCES members(member_id)       ON DELETE SET NULL,  -- Example: If a member is deleted, set member_id in payments to NULL
    amount          INTEGER     DECIMAL(10,2)           NOT NULL                CHECK(amount >= 0),
    payment_date    DATETIME    DEFAULT CURRENT_TIMESTAMP,                
    payment_method  TEXT        NOT NULL                CHECK(payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')),
    payment_type    TEXT        NOT NULL                CHECK(payment_type IN ('Monthly membership fee', 'Day pass'))
);


-- ======================================================================================================================
-- 11. personal_training_sessions
CREATE TABLE personal_training_sessions (
    session_id      INTEGER     PRIMARY KEY,
    member_id       REFERENCES members(member_id)       ON DELETE SET NULL,  -- Example: If a member is deleted, set member_id in personal_training_sessions to NULL
    staff_id        REFERENCES staff(staff_id)          ON DELETE SET NULL,  -- Example: If a staff is deleted, set staff_id in personal_training_sessions to NULL
    session_date    DATE        NOT NULL                CHECK(session_date LIKE '____-__-__'),
    start_time      TEXT        NOT NULL                CHECK(start_time LIKE '__:__:__'), 
    end_time        TEXT        NOT NULL                CHECK(end_time LIKE '__:__:__'), 
    notes           TEXT 
);


-- ======================================================================================================================
-- 12. member_health_metrics
CREATE TABLE member_health_metrics (
    metric_id               INTEGER     PRIMARY KEY,
    member_id               REFERENCES members(member_id)       ON DELETE SET NULL,  -- Example: If a member is deleted, set member_id in member_health_metrics to NULL
    measurement_date        DATE        NOT NULL                CHECK(measurement_date LIKE '____-__-__'),
    weight                  INTEGER     DECIMAL(10,2)           NOT NULL,
    body_fat_percentage     INTEGER     DECIMAL(10,2),
    muscle_mass             INTEGER     DECIMAL(10,2),
    bmi                     INTEGER     DECIMAL(10,2)           NOT NULL
);


-- ======================================================================================================================
-- 13. equipment_maintenance_log
CREATE TABLE equipment_maintenance_log (
    log_id                  INTEGER     PRIMARY KEY,
    equipment_id            REFERENCES equipment(equipment_id)     ON DELETE SET NULL,  -- Example: If a equipment is deleted, set equipment_id in equipment_maintenance_log to NULL
    maintenance_date        DATE        NOT NULL                   CHECK(maintenance_date LIKE '____-__-__'),
    description             TEXT        NOT NULL,
    staff_id                REFERENCES staff(staff_id)             ON DELETE SET NULL  -- Example: If a staff is deleted, set staff_id in equipment_maintenance_log to NULL
);


-- ======================================================================================================================

-- After creating the tables, you can import the sample data using:
-- `.read data/sample_data.sql` in a sql file or `npm run import` in the terminal

-- .read my_testing/schema_testing.sql
.read scripts/sample_data.sql