# world_layoffs

This project is a analysis of layoffs across different countries and industries.

The data is sourced from multiple CSV files, which are then combined into a single table. The data is then cleaned and transformed into a format that is suitable for analysis.

The analysis is conducted using SQL using various different techniques to clean and explore insights from the data.


## Adding an Existing CSV File to the Project

To add an existing CSV file from your desktop to this project, follow these steps:

1. Locate the CSV file on your desktop.

2. Create a new folder in your project directory called `data` (if it doesn't already exist).

3. Copy the CSV file from your desktop and paste it into the `data` folder of your project.

4. Update your SQL script to reference the new file location. For example, if your CSV file is named 'new_layoffs_data.csv', you would modify the LOAD DATA LOCAL INFILE command in your SQL script as follows:

   ```sql
   LOAD DATA LOCAL INFILE './data/new_layoffs_data.csv'
   INTO TABLE world_layoffs.layoffs
   FIELDS TERMINATED BY ','
   ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 ROWS
   (company, location, industry, total_laid_off, percentage_laid_off, @date, stage, country, funds_raised_millions)
   SET date = STR_TO_DATE(@date, '%m/%d/%Y');
   ```

5. Make sure to update your .gitignore file to include the data folder if you don't want to track the raw data files in your git repository:

   ```
   /data/*.csv
   ```

6. If you're using version control, commit these changes to your repository.

By following these steps, you'll successfully add your existing CSV file to the project and ensure it's properly integrated with your SQL scripts.



