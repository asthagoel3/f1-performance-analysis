CREATE OR REPLACE TABLE f1_data.pairing_podiums AS

-- Step 1: Count how many years each constructor had the same driver pair
WITH pairing_stability AS (
  SELECT
    constructor_name,
    drivers AS driver_pair,
    COUNT(*) AS stable_years,
    MIN(year) AS first_year,
    MAX(year) AS last_year
  FROM `f1capstone-459715.f1_data.cleaned_results_base`
  GROUP BY constructor_name, drivers
  HAVING COUNT(*) > 1  -- Only include pairings that stayed together multiple seasons
),

-- Step 2: Join to base to pull in podiums for only those stable pairings
stable_pairing_podiums AS (
  SELECT
    ps.constructor_name,
    ps.driver_pair,
    ps.stable_years,
    bq.year,
    bq.podium_finishes
  FROM pairing_stability ps
  JOIN f1_data.cleaned_results_base bq
    ON ps.constructor_name = bq.constructor_name
    AND ps.driver_pair = bq.drivers
    AND bq.year BETWEEN ps.first_year AND ps.last_year
)

-- Step 3: Final output with average podiums over the stable period
SELECT
  constructor_name,
  driver_pair,
  stable_years,
  ROUND(AVG(podium_finishes), 2) AS avg_podiums,
  COUNT(*) AS years_counted
FROM stable_pairing_podiums
GROUP BY constructor_name, driver_pair, stable_years
ORDER BY avg_podiums DESC;
