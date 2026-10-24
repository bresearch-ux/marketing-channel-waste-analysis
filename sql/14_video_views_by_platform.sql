-- File: 14_video_views_by_platform.sql
-- Question: Which platforms deliver video views at the lowest cost, and does each
--           platform's share of spend match its share of views?
-- Scope: Video Views objective only. Revenue is left out because Video Views has
--        zero revenue by design, so it is judged on cost per view and view rate.
-- Method: Sum first, then divide for every ratio. Cost per view is a dollar amount,
--         so no multiplier. View rate is a percentage, so x100 (100.0 forces decimal
--         math). The shares use SUM(SUM(x)) OVER (): the inner SUM is the platform
--         total, the outer window SUM adds those platform totals into a grand total.
-- Result: LinkedIn took about 20% of Video Views spend but delivered about 6% of the
--         views. Its cost per view ($0.13) is about 1.8x Google Search and about 6x
--         Snapchat. View rates are similar everywhere (18.5% to 21.1%), so the gap
--         is price per impression, not viewer interest.
-- Caveat: The data does not define what counts as a "view" on each platform.

SELECT
    platform,
    SUM(spend)                                                          AS total_spend,
    ROUND(100.0 * SUM(spend) / SUM(SUM(spend)) OVER (), 2)              AS spend_share_pct,
    SUM(video_views)                                                    AS total_video_views,
    ROUND(100.0 * SUM(video_views) / SUM(SUM(video_views)) OVER (), 2)  AS view_share_pct,
    SUM(impressions)                                                    AS total_impressions,
    ROUND(SUM(spend) / SUM(video_views), 4)                             AS cost_per_view,
    ROUND(100.0 * SUM(video_views) / SUM(impressions), 2)               AS view_rate_pct,
    COUNT(*)                                                            AS row_count
FROM marketing_raw
WHERE objective = 'Video Views'
GROUP BY platform
ORDER BY cost_per_view;
