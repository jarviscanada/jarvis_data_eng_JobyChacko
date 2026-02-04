/*
====================================================
 PostgreSQL Practice Sheet - pgExercises
 Author: Joby Chacko
====================================================
*/

-- ==================================================
-- SECTION: MODIFYING DATA (CRUD)
-- ==================================================

-- Question 1: Insert a new facility called 'Spa' with a new facid and fixed costs
INSERT INTO cd.facilities
VALUES (9, 'Spa', 20, 30, 100000, 800);

-- Question 2: Insert a new facility called 'Spa' using a calculated facid
INSERT INTO cd.facilities
SELECT
  MAX(facid) + 1,
  'Spa',
  20,
  30,
  100000,
  800
FROM cd.facilities;

-- Question 3: Update the initial outlay for Tennis Court 2 to 10000
UPDATE cd.facilities
SET initialoutlay = 10000
WHERE name = 'Tennis Court 2';

-- Question 4: Increase Tennis Court 2 costs to be 10% higher than Tennis Court 1
UPDATE cd.facilities t1
SET
  membercost = t2.membercost * 1.10,
  guestcost = t2.guestcost * 1.10,
  initialoutlay = t2.initialoutlay * 1.10,
  monthlymaintenance = t2.monthlymaintenance * 1.10
FROM cd.facilities t2
WHERE t2.name = 'Tennis Court 1'
  AND t1.name = 'Tennis Court 2';

-- Question 5: Delete all booking records
DELETE FROM cd.bookings;

-- Question 6: Delete the member with memid = 37
DELETE FROM cd.members
WHERE memid = 37;

-- ==================================================
-- SECTION: BASICS (WHERE, LIKE, IN, DATES, UNION)
-- ==================================================

-- Question 7: List facilities that charge members less than 1/50th of monthly maintenance
SELECT
  facid,
  name,
  membercost,
  monthlymaintenance
FROM cd.facilities
WHERE
  membercost > 0
  AND membercost < (monthlymaintenance / 50);

-- Question 8: List all facilities with 'Tennis' in their name
SELECT *
FROM cd.facilities
WHERE name LIKE '%Tennis%';

-- Question 9: Retrieve facilities with facid 1 and 5 (without using OR)
SELECT *
FROM cd.facilities
WHERE facid IN (1, 5);

-- Question 10: List members who joined on or after September 1, 2012
SELECT
  memid,
  surname,
  firstname,
  joindate
FROM cd.members
WHERE joindate >= '2012-09-01 00:00:00';

-- Question 11: List all surnames and facility names without duplicates
SELECT surname
FROM cd.members
UNION
SELECT name
FROM cd.facilities;

-- ==================================================
-- SECTION: JOINS
-- ==================================================

-- Question 12: List booking start times for bookings made by David Farrell
SELECT
  bks.starttime
FROM cd.bookings bks
JOIN cd.members mems
  ON bks.memid = mems.memid
WHERE
  mems.firstname = 'David'
  AND mems.surname = 'Farrell';

-- Question 13: List all tennis court bookings on September 21, 2012
SELECT
  bks.starttime AS start,
  facs.name
FROM cd.bookings bks
JOIN cd.facilities facs
  ON bks.facid = facs.facid
WHERE
  facs.name LIKE '%Tennis Court%'
  AND DATE(bks.starttime) = '2012-09-21'
ORDER BY bks.starttime;

-- Question 14: List members and their recommenders (including members without one)
SELECT
  mems.firstname AS member_firstname,
  mems.surname AS member_surname,
  recs.firstname AS recommender_firstname,
  recs.surname AS recommender_surname
FROM cd.members mems
LEFT JOIN cd.members recs
  ON recs.memid = mems.recommendedby
ORDER BY
  mems.surname,
  mems.firstname;

-- Question 15: List members who have recommended at least one other member
SELECT DISTINCT
  mems.firstname,
  mems.surname
FROM cd.members mems
JOIN cd.members recs
  ON mems.memid = recs.recommendedby
ORDER BY
  mems.surname,
  mems.firstname;

-- Question 16: List members and their recommender using a subquery
SELECT DISTINCT
  mems.firstname || ' ' || mems.surname AS member,
  (
    SELECT recs.firstname || ' ' || recs.surname
    FROM cd.members recs
    WHERE recs.memid = mems.recommendedby
  ) AS recommender
FROM cd.members mems
ORDER BY member;

-- ==================================================
-- SECTION: AGGREGATION & WINDOW FUNCTIONS
-- ==================================================

-- Question 17: Count how many members each person has recommended
SELECT
  recommendedby,
  COUNT(*) AS count
FROM cd.members
WHERE recommendedby IS NOT NULL
GROUP BY recommendedby
ORDER BY recommendedby;

-- Question 18: Total slots booked per facility
SELECT
  facid,
  SUM(slots) AS total_slots
FROM cd.bookings
GROUP BY facid
ORDER BY facid;

-- Question 19: Total slots booked per facility in September
SELECT
  facid,
  SUM(slots) AS total_slots
FROM cd.bookings
WHERE EXTRACT(MONTH FROM starttime) = 9
GROUP BY facid
ORDER BY total_slots;

-- Question 20: Total slots per facility per month in 2012
SELECT
  facid,
  EXTRACT(MONTH FROM starttime) AS month,
  SUM(slots) AS total_slots
FROM cd.bookings
WHERE EXTRACT(YEAR FROM starttime) = 2012
GROUP BY facid, month
ORDER BY facid, month;

-- Question 21: Count distinct members who have made bookings
SELECT
  COUNT(DISTINCT memid) AS member_count
FROM cd.bookings;

-- Question 22: List members and their first booking after September 1, 2012
SELECT
  mems.surname,
  mems.firstname,
  mems.memid,
  MIN(bks.starttime) AS first_booking
FROM cd.bookings bks
JOIN cd.members mems
  ON mems.memid = bks.memid
WHERE bks.starttime >= '2012-09-01'
GROUP BY
  mems.surname,
  mems.firstname,
  mems.memid
ORDER BY mems.memid;

-- Question 23: Count how many members joined per month (window function)
SELECT
  COUNT(*) OVER (PARTITION BY DATE_TRUNC('month', joindate)) AS members_that_month,
  firstname,
  surname
FROM cd.members
ORDER BY joindate;

-- Question 24: Generate a numbered list of members ordered by join date
SELECT
  ROW_NUMBER() OVER (ORDER BY joindate) AS row_number,
  firstname,
  surname
FROM cd.members;

-- Question 25: Find facility with the highest number of total slots (including ties)
SELECT
  facid,
  total
FROM (
  SELECT
    facid,
    SUM(slots) AS total,
    RANK() OVER (ORDER BY SUM(slots) DESC) AS rank
  FROM cd.bookings
  GROUP BY facid
) ranked
WHERE rank = 1;

-- ==================================================
-- SECTION: STRING FUNCTIONS
-- ==================================================

-- Question 26: Format member names as "Surname, Firstname"
SELECT
  surname || ', ' || firstname AS name
FROM cd.members;

-- Question 27: List members with parentheses in their phone number
SELECT
  memid,
  telephone
FROM cd.members
WHERE telephone LIKE '%(%';

-- Question 28: Count members by first letter of surname
SELECT
  SUBSTRING(surname FROM 1 FOR 1) AS letter,
  COUNT(*) AS count
FROM cd.members
GROUP BY letter
ORDER BY letter;
