
# Layoffs Data Analysis

## **Overview**

This project involves the analysis of layoffs data using SQL for data cleaning and exploration. The goal is to identify trends, patterns, and key insights about layoffs across various companies, locations, and industries.

## **Table of Contents**

- [Introduction](#introduction)
- [Data Description](#data-description)
- [SQL Scripts](#sql-scripts)
- [Data Cleaning Process](#data-cleaning-process)
- [Exploratory Data Analysis (EDA)](#exploratory-data-analysis-eda)
- [Key Insights](#key-insights)
- [How to Use](#how-to-use)
- [Conclusion](#conclusion)

## **Introduction**

The Layoffs Data Analysis project utilizes SQL for comprehensive data cleaning and exploratory data analysis. The dataset includes information on layoffs, such as company names, locations, industries, total laid-off employees, and more. The analysis aims to uncover significant patterns and insights.

## **Data Description**

The dataset contains the following columns:
- **company:** Name of the company
- **location:** Location of the company
- **industry:** Industry category
- **total_laid_off:** Total number of employees laid off
- **percentage_laid_off:** Percentage of the workforce laid off
- **date:** Date of the layoffs
- **stage:** Company stage
- **country:** Country of the company
- **funds_raised_millions:** Funds raised by the company in millions

## **SQL Scripts**

The SQL scripts used in this project include:
1. **Creating and Populating Tables:** Creating new tables and inserting data.
2. **Removing Duplicates:** Using CTEs and row number to identify and remove duplicates.
3. **Standardizing Data:** Cleaning and standardizing text fields (e.g., trimming spaces, standardizing names).
4. **Handling Missing Values:** Identifying and filling or removing missing values.
5. **Data Type Conversion:** Converting date fields to proper date formats.
6. **Exploratory Data Analysis (EDA):** Aggregating and summarizing data to extract insights.

## **Data Cleaning Process**

1. **Creating a Separate Table for Operations:**
    ```sql
    CREATE TABLE LAYOFF2 LIKE layoffs;
    INSERT INTO LAYOFF2 SELECT * FROM layoffs;
    ```

2. **Removing Duplicates:**
    ```sql
    WITH CTE_1 AS (
        SELECT *, row_number() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS ROW_NUM
        FROM LAYOFF2
    )
    DELETE FROM CTE_1 WHERE ROW_NUM > 1;
    ```

3. **Standardizing Data:**
    ```sql
    UPDATE LAYOFF2_2 SET company = TRIM(company);
    UPDATE LAYOFF2_2 SET location = 'Dusseldorf' WHERE location LIKE '%ldorf';
    UPDATE LAYOFF2_2 SET industry = 'Crypto' WHERE industry LIKE 'Crypto%';
    UPDATE LAYOFF2_2 SET country = TRIM(TRAILING '.' FROM country);
    ```

4. **Handling Missing Values:**
    ```sql
    UPDATE LAYOFF2_2 t1
    JOIN LAYOFF2_2 t2 ON t1.company = t2.company AND t1.location = t2.location
    SET t1.industry = t2.industry
    WHERE t1.industry IS NULL;
    ```

5. **Converting Date Fields:**
    ```sql
    UPDATE LAYOFF2_2 SET date = STR_TO_DATE(date, '%m/%d/%y');
    ALTER TABLE LAYOFF2_2 MODIFY COLUMN date DATE;
    ```

6. **Removing Unnecessary Columns:**
    ```sql
    ALTER TABLE LAYOFF2_2 DROP COLUMN ROW_NUM;
    ```

## **Exploratory Data Analysis (EDA)**

1. **Total Number of Laid-off Employees:**
    ```sql
    SELECT SUM(total_laid_off) AS TOTAL_NO_LAIDOFF FROM LAYOFF2_2;
    ```

2. **Companies with Highest Layoffs:**
    ```sql
    SELECT company, SUM(total_laid_off) FROM LAYOFF2_2 GROUP BY company ORDER BY 2 DESC;
    ```

3. **Industries with Highest Layoffs:**
    ```sql
    SELECT industry, SUM(total_laid_off) FROM LAYOFF2_2 GROUP BY industry ORDER BY 2 DESC;
    ```

4. **Companies with Highest Percentage Layoffs:**
    ```sql
    SELECT company, percentage_laid_off FROM LAYOFF2_2 ORDER BY 2 DESC;
    ```

5. **Countries with Highest Layoffs:**
    ```sql
    SELECT country, SUM(total_laid_off) FROM LAYOFF2_2 GROUP BY country ORDER BY 2 DESC;
    ```

6. **Dates with Highest Layoffs:**
    ```sql
    SELECT date, total_laid_off FROM LAYOFF2_2 ORDER BY 2 DESC;
    ```

7. **Years with Highest Layoffs:**
    ```sql
    SELECT RIGHT(date, 4), SUM(total_laid_off) FROM LAYOFF2_2 GROUP BY RIGHT(date, 4) ORDER BY 2 DESC;
    ```

8. **Average Layoffs by Industry:**
    ```sql
    SELECT industry, ROUND(AVG(total_laid_off)) FROM LAYOFF2_2 GROUP BY industry ORDER BY 2 DESC;
    ```

9. **Top 5 Locations with Highest Layoffs:**
    ```sql
    SELECT location, SUM(total_laid_off) FROM LAYOFF2_2 GROUP BY location ORDER BY 2 DESC LIMIT 5;
    ```

## **Key Insights**

- **Total Number of Laid-off Employees:** Sum of all layoffs across the dataset.
- **Companies with Highest Layoffs:** Companies with the highest number of laid-off employees.
- **Industries with Highest Layoffs:** Industries most affected by layoffs.
- **Companies with Highest Percentage Layoffs:** Companies with the highest percentage of their workforce laid off.
- **Countries with Highest Layoffs:** Countries with the highest number of layoffs.
- **Dates with Highest Layoffs:** Specific dates with significant layoff events.
- **Years with Highest Layoffs:** Analysis of layoffs by year.
- **Average Layoffs by Industry:** Average number of layoffs per industry.
- **Top 5 Locations with Highest and Lowest Layoffs:** Geographical analysis of layoffs.

## **How to Use**

1. **Clone the Repository:** 
    ```sh
    git clone https://github.com/shivtarsode/layoffs-data-analysis.git
    ```
2. **Load Data:** Place the dataset in the `data` directory.
3. **Run SQL Scripts:** Use the provided SQL scripts to clean the data and perform exploratory data analysis.
4. **View Results:** Review the outputs of the SQL queries to gain insights from the data.

## **Conclusion**

The Layoffs Data Analysis project provides valuable insights into layoffs trends across various companies, locations, and industries. Using SQL for data cleaning and analysis ensures accurate and efficient data processing, leading to meaningful findings that can inform business decisions.

---

