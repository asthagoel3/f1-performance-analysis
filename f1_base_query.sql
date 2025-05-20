CREATE OR REPLACE TABLE f1_data.cleaned_results_base AS

-- Step 1: Get all podium finish results (top 3) from 2000 to 2024
WITH podium_results AS (
  SELECT
    r.year,
    r.raceId,
    c.name AS constructor_name,
    CONCAT(d.forename, ' ', d.surname) AS driver_name,
    SAFE_CAST(res.positionorder AS INT64) AS positionorder
  FROM
    `f1_data.races` r
  JOIN
    `f1_data.results` res ON r.raceId = res.raceId
  JOIN
    `f1_data.constructors` c ON res.constructorId = c.constructorId
  JOIN
    `f1_data.drivers` d ON res.driverId = d.driverId
  WHERE
    SAFE_CAST(res.positionorder AS INT64) <= 3
    AND r.year BETWEEN 2000 AND 2024
),

-- Step 2: Build a list of each constructor's driver pairings by year (2000-2024)
driver_pairings AS (
  SELECT
    r.year,
    c.name AS constructor_name,
    ARRAY_AGG(DISTINCT CONCAT(d.forename, ' ', d.surname) ORDER BY CONCAT(d.forename, ' ', d.surname)) AS drivers
  FROM
    `f1_data.races` r
  JOIN
    `f1_data.results` res ON r.raceId = res.raceId
  JOIN
    `f1_data.constructors` c ON res.constructorId = c.constructorId
  JOIN
    `f1_data.drivers` d ON res.driverId = d.driverId
  WHERE
    r.year BETWEEN 2000 AND 2024
  GROUP BY
    r.year, c.name
)

-- Step 3: Join driver pairings to podium finishes to count
SELECT
  dp.year,
  dp.constructor_name,
  dp.drivers,
  COUNT(pr.raceId) AS podium_finishes
FROM
  driver_pairings dp
LEFT JOIN
  podium_results pr
  ON dp.constructor_name = pr.constructor_name AND dp.year = pr.year
GROUP BY
  dp.year, dp.constructor_name, dp.drivers
ORDER BY
  dp.year, podium_finishes DESC;
