-- File: 01_spend_share_zero_revenue_objectives.sql
-- Question: What share of total spend sits in objectives with zero revenue by design?
-- Scope: All rows, all objectives.
-- Method: A CTE collapses the table to one row per objective. A window function,
--         SUM(total_spend) OVER (), puts the grand total next to every row, so each
--         objective's share is its spend divided by that total. The filter on the
--         four zero revenue objectives is applied in the last layer, after the
--         percentages are calculated, so the filter does not change the grand total.
-- Result: 70.19% of spend sits in Reach, Traffic, Engagement, and Video Views.
--         This is why a single ROAS ranking would be unfair to most of the budget.
-- Caveat: Rounded shares can add to 99.99 or 100.01. That is rounding, not an error.


-- Query 1: Share of spend for every objective
WITH by_objective AS (
    SELECT
        objective,
        SUM(spend) AS total_spend
    FROM marketing_raw
    GROUP BY objective
)
SELECT
    objective,
    total_spend,
    ROUND(100.0 * total_spend / SUM(total_spend) OVER (), 2) AS pct_of_total
FROM by_objective
ORDER BY total_spend DESC;


-- Query 2: Combined share of the four zero revenue objectives
WITH by_objective AS (
    SELECT
        objective,
        SUM(spend) AS total_spend
    FROM marketing_raw
    GROUP BY objective
),
with_pct AS (
    SELECT
        objective,
        total_spend,
        100.0 * total_spend / SUM(total_spend) OVER () AS pct_of_total
    FROM by_objective
)
SELECT
    ROUND(SUM(pct_of_total), 2) AS zero_revenue_share_pct
FROM with_pct
WHERE objective IN ('Reach', 'Traffic', 'Engagement', 'Video Views');
