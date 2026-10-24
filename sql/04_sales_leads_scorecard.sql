-- File: 04_sales_leads_scorecard.sql
-- Question: What return did the two revenue objectives deliver?
-- Scope: Sales and Leads only, since the other objectives have zero revenue by design.
-- Method: ROAS = SUM(revenue) / SUM(spend). Sum first, then divide.
--         WHERE objective IN (...) is the right way to match two values.
--         (objective = 'Sales' AND 'Leads' is not valid, and one row can't be both.)
-- Result: Sales ROAS 4.96, Leads ROAS 2.34. Sales returns about $4.96 of revenue for
--         every $1 spent, and Leads returns about $2.34.
-- Caveat: Leads revenue is a proxy value assigned by the dataset author, so compare
--         Sales to Sales and Leads to Leads only.

SELECT
    objective,
    SUM(spend)                       AS total_spend,
    SUM(revenue)                     AS total_revenue,
    ROUND(SUM(revenue) / SUM(spend), 2) AS roas
FROM marketing_raw
WHERE objective IN ('Sales', 'Leads')
GROUP BY objective;
