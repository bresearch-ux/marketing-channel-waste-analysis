-- File: 12_reach_cpm_by_platform.sql
-- Question: What does it cost to reach people on each platform for the Reach objective?
-- Scope: Reach objective only. Revenue is left out because Reach has zero revenue by design.
-- Method: CPM = SUM(spend) / SUM(impressions) * 1000. Sum first, then divide.
-- Result: CPM runs from $4.15 (Snapchat) to $25.26 (LinkedIn). Google Search is
--         $13.62 even though it was cheapest on Traffic CPC.
-- Caveat: CPM measures cost per impression, not whether the right people saw the ad.

SELECT
    platform,
    SUM(spend)                                       AS total_spend,
    SUM(impressions)                                 AS total_impressions,
    ROUND(SUM(spend) / SUM(impressions) * 1000, 2)   AS cpm,
    COUNT(*)                                         AS row_count
FROM marketing_raw
WHERE objective = 'Reach'
GROUP BY platform
ORDER BY cpm;
