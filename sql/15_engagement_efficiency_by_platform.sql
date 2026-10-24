-- File: 15_engagement_efficiency_by_platform.sql
-- Question: Which platforms deliver Engagement clicks at the lowest cost, and does each
--           platform's share of spend match its share of clicks?
-- Scope: Engagement objective only. Revenue is left out because Engagement has zero
--        revenue by design. The data has no likes, comments, or shares, so a click is
--        the only engagement signal available.
-- Method: Sum first, then divide for every ratio. CPC is a dollar amount, so no multiplier.
--         CTR is clicks over impressions, x100 because it is a percentage. CPM is x1000
--         because it is priced per thousand. Shares use SUM(SUM(x)) OVER (). The check
--         COUNT(*) against COUNT(DISTINCT campaign_id) shows the grain is about one row
--         per campaign. CPC = CPM / (CTR x 1,000) ties the three ratios together.
-- Result: LinkedIn took 19.18% of Engagement spend and delivered 2.49% of clicks.
--         Its CPC is $3.52, about 5.5x Google Display. Its CTR (0.71%) matches Google
--         Display (0.70%), so the gap is price per impression (CPM $25.05).
-- Caveat: A click shows interest, not depth. Google Search CTR is structurally high
--         (search intent), so compare LinkedIn to Meta, TikTok and Snapchat first.

SELECT
    platform,
    COUNT(*)                                                      AS total_rows,
    COUNT(DISTINCT campaign_id)                                   AS distinct_campaigns,
    SUM(spend)                                                    AS total_spend,
    ROUND(100.0 * SUM(spend) / SUM(SUM(spend)) OVER (), 2)        AS spend_share_pct,
    SUM(impressions)                                              AS total_impressions,
    SUM(clicks)                                                   AS total_clicks,
    ROUND(SUM(spend) / SUM(clicks), 2)                            AS cpc,
    ROUND(100.0 * SUM(clicks) / SUM(impressions), 2)              AS ctr,
    ROUND(SUM(spend) / SUM(impressions) * 1000, 2)                AS cpm,
    ROUND(100.0 * SUM(clicks) / SUM(SUM(clicks)) OVER (), 2)      AS click_share_pct
FROM marketing_raw
WHERE objective = 'Engagement'
GROUP BY platform
ORDER BY spend_share_pct;
