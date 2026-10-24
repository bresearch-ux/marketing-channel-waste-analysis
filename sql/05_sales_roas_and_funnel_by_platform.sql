-- File: 05_sales_roas_and_funnel_by_platform.sql
-- Question: Which platforms earn the best and worst return on Sales spend, and why?
-- Scope: Sales objective only. The other objectives have zero revenue by design,
--        so including them would drag every platform's ROAS down unfairly.
-- Method: Sum first, then divide for every ratio (never average row level ratios).
--         Only conversion_rate is multiplied by 100, since it is a percentage.
-- Result: ROAS runs from 16.78 (Google Search) to 0.44 (LinkedIn). Every platform
--         has 547+ rows behind it, so sample size is not a concern.
--         LinkedIn's CPC is about $3.08, roughly 6x the next platform, and is the
--         main driver of its low ROAS. Its revenue per conversion is the highest
--         ($188.56), so the problem is click cost, not order value.
-- Caveat: The dataset is synthetic, so treat this as the pattern, not a recommendation.


-- Query 1: ROAS by platform, with row count as a sample size check
SELECT
    platform,
    SUM(spend)                               AS total_spend,
    SUM(revenue)                             AS total_revenue,
    ROUND(SUM(revenue) / SUM(spend), 2)      AS roas,
    COUNT(*)                                 AS row_count
FROM marketing_raw
WHERE objective = 'Sales'
GROUP BY platform
ORDER BY roas DESC;


-- Query 2: Same ROAS, broken into its three levers
-- ROAS = conversion rate x revenue per conversion / CPC
SELECT
    platform,
    SUM(spend)                                          AS total_spend,
    SUM(revenue)                                        AS total_revenue,
    ROUND(SUM(revenue) / SUM(spend), 2)                 AS roas,
    COUNT(*)                                            AS row_count,
    SUM(impressions)                                    AS total_impressions,
    SUM(clicks)                                         AS total_clicks,
    ROUND(SUM(spend) / SUM(clicks), 2)                  AS cpc,
    SUM(conversions)                                    AS total_conversions,
    ROUND(SUM(spend) / SUM(conversions), 2)             AS cost_per_conversion,
    ROUND(SUM(revenue) / SUM(conversions), 2)           AS revenue_per_conversion,
    ROUND(100.0 * SUM(conversions) / SUM(clicks), 2)    AS conversion_rate_pct
FROM marketing_raw
WHERE objective = 'Sales'
GROUP BY platform
ORDER BY roas DESC;
