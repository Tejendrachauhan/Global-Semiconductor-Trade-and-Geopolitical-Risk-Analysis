CREATE DATABASE semiconductor_trade_db;
USE semiconductor_trade_db;

-- 1. Which countries export the most semiconductors?

SELECT exporter_country, SUM(volume_units) AS total_volume_units
FROM `01_semiconductor_trade_flows`
GROUP BY exporter_country
ORDER BY sum(volume_units) DESC
LIMIT 1;

-- 2. Which countries import the most semiconductors?

SELECT importer_country,SUM(volume_units) AS total_volume_units
FROM 01_semiconductor_trade_flows
GROUP BY importer_country
ORDER BY sum(volume_units) DESC
LIMIT 1;

-- 3. Which semiconductor products are traded the most?

SELECT hardware_type,SUM(volume_units) AS total_volume_units
FROM 01_semiconductor_trade_flows
GROUP BY hardware_type
ORDER BY sum(volume_units) DESC
LIMIT 1;

-- 4. Which trade routes have the highest trade value?

SELECT trade_route,SUM(trade_value_usd_millions) AS total_trade_value
FROM 01_semiconductor_trade_flows
GROUP BY trade_route
ORDER BY sum(trade_value_usd_millions) DESC
limit 1;

-- 5. Which countries trade with the largest number of partner countries and Their names ?

SELECT 
exporter_country, 
count(DISTINCT importer_country) AS Partner_Countries, 
GROUP_CONCAT(DISTINCT importer_country ORDER BY importer_country SEPARATOR ', ') AS Partner_Names
FROM 01_semiconductor_trade_flows
GROUP BY exporter_country
ORDER BY Partner_Countries DESC;

-- 6. Which countries have the highest number of semiconductor companies ?

SELECT hq_country, count(DISTINCT company_name) AS Semicondutor_comapnies
FROM 06_company_profiles
GROUP BY hq_country
ORDER BY count(DISTINCT company_name) desc
LIMIT 1;

-- 7. Which semiconductor companies are headquartered in the world's top exporting countries?

Select DISTINCT cp.company_name, cp.hq_country, t.highest_exporter
FROM 06_company_profiles as cp
INNER JOIN
(SELECT exporter_country, sum(volume_units) as highest_exporter
FROM 01_semiconductor_trade_flows as tf
GROUP BY exporter_country
ORDER BY highest_exporter DESC
LIMIT 10
) AS t
ON t.exporter_country = cp.hq_country
ORDER BY t.highest_exporter DESC;

-- Which countries have the highest number of 'High' geopolitical exposure companies?

SELECT tf.exporter_country, 
COUNT(DISTINCT gp.company_name) as company_count
FROM 01_semiconductor_trade_flows as tf
INNER JOIN
(
SELECT DISTINCT cp.company_name, cp.geopolitical_exposure, cp.hq_country
FROM 06_company_profiles as cp
WHERE cp.geopolitical_exposure = 'High'
) as gp
ON tf.exporter_country = gp.hq_country
GROUP BY tf.exporter_country
ORDER BY company_count DESC;

-- Rank companies by revenue within their own country

SELECT company_name, hq_country, revenue_usd_bn,
RANK() OVER (PARTITION BY hq_country ORDER BY revenue_usd_bn DESC) AS Rank_Companies
FROM 06_company_profiles
WHERE year=2025;

-- Which countries dominate the global semiconductor ecosystem, and which are most geopolitically exposed?

WITH export AS
(
SELECT
exporter_country,
SUM(volume_units) AS total_exports
FROM 01_semiconductor_trade_flows
GROUP BY exporter_country
),

import AS
(
SELECT
importer_country,
SUM(volume_units) AS total_imports
FROM 01_semiconductor_trade_flows
GROUP BY importer_country
),

partner_countries AS
(
SELECT
exporter_country,
COUNT(DISTINCT importer_country) AS trade_partners
FROM 01_semiconductor_trade_flows
GROUP BY exporter_country
),

Semiconductor_companies AS
(
SELECT
hq_country,
COUNT(DISTINCT company_name) AS semiconductor_companies
FROM 06_company_profiles
GROUP BY hq_country
),

Geopolitical_Exposure AS
(
SELECT
cp.hq_country,
COUNT(DISTINCT cp.company_name) AS high_exposure_companies
FROM 06_company_profiles cp
WHERE cp.geopolitical_exposure = 'High'
GROUP BY cp.hq_country
),

Revenue AS
(
SELECT
company_name,
hq_country,
revenue_usd_bn,
RANK() OVER
(
PARTITION BY hq_country
ORDER BY revenue_usd_bn DESC
) AS rank_companies
FROM 06_company_profiles
WHERE year = 2025
)

SELECT
e.exporter_country AS country,
e.total_exports,
COALESCE(i.total_imports, 0) AS total_imports,
pc.trade_partners,
COALESCE(sc.semiconductor_companies, 0) AS semiconductor_companies,
COALESCE(ge.high_exposure_companies,0) AS high_exposure_companies

FROM export e
LEFT JOIN import i
ON e.exporter_country = i.importer_country

LEFT JOIN partner_countries pc
ON e.exporter_country = pc.exporter_country

LEFT JOIN Semiconductor_companies sc
ON e.exporter_country = sc.hq_country

LEFT JOIN Geopolitical_Exposure ge
ON e.exporter_country = ge.hq_country

ORDER BY
e.total_exports DESC,
sc.semiconductor_companies DESC,
pc.trade_partners DESC;


































