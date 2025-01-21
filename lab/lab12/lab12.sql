CREATE TABLE finals AS
  SELECT "RSF" AS hall, "61A" as course UNION
  SELECT "Wheeler"    , "61A"           UNION
  SELECT "Pimentel"   , "61A"           UNION
  SELECT "Li Ka Shing", "61A"           UNION
  SELECT "Stanley"    , "61A"           UNION
  SELECT "RSF"        , "61B"           UNION
  SELECT "Wheeler"    , "61B"           UNION
  SELECT "Morgan"     , "61B"           UNION
  SELECT "Wheeler"    , "61C"           UNION
  SELECT "Pimentel"   , "61C"           UNION
  SELECT "Soda 310"   , "61C"           UNION
  SELECT "Soda 306"   , "10"            UNION
  SELECT "RSF"        , "70";

CREATE TABLE sizes AS
  SELECT "RSF" AS room, 900 as seats    UNION
  SELECT "Wheeler"    , 700             UNION
  SELECT "Pimentel"   , 500             UNION
  SELECT "Li Ka Shing", 300             UNION
  SELECT "Stanley"    , 300             UNION
  SELECT "Morgan"     , 100             UNION
  SELECT "Soda 306"   , 80              UNION
  SELECT "Soda 310"   , 40              UNION
  SELECT "Soda 320"   , 30;

CREATE TABLE sharing AS
SELECT
  f1.course,
  COUNT(DISTINCT f1.hall) AS shared
FROM
  finals f1
JOIN
  finals f2
ON
  f1.hall = f2.hall
  AND f1.course != f2.course
GROUP BY
  f1.course
HAVING
  shared > 0;

CREATE TABLE pairs AS
  SELECT r1.room || ' and ' || r2.room || ' together have ' || (r1.seats + r2.seats) || ' seats' AS rooms
  FROM sizes AS r1
  JOIN sizes AS r2
  ON r1.room < r2.room
  WHERE r1.seats + r2.seats >= 1000 
  Order by r1.seats + r2.seats DESC;


CREATE TABLE big AS
  SELECT 
    finals.course AS course
  FROM 
    finals
  JOIN
    sizes ON finals.hall = sizes.room
  GROUP BY 
    finals.course
  HAVING
    SUM(sizes.seats) >= 1000;

CREATE TABLE remaining AS
  SELECT 
    finals.course AS course,
    SUM(sizes.seats) - MAX(sizes.seats) AS remaining
  FROM
    finals
  JOIN
    sizes ON finals.hall = sizes.room 
  GROUP BY 
    finals.course;



