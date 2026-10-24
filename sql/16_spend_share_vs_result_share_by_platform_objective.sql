-- File: 16_spend_share_vs_result_share_by_platform_objective.sql
-- Question: Which platforms get more budget than the results they deliver?
-- Scope: All six platforms and all six objectives, one row per platform and objective.
--        This is the dataset behind the Power BI dashboard.
-- Method: Spend share is each platform's spend divided by total spend within the
--         objective. Result share uses each objective's own result measure (Sales revenue,
--         Leads conversions, Traffic and Engagement clicks, Video Views video_views,
--         Reach reach), also as a share within the objective. Both use
--         SUM(SUM(x)) OVER (PARTITION BY objective), so each objective adds to about 100.
-- Result: LinkedIn has about 20% of spend and 1.7% to 6.1% of results in every objective.
-- Caveat: Result measures differ by objective, so compare shares within an objective only.
--         Reach is summed across rows, so it is approximate.

SELECT
	platform,
	objective,
	ROUND(100.0*SUM(spend)/SUM(SUM(spend)) OVER(PARTITION BY objective),2) AS spend_share_pct,
	 ROUND(100.0 * SUM(
              CASE objective
                  WHEN 'Sales'       THEN revenue
                  WHEN 'Leads'       THEN conversions
                  WHEN 'Traffic'     THEN clicks
                  WHEN 'Engagement'  THEN clicks
                  WHEN 'Video Views' THEN video_views
                  WHEN 'Reach'       THEN reach
                  ELSE NULL
              END)
          / SUM(SUM(
              CASE objective
                  WHEN 'Sales'       THEN revenue
                  WHEN 'Leads'       THEN conversions
                  WHEN 'Traffic'     THEN clicks
                  WHEN 'Engagement'  THEN clicks
                  WHEN 'Video Views' THEN video_views
                  WHEN 'Reach'       THEN reach
                  ELSE NULL
              END)) OVER (PARTITION BY objective), 2) AS result_share_pct
FROM marketing_raw
GROUP BY platform,objective
ORDER BY objective,spend_share_pct DESC;
