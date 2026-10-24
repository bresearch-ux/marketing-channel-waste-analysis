-- File: 13_reach_efficiency_by_platform.sql
-- Question: How efficiently does each platform deliver awareness on the Reach objective,
--           and does that reach lead to any clicks or conversions?
-- Scope: Reach objective only. Revenue is left out because Reach has zero revenue by design,
--        so it is judged on the cost of being seen, not on ROAS.
-- Method: Sum first, then divide for every ratio (never average row level ratios).
--         CPM and cost per 1,000 reached use x1000 because they are priced per thousand.
--         Click rate uses x100 because it is a percentage.
-- Result: LinkedIn is the most expensive platform for awareness: CPM $25.26 and about
--         $48.48 per 1,000 people reached, against $4.15 and $8.04 on Snapchat.
--         LinkedIn recorded only 16 conversions on about 26.1M impressions.
--         Frequency is about 1.9 on every platform, so the gap is price, not repeat exposure.
-- Caveat: Cost per conversion on Reach rows is a rough side measure, not a return.
--         The data cannot show audience quality or brand lift.
--         Reach summed across rows is an approximation of unique people, so frequency
--         and cost per 1,000 reached are for comparing platforms, not exact counts.

SELECT
    platform,
    SUM(spend)                                              AS total_spend,
    SUM(impressions)                                        AS total_impressions,
    SUM(reach)                                              AS total_reach,
    ROUND(SUM(spend) / SUM(impressions) * 1000, 2)          AS cpm,
    ROUND(SUM(spend) / SUM(reach) * 1000, 2)                AS cost_per_1000_reached,
    ROUND(SUM(impressions)::numeric / SUM(reach), 2)        AS frequency,
    SUM(clicks)                                             AS total_clicks,
    ROUND(100.0 * SUM(clicks) / SUM(impressions), 2)        AS click_rate_pct,
    SUM(conversions)                                        AS total_conversions,
    COUNT(*)                                                AS row_count
FROM marketing_raw
WHERE objective = 'Reach'
GROUP BY platform
ORDER BY cpm;
