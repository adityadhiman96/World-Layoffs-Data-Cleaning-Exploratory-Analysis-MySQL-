-- DEALING WITH NULL OR BLANK VALUES --
SELECT * FROM layoffs_staging2;

# Industry column
-- Select the findings
SELECT DISTINCT industry FROM layoffs_staging2;

SELECT * FROM layoffs_staging2 WHERE industry IS NULL OR industry=''; # NULL and Blank Values

SELECT * FROM layoffs_staging2 WHERE company='Airbnb'; # Check if other Rows with same industry have information on industry

#Update industry as NULL where it was BLANK
UPDATE layoffs_staging2
SET industry=NULL
WHERE industry='';

# Match the columns where industry is present to columns where it is Null/Blank
SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company=t2.company
    AND t1.location=t2.location
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

# Update th NULL using the same logic as SELECT statement
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company=t2.company
    AND t1.location=t2.location
SET t1.industry=t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

# check table
SELECT * FROM layoffs_staging2 WHERE company='Airbnb';
SELECT * FROM layoffs_staging2 WHERE industry IS NULL OR industry='';
SELECT * FROM layoffs_staging2 WHERE company  LIKE 'Bally%';

-- REMOVING THE RECORDS --
SELECT * FROM layoffs_staging2;

SELECT * FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL; 
# We have no way to populate these with the given data. So we chose to delete these rows

DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

