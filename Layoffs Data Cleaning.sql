USE world_layoffs;

CREATE TABLE layoffs_staging 
LIKE layoffs;

INSERT layoffs_staging 
SELECT * 
FROM layoffs;

-- Identify duplicates
WITH CTE AS ( 
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging)

SELECT *
FROM CTE
WHERE row_num >1;

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
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Get rid of duplicates
INSERT INTO layoffs_staging2
SELECT * FROM (SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging) AS sub
WHERE row_num=1;

-- Standardize data
UPDATE layoffs_staging2
SET company= TRIM(company);

SELECT * 
FROM layoffs_staging2
WHERE industry LIKE '%Crypto%';

UPDATE layoffs_staging2
SET industry= 'Crypto'
WHERE industry LIKE ('%Crypto%');

UPDATE layoffs_staging2
SET country= TRIM(TRAILING '.' FROM country)
WHERE country LIKE '%United States%';

SELECT DISTINCT country 
FROM layoffs_staging2
WHERE country LIKE '%United States%'
ORDER BY country;

-- Change 'date' data type
UPDATE layoffs_staging2
SET `date`= STR_TO_DATE( `date`,'%m/%d/%Y') ;

-- Fill nulls
SELECT * 
FROM layoffs_staging2
WHERE industry IS NULL
OR industry= '';

-- Filling industry blanks using same company non blank locations as reference
SELECT t1.company, t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
AND t1.location = t2.location
WHERE (t1.industry='' OR t1.industry IS NULL)
AND (t2.industry!='' AND  t2.industry IS NOT NULL);

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
AND t1.location = t2.location
SET t1.industry=t2.industry 
WHERE (t1.industry='' OR t1.industry IS NULL)
AND t2.industry IS NOT NULL;

-- Cleaning null values
DELETE
FROM layoffs_staging2 
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT * FROM layoffs_staging2;