-- File: 11_spend_share_by_platform.sql
-- Question: How much of the total budget does each platform take?
-- Scope: All objectives. This is the "how much money are we talking about" view,
--        so nothing is filtered out.
-- Method: Two steps. The CTE (by_platform) collapses the 30,000 rows into one row
--         per platform with its total spend. The final SELECT uses a window
--         function, SUM(total_spend) OVER (), to get the grand total next to every
--         platform row, so each platform's share is its spend divided by that total.
--         ROUND is applied only at the end.
-- Result: Total spend is about $12.6 million (synthetic data).
--         Google Search 21.72%, Meta 20.87%, LinkedIn 20.23%, TikTok 16.55%,
--         Snapchat 11.48%, Google Display 9.16%.
--         LinkedIn is the third largest line in the budget, about a fifth of all
--         spend, and it is the weakest platform on both Sales ROAS (0.44) and
--         Traffic CPC ($3.45).
-- Note: Rounded shares may add up to 99.99 or 100.01. That is rounding, not an error.

WITH by_platform AS (
    SELECT
        platform,
        SUM(spend) AS total_spend
    FROM marketing_raw
    GROUP BY platform
)
SELECT
    platform,
    total_spend,
    ROUND(100.00 * total_spend / SUM(total_spend) OVER (), 2) AS share_pct
FROM by_platform
ORDER BY share_pct DESC;
