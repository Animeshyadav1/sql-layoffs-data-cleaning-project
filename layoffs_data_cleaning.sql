/* =========================================================
   SQL DATA CLEANING PROJECT - LAYOFFS DATASET
   Project Type : Data Cleaning using MySQL
   Inspired By  : Alex The Analyst
   ========================================================= */


/* =========================================================
   STEP 1: Preview Original Dataset
   Checking the raw layoffs dataset before cleaning
   ========================================================= */

SELECT *
FROM layoffs;


/* =========================================================
   STEP 2: Create Staging Table
   Creating a duplicate table to perform cleaning operations
   without affecting the original dataset
   ========================================================= */

CREATE TABLE IF NOT EXISTS layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;


/* =========================================================
   STEP 3: Insert Data into Staging Table
   Copying raw data into the staging table
   ========================================================= */

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;


/* =========================================================
   STEP 4: Identify Duplicate Records
   Using ROW_NUMBER() window function to detect duplicates
   ========================================================= */

SELECT *,
ROW_NUMBER() OVER (
    PARTITION BY company, industry, total_laid_off,
                 percentage_laid_off, `date`
) AS row_num
FROM layoffs_staging;


/* =========================================================
   STEP 5: Display Duplicate Rows
   Filtering records where row number is greater than 1
   ========================================================= */

WITH duplicate_cte AS
(
    SELECT *,
    ROW_NUMBER() OVER (
        PARTITION BY company, industry, total_laid_off,
                     percentage_laid_off, `date`
    ) AS row_num
    FROM layoffs_staging
)

SELECT *
FROM duplicate_cte
WHERE row_num > 1;


/* =========================================================
   STEP 6: Create Second Staging Table
   Creating a new table including row_num column
   ========================================================= */

CREATE TABLE IF NOT EXISTS layoffs_staging2 (
    company TEXT,
    location TEXT,
    industry TEXT,
    total_laid_off INT DEFAULT NULL,
    percentage_laid_off TEXT,
    `date` TEXT,
    stage TEXT,
    country TEXT,
    funds_raised_millions INT DEFAULT NULL,
    row_num INT
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;


/* =========================================================
   STEP 7: Insert Data with Row Numbers
   Assigning row numbers to identify duplicates
   ========================================================= */

INSERT INTO layoffs_staging2

SELECT *,
ROW_NUMBER() OVER (
    PARTITION BY company, location, industry,
                 total_laid_off, percentage_laid_off,
                 `date`, stage, country,
                 funds_raised_millions
) AS row_num

FROM layoffs_staging;

SELECT *
FROM layoffs_staging2;


/* =========================================================
   STEP 8: Check Duplicate Records
   ========================================================= */

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;


/* =========================================================
   STEP 9: Remove Duplicate Records
   Keeping only unique records in dataset
   ========================================================= */

DELETE
FROM layoffs_staging2
WHERE row_num > 1;


/* =========================================================
   STEP 10: Standardize Company Names
   Removing unwanted leading/trailing spaces
   ========================================================= */

SELECT company,
TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);


/* =========================================================
   STEP 11: Explore Unique Industry Values
   ========================================================= */

SELECT DISTINCT industry
FROM layoffs_staging2;


/* =========================================================
   STEP 12: Explore Unique Locations
   ========================================================= */

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;


/* =========================================================
   STEP 13: Standardize Industry Names
   Converting all Crypto-related values into 'Crypto'
   ========================================================= */

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


/* =========================================================
   STEP 14: Standardize Country Names
   ========================================================= */

SELECT DISTINCT country,
TRIM(country)
FROM layoffs_staging2
ORDER BY 1;


/* =========================================================
   STEP 15: Convert Date Format
   Converting text dates into SQL date format
   ========================================================= */

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%y')
FROM layoffs_staging2;


/* =========================================================
   STEP 16: Check Rows with Missing Layoff Information
   ========================================================= */

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


/* =========================================================
   STEP 17: Identify Missing Industry Values
   ========================================================= */

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';


/* =========================================================
   STEP 18: Inspect Airbnb Records
   Used for validating missing industry information
   ========================================================= */

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';


/* =========================================================
   STEP 19: Find Matching Records Using Self Join
   Filling missing industries using existing company data
   ========================================================= */

SELECT *
FROM layoffs_staging2 t1

JOIN layoffs_staging2 t2
    ON t1.company = t2.company

WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


/* =========================================================
   STEP 20: Update Missing Industry Values
   Populating null/blank industries from matching records
   ========================================================= */

UPDATE layoffs_staging2 t1

JOIN layoffs_staging2 t2
    ON t1.company = t2.company

SET t1.industry = t2.industry

WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;