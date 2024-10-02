
-- create the table with field types
CREATE TABLE world_layoffs.layoffs (
    company VARCHAR(255),
    location VARCHAR(255),
    industry VARCHAR(255),
    total_laid_off INT,
    percentage_laid_off FLOAT,
    date DATE,
    stage VARCHAR(255),
    country VARCHAR(255),
    funds_raised_millions FLOAT
    );

SET GLOBAL local_infile = 1;

-- select the schema
USE world_layoffs;
-- load the data to the table 
LOAD DATA LOCAL INFILE '/Users/richiec/Downloads/layoffs.csv'
INTO TABLE world_layoffs.layoffs
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(company, location, industry, total_laid_off, percentage_laid_off, @date, stage, country, funds_raised_millions)
SET date = STR_TO_DATE(@date, '%m/%d/%Y');

SELECT COUNT(*) FROM world_layoffs.layoffs;