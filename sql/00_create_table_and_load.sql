-- File: 00_create_table_and_load.sql
-- Question: How do we get the MENA Digital Marketing dataset into PostgreSQL?
-- Scope: One table, marketing_raw, in the october_project schema (database "Practice").
-- Method: Load the CSV as is, keep the date as text (DD/MM/YYYY), then convert it
--         into a real DATE column with TO_DATE.
-- Result: 30,000 rows, 35 columns (36 after adding ad_date), 2023-01-01 to 2025-12-31.
-- Caveat: Run SET search_path first, or every query needs the october_project. prefix.
--         Change the \copy path to wherever the CSV lives on your machine.

SET search_path TO october_project, public;

CREATE TABLE marketing_raw (
    date_raw         TEXT,
    year             INTEGER,
    month            INTEGER,
    month_name       TEXT,
    week             INTEGER,
    day_of_week      TEXT,
    post_hour        INTEGER,
    season           TEXT,
    is_holiday       INTEGER,
    is_holiday_text  TEXT,
    is_weekend       INTEGER,
    is_weekend_text  TEXT,
    country          TEXT,
    market_tier      TEXT,
    account          TEXT,
    account_type     TEXT,
    platform         TEXT,
    placement        TEXT,
    funnel_stage     TEXT,
    objective        TEXT,
    theme            TEXT,
    campaign_id      TEXT,
    campaign_name    TEXT,
    ad_group_id      TEXT,
    ad_group_name    TEXT,
    ad_id            TEXT,
    ad_name          TEXT,
    spend            NUMERIC,
    impressions      BIGINT,
    reach            BIGINT,
    frequency        NUMERIC,
    clicks           BIGINT,
    conversions      BIGINT,
    revenue          NUMERIC,
    video_views      BIGINT
);

-- Run this in psql (the \copy command does not work in a normal query tab):
-- \copy marketing_raw FROM 'your/path/digital_marketing_dataset_30k.csv' WITH (FORMAT csv, HEADER true);

-- Convert the DD/MM/YYYY text into a real date
ALTER TABLE marketing_raw ADD COLUMN ad_date DATE;

UPDATE marketing_raw
SET ad_date = TO_DATE(date_raw, 'DD/MM/YYYY');

-- Check it worked
SELECT COUNT(*) FROM marketing_raw;
SELECT MIN(ad_date), MAX(ad_date) FROM marketing_raw;
