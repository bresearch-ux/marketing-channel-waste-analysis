-- File: 06_linkedin_sales_by_country.sql
-- Question: Is LinkedIn's low Sales ROAS concentrated in certain countries?
-- Scope: LinkedIn, Sales objective only
-- Method: Same ratios as file 05, grouped by country. CPC and revenue per click are
--         dollar amounts, so no x100.
-- Result: ROAS ranges only 0.39 (KSA) to 0.52 (Qatar). All 12 countries are below 1.0,
--         and every CPC is more than double its revenue per click. No pocket found.
--         The problem is platform wide.
-- Caveat: Synthetic data, so this shows the method and the pattern.

SELECT
    country,
    SUM(spend)                              AS total_spend,
    SUM(revenue)                            AS total_revenue,
    ROUND(SUM(revenue) / SUM(spend), 2)     AS roas,
    ROUND(SUM(spend) / SUM(clicks), 2)      AS cpc,
    ROUND(SUM(revenue) / SUM(clicks), 2)    AS revenue_per_click,
    COUNT(*)                                AS row_count
FROM marketing_raw
WHERE platform = 'LinkedIn'
  AND objective = 'Sales'
GROUP BY country
ORDER BY roas;
