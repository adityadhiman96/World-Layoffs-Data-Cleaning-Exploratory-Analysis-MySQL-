SELECT * FROM layoffs_staging;

-- Copying the data into new table --
#creating an empty table
CREATE TABLE layoffs_staging
LIKE layoffs;
# adding data
INSERT INTO layoffs_staging
SELECT * FROM layoffs;

-- Removing Duplicates --
# Step-1, Look for unique col, we don't have that in this case, so we assign row_num partitioned by every column in the table
WITH duplicate_cte AS (
SELECT *, ROW_NUMBER() OVER(
	partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging)

# Step-2, Look for the duplicate values (row_num>1)
SELECT * FROM duplicate_cte
WHERE row_num>1;

# Step-3, Create a second statging table (With copy and paste)
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  row_num INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM layoffs_staging2
WHERE row_num>1;

# Step-4, Insert into layoffs_staging2 table with select statement
INSERT INTO layoffs_staging2
SELECT *, ROW_NUMBER() OVER(
	partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging; 

# Step-5, Deleting the duplicate rows
DELETE FROM layoffs_staging2
WHERE row_num>1;

-- Duplicates have been successfully removed --