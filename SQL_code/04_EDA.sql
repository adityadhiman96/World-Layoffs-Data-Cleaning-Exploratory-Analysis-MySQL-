-- EXPLORATORY DATA ANALYSIS --
SELECT * 
FROM layoffs_staging2;

SELECT MAX(total_laid_off),  MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off=1
ORDER BY total_laid_off DESC; 

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off=1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(date), MAX(date) 
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(date), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

# Rolling Total monthly
SELECT substring(date, 1,7) AS month, SUM(total_laid_off)
FROM layoffs_staging2
WHERE substring(date, 1,7) is NOT NULL
GROUP BY month
ORDER BY 1 ASC;

WITH rolling_total AS (
SELECT substring(date, 1,7) AS month, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE substring(date, 1,7) is NOT NULL
GROUP BY month )
SELECT month, total_off, SUM(total_off) OVER(ORDER BY month) AS rolling_total
FROM rolling_total;


# Ranking the top 5 company laid off by year
WITH company_year AS (
SELECT company, YEAR(date) AS `years`, sum(total_laid_off) as total_laid_off
FROM layoffs_staging2
WHERE YEAR(date) IS NOT NULL
GROUP BY company, YEAR(date)
),
company_year_rank AS (
SELECT *, dense_rank() OVER(partition by `years` ORDER BY total_laid_off DESC) as ranking
FROM company_year
)
SELECT * FROM company_year_rank
WHERE ranking<=5;

# Ranking the top 5 Industries laid off by year
WITH ind_year AS (
SELECT industry, YEAR(date) AS `years`, sum(total_laid_off) as total_laid_off
FROM layoffs_staging2
WHERE YEAR(date) IS NOT NULL
GROUP BY industry, YEAR(date)
),
ind_year_rank AS (
SELECT *, dense_rank() OVER(partition by `years` ORDER BY total_laid_off DESC) as ranking
FROM ind_year
)
SELECT * FROM ind_year_rank
WHERE ranking<=5;

-- YoY Change -- 
WITH yearly_layoffs AS (
    SELECT YEAR(date) AS year, 
           SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    WHERE YEAR(date) IS NOT NULL
    GROUP BY YEAR(date)
)
SELECT *,
       LAG(total_laid_off) OVER(ORDER BY year) AS prev_year,
       (total_laid_off - LAG(total_laid_off) OVER(ORDER BY year)) AS yoy_change
FROM yearly_layoffs;

-- Industry Percentage Share -- 
SELECT industry,
       SUM(total_laid_off) AS total_laid_off,
       ROUND(100 * SUM(total_laid_off) / 
            SUM(SUM(total_laid_off)) OVER(), 2) AS percentage_share
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_laid_off DESC;
