-- File: 03_conversions_by_platform_objective.sql
-- Question: Where do conversions concentrate?
-- Scope: All rows. Uncomment the WHERE to drill into one platform.
-- Method: Total conversions by platform and objective, ordered by most conversions.
--         Totals are used instead of averages because conversions are heavily right
--         skewed (average 10.8, median 1).
-- Result: Google Search leads, mostly through the Leads and Sales objectives.
-- Caveat: Total conversions say nothing about cost or value. See files 04 and 05.


-- Query 1: Total conversions by platform and objective
SELECT
    platform,
    objective,
    SUM(conversions) AS total_conversions
    -- , percentile_cont(0.5) WITHIN GROUP (ORDER BY conversions) AS median_conversions
FROM marketing_raw
-- WHERE platform = 'Google Search'
GROUP BY platform, objective
ORDER BY total_conversions DESC;


-- Query 2: Total conversions by platform only
SELECT
    platform,
    SUM(conversions) AS total_conversions
FROM marketing_raw
GROUP BY platform
ORDER BY total_conversions DESC;
