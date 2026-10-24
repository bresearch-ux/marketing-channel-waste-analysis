-- File: 08_traffic_cpc_by_platform.sql
-- Question: How much does a click cost on each platform for the Traffic objective?
-- Scope: Traffic objective only. Revenue is left out because Traffic has zero
--        revenue by design, so it is judged on cost per click, not ROAS.
-- Method: Sum first, then divide: CPC = SUM(spend) / SUM(clicks).
--         Never an average of row level CPCs. CPC is a dollar amount, so no x100.
-- Result: CPC runs from $0.22 (Google Search) to $3.45 (LinkedIn).
--         Order: Google Search 0.22, Snapchat 0.41, TikTok 0.50, Meta 0.55,
--         Google Display 0.59, LinkedIn 3.45.
--         LinkedIn's CPC is about 5.8x the next highest platform. It took about 21%
--         of Traffic spend but delivered under 3% of the clicks.
-- Caveat: This table gives each platform's benchmark CPC. It is not the waste test.
--         A platform compared to itself is always 1.0x, so the test happens at
--         a lower level against these benchmarks. Traffic has no revenue column,
--         so this shows LinkedIn is expensive per click, not that its clicks are
--         worth less.

SELECT
    platform,
    SUM(spend)                              AS total_spend,
    SUM(clicks)                             AS total_clicks,
    ROUND(SUM(spend) / SUM(clicks), 2)      AS cpc,
    COUNT(*)                                AS row_count
FROM marketing_raw
WHERE objective = 'Traffic'
GROUP BY platform
ORDER BY cpc;
