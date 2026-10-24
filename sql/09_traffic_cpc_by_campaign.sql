-- File: 09_traffic_cpc_by_campaign.sql
-- Question: Can we find wasteful Traffic campaigns by comparing campaign level CPC?
-- Scope: Traffic objective only. Revenue is not used because Traffic has zero
--        revenue by design, so it is judged on cost per click.
-- Method: Sum first, then divide: CPC = SUM(spend) / SUM(clicks).
--         The 100 click guard is in HAVING, not WHERE, because it applies to a
--         campaign's total clicks, not to a single row. HAVING repeats SUM(clicks)
--         instead of the total_clicks alias, since aliases don't exist yet when
--         HAVING runs.
-- Result: 5,527 Traffic rows and 5,365 distinct campaigns, about 1.03 rows per
--         campaign. 4,122 campaigns passed the 100 click guard.
-- Caveat: Because each campaign is about one ad day, campaign level CPC is a
--         diagnostic only, not a waste list. The waste test needs a grain with
--         enough rows per group (see file 10).


-- Query 1: Grain check. How many rows does a campaign really have?
SELECT
    COUNT(*)                     AS total_rows,
    COUNT(DISTINCT campaign_id)  AS distinct_campaigns
FROM marketing_raw
WHERE objective = 'Traffic';


-- Query 2: CPC by campaign within each platform
SELECT
    platform,
    campaign_id,
    SUM(spend)                              AS total_spend,
    SUM(clicks)                             AS total_clicks,
    ROUND(SUM(spend) / SUM(clicks), 2)      AS cpc,
    COUNT(*)                                AS row_count
FROM marketing_raw
WHERE objective = 'Traffic'
GROUP BY platform, campaign_id
HAVING SUM(clicks) >= 100
ORDER BY platform, cpc DESC;
