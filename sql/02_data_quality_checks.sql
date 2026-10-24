-- File: 02_data_quality_checks.sql
-- Question: Does the data contain impossible values that would break the analysis?
-- Scope: All 30,000 rows.
-- Method: COUNT(*) FILTER (WHERE ...) counts the rows that break each rule, all in
--         one pass. A count above 0 means we would look at those campaigns.
-- Result: All four checks returned 0 on the 30,000 row table.
-- Caveat: These checks catch impossible values, not wrong but possible ones.

SELECT
    COUNT(*) FILTER (WHERE clicks > impressions)        AS clicks_over_impressions,
    COUNT(*) FILTER (WHERE spend < 0
                        OR revenue < 0
                        OR clicks < 0
                        OR conversions < 0)             AS neg_num,
    COUNT(*) FILTER (WHERE conversions > clicks)        AS conv_over_clicks,
    COUNT(*) FILTER (WHERE spend = 0)                   AS no_spend
FROM marketing_raw;
