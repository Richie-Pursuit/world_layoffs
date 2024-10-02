
SELECT * FROM world_layoffs.layoffs;

-- 1) Remove duplicates
-- 2) Standardize the data (issues w/ spelling)
-- 3) Null Values or blank values
-- 4) Remove Any Columns that are irrelevant 

-- create a new table
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * FROM layoffs_staging;

-- insert data into new table
INSERT layoffs_staging
SELECT *
FROM layoffs;

-- remove dupl




-- create a cte to see row num with more than 1
WITH duplicate_cte AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions)
AS row_num
FROM world_layoffs.layoffs_staging
)

SELECT *
FROM duplicate_cte
WHERE row_num > 1;


-- creating a new table

CREATE TABLE `layoffs_staging2` (
  `company` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `industry` varchar(255) DEFAULT NULL,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` float DEFAULT NULL,
  `date` date DEFAULT NULL,
  `stage` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `funds_raised_millions` float DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- find dupl rows based on fields
INSERT INTO `layoffs_staging2`
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions)
AS row_num
FROM world_layoffs.layoffs_staging;

-- delete rows with more than 1
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

-- ----------------------------- -- 

-- Standardizing Data 

SELECT company, TRIM(company) 
FROM layoffs_staging2;

SET SQL_SAFE_UPDATES = 0;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- look to see different industries
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

-- update so that the Crypto Industry can be all one name instead of "crypto, crypto currency" categories
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- look to see different countries
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

-- removes dots after using trail
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE '%United States%';

-- change date format
-- SELECT `date`,
-- STR_TO_DATE(`date`, '%m%/%d/%Y')
-- FROM layoffs_staging2;

-- ALTER TABLE
-- MODIFY COLUMN `date` DATE;

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT * 
FROM layoffs_staging2
WHERE company = 'Airbnb';


-- we want to populate the empty data with data that already exists
-- for example industry for Airbnb is a "" and another row that says 'Travel'
-- we want to populate that data 


SELECT t1.industry, t2.industry 
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- convert blanks to nulls
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = "";

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


-- deleting where total laid off and percentage are both NULL
DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- removing row_num from table
ALTER TABLE layoffs_staging2
DROP row_num;