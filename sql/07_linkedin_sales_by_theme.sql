-- File: 07_linkedin_sales_by_theme.sql
-- Question: Is LinkedIn's low Sales ROAS concentrated in certain ad themes?
-- Scope: LinkedIn, Sales objective only
-- Method: Same query as file 06 with theme in place of country.
-- Result: No theme reached a ROAS of 1.0. Nothing inside LinkedIn Sales works well
--         enough to keep while cutting the rest.
-- Caveat: Synthetic data, so this shows the method and the pattern.

SELECT
    theme,
    SUM(spend)                              AS total_spend,
    SUM(revenue)                            AS total_revenue,
    ROUND(SUM(revenue) / SUM(spend), 2)     AS roas,
    ROUND(SUM(spend) / SUM(clicks), 2)      AS cpc,
    ROUND(SUM(revenue) / SUM(clicks), 2)    AS revenue_per_click,
    COUNT(*)                                AS row_count
FROM marketing_raw
WHERE platform = 'LinkedIn'
  AND objective = 'Sales'
GROUP BY theme
ORDER BY roas;
