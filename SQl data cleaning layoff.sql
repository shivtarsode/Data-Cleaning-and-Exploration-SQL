SELECT * FROM layoffs;

-- CREATING SEPERATE TABLE FOR OPERATION

CREATE TABLE LAYOFF2
LIKE layoffs;

SELECT * FROM LAYOFF2;
INSERT INTO LAYOFF2
SELECT * FROM 
layoffs;

SELECT * FROM LAYOFF2;

SELECT *,
row_number() OVER(partition by company,location,industry,total_laid_off,percentage_laid_off,date,stage,country,funds_raised_millions ) AS ROW_NUM
from LAYOFF2;

-- TO FILTER IT BY ROW_NUM WE NEED TO CREATE CTE

WITH CTE_1 AS
(
SELECT *,
row_number() OVER(partition by company,location,industry,total_laid_off,percentage_laid_off,date,stage,country,funds_raised_millions ) AS ROW_NUM
from LAYOFF2
)
select * FROM CTE_1
WHERE ROW_NUM >1;

-- TO CROSS CHECK SOME DUPLICATE
 
select * FROM LAYOFF2
WHERE company='Elemy';

-- TO REMOVE DUPLICATE 

CREATE TABLE `LAYOFF2_2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
   ROW_NUM INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
SELECT * FROM LAYOFF2_2;
insert INTO LAYOFF2_2
SELECT *,
row_number() OVER(partition by company,location,industry,total_laid_off,percentage_laid_off,date,stage,country,funds_raised_millions ) AS ROW_NUM
from LAYOFF2
;

SELECT * FROM LAYOFF2_2
WHERE ROW_NUM>1;

DELETE 
FROM LAYOFF2_2
WHERE ROW_NUM > 1;

SELECT * FROM LAYOFF2_2
WHERE ROW_NUM>1;

-- HERE ALL DUPLICATE ARE REMOVED
-- STANDARDIZED THE DATA SET
 
 SELECT * FROM LAYOFF2_2;
 SELECT DISTINCT company,TRIM(company) FROM LAYOFF2_2;

 
 UPDATE LAYOFF2_2
 SET company=TRIM(company);
 SELECT * FROM LAYOFF2_2;
 
 SELECT DISTINCT location FROM LAYOFF2_2
 where location LIKE 'D%';
 
 UPDATE LAYOFF2_2
 SET location='Dusseldorf'
 WHERE location LIKE '%ldorf';
 
  SELECT DISTINCT location FROM LAYOFF2_2
 where location LIKE 'D%';
 
  SELECT DISTINCT industry FROM LAYOFF2_2
 ;
  SELECT DISTINCT industry FROM LAYOFF2_2
 where industry LIKE 'CRYPTO%';
 
  UPDATE LAYOFF2_2
 SET industry='Crypto'
 WHERE industry LIKE 'Crypto%';
 
  SELECT DISTINCT industry FROM LAYOFF2_2
 where industry LIKE 'CRYPTO%';
 
 select  distinct country from LAYOFF2_2
 where country LIKE 'United%';
 
 SELECT distinct country,TRIM(TRAILING "." FROM country) from LAYOFF2_2;
 
UPDATE LAYOFF2_2
SET country=TRIM(TRAILING "." FROM country);
 
SELECT * FROM LAYOFF2_2;
SELECT date,str_to_date(date,'%m/%d/%y') as con_date FROM LAYOFF2_2;


UPDATE LAYOFF2_2
SET date = str_to_date(date,'%m/%d/%y');

 SELECT * FROM LAYOFF2_2;
 
 -- Removing Null Values and Blank values

SELECT *
 FROM LAYOFF2_2
 where industry is null
 or industry='' ;
 
SELECT *
 FROM LAYOFF2_2
 where 
  company IN ('Carvana','Juul','Airbnb');
  
-- to fill the missing value we use join
Select t1.company,t1.industry,t2.industry from LAYOFF2_2 t1
join LAYOFF2_2 t2 on
t1.company=t2.company and t1.location=t2.location
where t1.industry is null
 or t1.industry='';
 
 update LAYOFF2_2 
 set industry=null
 where industry='null';
 
 update LAYOFF2_2 t1
 join LAYOFF2_2 t2 on
t1.company=t2.company 
set t1.industry=t2.industry
where t1.industry is null
and t2.industry is not null
 ;
 
 Delete from LAYOFF2_2
 where company like 'Bally%';
 
 -- Industry column is cleaned 
 SELECT *
 FROM LAYOFF2_2;
 
select * from LAYOFF2_2
where percentage_laid_off is null
and total_laid_off is null
 ;
 -- ROW_NUM is not of use so drop the column
 alter table LAYOFF2_2
 drop column ROW_NUM;

 Delete from
 LAYOFF2_2 where percentage_laid_off is null
and total_laid_off is null;

ALTER TABLE LAYOFF2_2
MODIFY COLUMN date DATE;

-- THIS IS THE FINAL CLEAN DATA
 SELECT *
 FROM LAYOFF2_2;
 -- Now we can perform EDA

 -- TOTAL_NO_LAIDOFF 
 select sum(total_laid_off)as TOTAL_NO_LAIDOFF from LAYOFF2_2;
 
 -- COMPANY HAVING HIGHEST LAIDOFF
 select company,sum(total_laid_off) from LAYOFF2_2
 group by company
 order by 2 desc;
 
 -- INDUSTRY  HAVING HIGHEST LAIDOFF
 select industry,sum(total_laid_off) from LAYOFF2_2
 group by industry
 order by 2 desc;
 -- COMPANY HAVING HIGHEST PERCENTAGE_LAIDOFF
  select company,percentage_laid_off from LAYOFF2_2
  order by 2 desc;
  
  -- INDUSTRY  HAVING HIGHEST PERCENTAGE_LAIDOFF
  select industry,percentage_laid_off from LAYOFF2_2
  order by 2 desc;
 
  -- COUNTRY HAVING HIGHEST LAIDOFF
  select country,sum(total_laid_off) from LAYOFF2_2
  group by country
  order by 2 desc;
  
  select company,SUM(total_laid_off),SUM(funds_raised_millions) from LAYOFF2_2
  WHERE total_laid_off IS NOT NULL AND funds_raised_millions IS NOT NULL
  group by company
  order by 2 ,3 ;
  
  -- DATE ON WHICH THERE WAS HIGHEST LAIDOFF
  select date,total_laid_off
  from LAYOFF2_2
  order by 2 desc;
  
  -- YEAR HAVING HIGHEST LAIDOFF
   select right(date,4),sum(total_laid_off)
   from LAYOFF2_2
   group by right(date,4)
   order by 2 desc;
   
   -- AVG LAIDOFF BY INDUSTRY
select DISTINCT industry,round(AVG(total_laid_off))
   from LAYOFF2_2
   group by industry
   ORDER BY 2 DESC;
   
   -- TOP 5 LOCATION HAVING HIGEST LAIDOFF
    SELECT  location, sum(total_laid_off)
 from LAYOFF2_2
 group by location 
 order by 2 desc
 LIMIT 5;
 
 -- TOP 5 LOCATION HAVING lowest LAIDOFF
  SELECT  location, sum(total_laid_off)
 from LAYOFF2_2
 where total_laid_off is not null
 group by location 
 order by 2 
 LIMIT 5;
 
   
   
   

   
  
  
 
  
 
 









