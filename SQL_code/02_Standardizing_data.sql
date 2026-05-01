-- Standardizing the data --
SELECT * FROM layoffs_staging2;

# Triming the company column
SELECT DISTINCT company FROM layoffs_staging2
ORDER BY company;
-- SELECT the findings
SELECT DISTINCT company, TRIM(company) FROM layoffs_staging2
ORDER BY company;
-- Update the findings
UPDATE layoffs_staging2
SET company=TRIM(company);

# industry column
SELECT DISTINCT industry FROM layoffs_staging2
ORDER BY 1;
-- Select the findings
SELECT * FROM layoffs_staging2 WHERE industry LIKE 'Crypto%';
-- update the findings
UPDATE layoffs_staging2
SET industry='Crypto'
WHERE industry LIKE 'Crypto%';

# location
SELECT DISTINCT location FROM layoffs_staging2;

# country (remove (.) after United States)
SELECT DISTINCT country FROM layoffs_staging2
ORDER BY 1;
-- Select the findings
SELECT * FROM layoffs_staging2
WHERE country like 'United States%';
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) FROM layoffs_staging2
ORDER BY 1;
-- Update the findings
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country like 'United States%';

# date column
SELECT date FROM layoffs_staging2;
-- Select the findings
SELECT date, 
STR_TO_DATE(date, '%m/%d/%Y')
FROM layoffs_staging2;
-- Update the findings
UPDATE layoffs_staging2
SET date=STR_TO_DATE(date, '%m/%d/%Y');
-- Alter the column type
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE; 

-- DONE --