-- File: 10_traffic_cpc_by_platform_country.sql
-- Question: Is any country wasting Traffic spend compared to its own platform?
-- Scope: Traffic objective only, judged on CPC. Click guard (100+) in HAVING.
-- Method: Two layers. Layer 1 groups by platform and country. Layer 2 adds the
--         platform benchmark (SUM(spend) / SUM(clicks) per platform) with window
--         functions, then a ratio of each row's CPC to that benchmark.
--         Ratio is calculated from unrounded values and rounded only at the end.
-- Result: Highest ratio is 1.20 (Google Display, Iraq). No country is near the 1.5x
--         flag. LinkedIn's highest is Oman at 1.10. The cost problem is
--         platform wide (LinkedIn CPC $3.45), not country specific.
-- Caveat: Shows LinkedIn clicks are expensive, not whether the visitors were
--         worth more. Traffic has no revenue column. The 1.5x flag is a placeholder.

WITH by_country AS (
    SELECT
        platform,
        country,
        SUM(spend)                          AS total_spend,
        SUM(clicks)                         AS total_clicks,
        ROUND(SUM(spend) / SUM(clicks), 2)  AS cpc,
        COUNT(*)                            AS row_count
    FROM marketing_raw
    WHERE objective = 'Traffic'
    GROUP BY platform, country
    HAVING SUM(clicks) >= 100
)
SELECT
    platform,
    country,
    cpc,
    ROUND(
        SUM(total_spend) OVER (PARTITION BY platform)
      / SUM(total_clicks) OVER (PARTITION BY platform),
      2
    ) AS benchmark_cpc,
    ROUND(
        (total_spend / total_clicks)
      / (SUM(total_spend) OVER (PARTITION BY platform)
       / SUM(total_clicks) OVER (PARTITION BY platform)),
      2
    ) AS cpc_vs_benchmark
FROM by_country
ORDER BY platform, cpc_vs_benchmark DESC;
