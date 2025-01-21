CREATE TABLE parents AS
  SELECT "ace" AS parent, "bella" AS child UNION
  SELECT "ace"          , "charlie"        UNION
  SELECT "daisy"        , "hank"           UNION
  SELECT "finn"         , "ace"            UNION
  SELECT "finn"         , "daisy"          UNION
  SELECT "finn"         , "ginger"         UNION
  SELECT "ellie"        , "finn";

CREATE TABLE dogs AS
  SELECT "ace" AS name, "long" AS fur, 26 AS height UNION
  SELECT "bella"      , "short"      , 52           UNION
  SELECT "charlie"    , "long"       , 47           UNION
  SELECT "daisy"      , "long"       , 46           UNION
  SELECT "ellie"      , "short"      , 35           UNION
  SELECT "finn"       , "curly"      , 32           UNION
  SELECT "ginger"     , "short"      , 28           UNION
  SELECT "hank"       , "curly"      , 31;

CREATE TABLE sizes AS
  SELECT "toy" AS size, 24 AS min, 28 AS max UNION
  SELECT "mini"       , 28       , 35        UNION
  SELECT "medium"     , 35       , 45        UNION
  SELECT "standard"   , 45       , 60;


-- All dogs with parents ordered by decreasing height of their parent
CREATE TABLE by_parent_height AS
  SELECT 
    child AS chil 
  FROM 
    parents 
  JOIN 
    dogs ON parent = name 
  ORDER BY 
    height DESC;


-- The size of each dog
CREATE TABLE size_of_dogs AS
  SELECT 
    name, size
  FROM
    dogs
  JOIN
    sizes ON height <= max AND height > min;


-- [Optional] Filling out this helper table is recommended
CREATE TABLE siblings AS
  SELECT 
    pa.child AS siblings1, 
    pb.child AS siblings2, 
    sa.size AS size
  FROM
    parents pa
  JOIN
    parents pb ON pa.parent = pb.parent AND pa.child < pb.child
  JOIN 
    size_of_dogs sa ON pa.child = sa.name
  JOIN
    size_of_dogs sb ON pb.child = sb.name
  WHERE
    sa.size = sb.size;

-- Sentences about siblings that are the same size
CREATE TABLE sentences AS
  SELECT
    "The two siblings, " || siblings1 || " and " || siblings2 || ", have the same size: "|| size AS sentence
  FROM
    siblings;


-- Height range for each fur type where all of the heights differ by no more than 30% from the average height
CREATE TABLE low_variance AS
  WITH fur_averages AS (
    -- 计算每种毛发类型的平均身高
    SELECT 
      fur, 
      AVG(height) AS avg_height
    FROM
      dogs
    GROUP BY
      fur
  ),
  filtered_furs AS (
    -- 筛选满足低方差条件的毛发类型
    SELECT 
      dogs.fur
    FROM 
      dogs
    JOIN 
      fur_averages ON dogs.fur = fur_averages.fur
    WHERE 
      dogs.height BETWEEN 0.7 * fur_averages.avg_height AND 1.3 * fur_averages.avg_height
    GROUP BY 
      dogs.fur
    HAVING 
      COUNT(*) = (SELECT COUNT(*) FROM dogs WHERE dogs.fur = fur_averages.fur)
  )
  -- 计算满足条件的毛发类型的身高范围
  SELECT 
    dogs.fur,
    MAX(dogs.height) - MIN(dogs.height) AS height_range
  FROM 
    dogs
  JOIN 
    filtered_furs ON dogs.fur = filtered_furs.fur
  GROUP BY 
    dogs.fur;

