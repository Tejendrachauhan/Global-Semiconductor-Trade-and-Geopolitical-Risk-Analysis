# Global-Semiconductor-Trade-and-Geopolitical-Risk-Analysis
SQL project analyzing global semiconductor trade flows to uncover business insights, market trends, trade patterns, and geopolitical risks.

## Dataset

Dataset: Global Semiconductor Trade & Company Profiles

Tables Used:
- Semiconductor Trade Flows
- Company Profiles
  
Source:
https://www.kaggle.com/datasets/moaz1911/global-ai-sovereignty-and-hardware-supply-chain

## Business Questions

1. Which countries export the most semiconductors?
2. Which countries import the most semiconductors?
3. Which semiconductor products are traded the most?
4. Which trade routes have the highest trade value?
5. Which countries trade with the largest number of partner countries and what are their names?
6. Which countries have the highest number of semiconductor companies?
7. Which semiconductor companies are headquartered in the world's top exporting countries?
8. Which countries have the highest number of companies with high geopolitical exposure?
9. Rank semiconductor companies by revenue within their own country.
10. Which countries dominate the global semiconductor ecosystem, and which are most geopolitically exposed?

## SQL Concepts Used

- SELECT
- GROUP BY
- ORDER BY
- LIMIT
- Aggregate Functions
- COUNT Functions
- GROUP_CONCAT()
- INNER JOIN
- LEFT JOIN
- Common Table Expressions (CTEs)
- Window Functions
- RANK()
- COALESCE()

## Files

- `SQL_Queries.sql` – Contains all SQL queries used in the project.
- `README.md` – Project documentation.

## Key Learnings

- Performed trade analysis using aggregate functions.
- Combined multiple tables using joins.
- Used CTEs to simplify complex queries.
- Applied window functions to rank companies by revenue.
- Analyzed geopolitical exposure across semiconductor companies.
- Built a final report combining exports, imports, trade partners, company count, and geopolitical exposure for each country.
