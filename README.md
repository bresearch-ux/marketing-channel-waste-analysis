# Which Marketing Channels Are Wasting Spend?

A SQL (PostgreSQL) and Power BI analysis of marketing spend across six platforms and six campaign objectives.

**Question:** Which platforms get more budget than the results they deliver?

**Finding:** LinkedIn takes about 20% of spend on every objective and returns only 1.7% to 6.1% of the results. The cause is mostly price (cost per thousand impressions of about $25, against $4 to $14 on other platforms), not audience behavior. In Sales, Google Search took 21.92% of spend and produced 74.06% of revenue, but its average return is not a promise about the next dollar.

**Recommendation (a hypothesis to test, not a conclusion):** Cut LinkedIn's non conversion budgets by roughly half, move that money to cheaper platforms, and keep a capped LinkedIn test running. Shift budget in steps of 10 to 20% and check cost per click and ROAS after each step.

## What Is In This Repo

- `write-up.pdf` The full write up: business question, data and method, findings, recommendation, limitations.
- `dashboard/` The Power BI file (`.pbix`), a PDF export of the page, and `q16_spend_share_vs_result_share.csv`, the dataset behind the dashboard.
- `sql/` The queries, numbered in the order the analysis was done. Each file has a comment header with the question, scope, method, result, and caveat.

## How It Was Built

1. `sql/00_create_table_and_load.sql` creates the `marketing_raw` table and loads the CSV.
2. Files 01 to 05 check the data and set up the Sales and Leads return (ROAS).
3. Files 06 to 15 drill into LinkedIn, Traffic, Reach, Video Views, and Engagement, each judged on its own yardstick.
4. File 16 builds the dashboard dataset: each platform's share of spend next to its share of results, within each objective.

Method rules used throughout: never average ratios (sum the numerator and the denominator, then divide), never blend objectives in one query, and compare shares only within one objective.

## Data

MENA Digital Marketing Performance Dataset on Kaggle by alinaboulsi, licensed CC BY-SA 4.0 (add the Kaggle link here). The dataset is synthetic and benchmark based, and its own README says it should not be used for real budget decisions. This project shows a method and a pattern, not real account performance. Please credit the author, and share derivative work under the same license.

## Limitations

No profit margin, Leads revenue is a modeled proxy, summed reach is approximate, clicks are the only engagement signal, and the data has no audience, targeting, or creative columns.
