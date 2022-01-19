-- SQL queries on a shop selling PCs and PC equipment
-- by Ramandeep Sihra, 2020
-- Based on the sections of Ben-Gan's book Exam Ref 70-761 Querying Data with Transact-SQL

--Schema--
/*
Customer (customerid, fullname, email, address, telephone, postcode)
  	      ----------
Product (modelcode, cpuspeed, memorycapacity, colour, brand, price, stockquantity)
	       ---------
Sale (saleid, salespersonname, dateofsale, totalprice, customerid*)
	    ------
Saledetail (saledetailid, salequantity, linetotal, modelcode*, saleid*)
            ------------
Rating (modelcode, customerid, ratingdate, ratingstars)
	      ---------  ----------  ----------
*/

--Understanding logical query processing
-- Q1.1.1
SELECT modelcode, brand, price, stockquantity
INTO Sales.Products2
FROM Sales.Product
WHERE price <= 500
GROUP BY modelcode, cpuspeed, memorycapacity, colour, brand, price, stockquantity
HAVING stockquantity < 1000
ORDER BY stockquantity DESC
OFFSET 1 ROW FETCH NEXT 2 ROWS ONLY

--(2 rows affected)

/*2878  Toshiba 300 150
2879  HP  300 100*/

-- Getting started with the SELECT statement
-- Q1.1.2
SELECT customerid, fullname, email, address, telephone, postcode
FROM Sales.Customer

/*3864  John Wicks  john@hotmail.com  27 Apple Lane 7830343344  SK718H
3865  Cameron Robson  cameron@hotmail.com 27 Banana Lane  787897898 SK8343
3866  Ellie Doyle ellie@hotmail.com 27 Pear Lane  7830123123  SK2734
3867  Jonny Solagdo jonny@hotmail.com 27 Orange Lane  7832342344  SK3945
3868  Olviia Bellerin olviia@hotmail.com  27 Peach Lane 7823423401  S78DFE
3869  Wayne Rooney  wayne@hotmail.com 27 Apricot Lane 7838343400  SK8343*/

-- Filtering data with predicates
-- Q1.1.3
SELECT modelcode, cpuspeed, memorycapacity, colour, brand, price, stockquantity
FROM Sales.Product
WHERE price < 800

/*2877  500 14  black Acer  500 300
2878  750 14  white Toshiba 300 150
2879  750 10  white HP  300 100*/

--Sorting data
--Q1.1.4
SELECT saleid, salespersonname, dateofsale, totalprice, customerid
FROM Sales.Sale
WHERE totalprice <= 1050
ORDER BY dateofsale ASC

/*450 Eric Willson  2019-03-10  1000  3864
480 Jones Smithers  2019-12-12  1050  3867
460 John Smith  2020-01-01  500 3865
470 Smith Johnson 2020-01-01  300 3866
490 Jimmy Blue  2020-02-10  400 3868
500 Raj Khare 2020-03-03  100 3869*/

-- TOP-OFFSET FETCH
--Q1.1.5--
--Top--
SELECT TOP (3) modelcode, brand, price
FROM Sales.Product
ORDER BY stockquantity DESC

/*
2877  Acer  500
2878  Toshiba 300
2879  HP  300
*/

--Q1.1.6--
--Offset- FETCH--
SELECT customerid, fullname, email, address
FROM Sales.Customer
ORDER BY customerid, fullname
OFFSET 4 ROWS FETCH NEXT 2 ROWS ONLY

/*
3868	Olviia Bellerin	olviia@hotmail.com 27 Peach Lane
3869	Wayne Rooney	wayne@hotmail.com  27 Apricot Lane
*/

-- Set Operations
--Q1.1.7abc--
--Union-Intersect-Except--
SELECT modelcode, linetotal
FROM Sales.Saledetail

UNION--INTERSECT-EXCEPT

SELECT modelcode, price
FROM Sales.Product

/*
--a--
2876  500
2876  1000
2877  500
2878  300
2878  400
2878  1600
2879  300
2879  1050
--b--
2876  1000
2877  500
--c-- 
2876  500
2878  400
2878  1600
2879  1050
*/

-- 1.2
-- Cross Joins 
--Q1.2.1--
SELECT brand, price, stockquantity, salequantity
FROM Sales.Product
    CROSS JOIN Sales.Saledetail
WHERE salequantity >= 2
ORDER BY brand

/*
Acer  1000  50  2
Acer  1000  50  2
Acer  1000  50  3
Acer  1000  50  4
Acer  500 300 2
Acer  500 300 2
Acer  500 300 3
Acer  500 300 4
HP  300 100 2
HP  300 100 2
HP  300 100 3
HP  300 100 4
Toshiba 300 150 2
Toshiba 300 150 2
Toshiba 300 150 3
Toshiba 300 150 4
*/

--Inner joins
--Q1.2.2--
SELECT brand, price, stockquantity 
FROM Sales.Saledetail AS Sd
  JOIN Sales.Product AS P
      ON Sd.modelcode = P.modelcode

/*
Acer  1000  50
Acer  500 300
Acer  1000  50
HP  300 100
Toshiba 300 150
Toshiba 300 150
*/

--Outer joins
--Q1.2.3--
SELECT P.modelcode, price, ratingstars
FROM Sales.Product AS P
  LEFT/*RIGHT/FULL*/ OUTER JOIN Sales.Rating AS R
  	ON R.modelcode = P.modelcode
WHERE brand = 'Toshiba'

/*
--L--
2878 300 NULL
--R--
no records
--FO--
2878 300 NULL
*/

--Composite joins
--Q1.2.4--
SELECT P.modelcode, brand, price, linetotal
FROM Sales.Product AS P
  INNER JOIN Sales.Saledetail AS Sd
    ON P.price = Sd.linetotal

/*
2876  Acer    1000  1000
2877  Acer    500   500
2877  Acer    500   500
*/

--Multi-joins
--Q1.2.5
SELECT P.modelcode, brand, stockquantity, Sd.salequantity, Sd.linetotal 
FROM Sales.Saledetail AS Sd
  JOIN Sales.Product AS P
    ON Sd.modelcode = P.modelcode
  CROSS JOIN Sales.Saledetail 
WHERE stockquantity >= 50 AND Sd.salequantity >= 2
ORDER BY brand, linetotal DESC

/*
2876  Acer  50  2 1000
2876  Acer  50  2 1000
2876  Acer  50  2 1000
2876  Acer  50  2 1000
2876  Acer  50  2 1000
...
2878  Toshiba 150 4 1600
2878  Toshiba 150 4 1600
2878  Toshiba 150 4 1600
2878  Toshiba 150 4 1600
2878  Toshiba 150 4 1600
*/

--Q1.2.6
--new order
SELECT Product.modelcode, brand, stockquantity, Sd.salequantity, Sd.linetotal 
FROM Sales.Saledetail AS Sd
  CROSS JOIN Sales.Product
  JOIN Sales.Saledetail
    ON Sd.modelcode = Product.modelcode
WHERE stockquantity >= 50 AND Sd.salequantity >= 2
ORDER BY brand, linetotal DESC

-- same as 1.2.5

-- extra
-- SELECT P.modelcode, P.price, S.saleid, R.ratingstars
-- FROM Sales.Product AS P
--   CROSS JOIN Sales.Sale AS S
--   LEFT OUTER JOIN Sales.Rating AS R
--     ON R.modelcode = P.modelcode

-- Type conversion functions
--Q1.3.1  
SELECT CONVERT(INT, modelcode, 0) -- 0 style= use 6 digits only where necessary.
FROM Sales.Rating

/*
2876
2876
2876
2876
2876
2877
2877
2879
*/

--Q1.3.2
SELECT CAST(dateofsale AS DATETIME) 
FROM Sales.Sale

/*2019-03-10 00:00:00.000
2020-01-01 00:00:00.000
2020-01-01 00:00:00.000
2019-12-12 00:00:00.000
2020-02-10 00:00:00.000
2020-03-03 00:00:00.000*/

-- Date & time functions
--Q1.2.9
SELECT DATEPART(MONTH, ratingdate) AS date
FROM Sales.Rating

/*
4
7
1
6
7
2
3
9
*/

-- Character FUnctions
-- Q1.3.3

SELECT CONCAT(brand, price)
FROM Sales.Product

/*
Acer1000
Acer500
Toshiba300
HP300
*/

-- CASE Functions 
-- Q1.3.4
SELECT COALESCE(modelcode, customerid)
FROM Sales.Rating

/*
2876
2876
2876
2876
2876
2877
2877
2879
*/

-- System Functions
-- Q1.3.5
SELECT CAST(DECOMPRESS(COMPRESS(modelcode)) AS VARCHAR)
FROM Sales.Rating

/*
2876
2876
2876
2876
2876
2877
2877
2879
*/

-- Arithmetic Operations and Aggregate Functions
-- Q1.3.6
SELECT 2 * SUM(totalprice) As 'Total Double Sale Price'
FROM Sales.Sale

-- 6700

--Search arguments
-- Q1.3.7

-- Non SARGABLE
SELECT ratingdate
FROM Sales.Rating
WHERE YEAR(ratingdate) = '2020' AND MONTH(ratingdate) = 2

-- SARGABLE
SELECT ratingdate
FROM Sales.Rating
WHERE ratingdate >= '20200201' AND ratingdate < '20200301';

/*2020-02-16*/

--Function determinism
--Q1.3.8
SELECT RAND(modelcode)
FROM Sales.Product

/*0.767161785580249
0.767180418551507
0.767199051522765
0.767217684494023*/

-- Inserting Data
-- Q 1.4.1
INSERT INTO Sales.Saledetail (saledetailid, salequantity, linetotal, modelcode, saleid)
SELECT saledetailid + 2, 5, 1250, modelcode - 1, saleid
FROM Sales.Saledetail
WHERE saledetailid = 44 OR saledetailid = 45

/*the following 2 rows are inserted into Saledetail
46  5 490 2877  1250
47  5 500 2877  1250
*/

-- Update Data
-- Q1.4.2

--2877  500 14  black Acer  500 300

UPDATE Sales.Product
  SET stockquantity += 100
  WHERE modelcode = 2877

--2877  500 14  black Acer  500 400

UPDATE Sales.Product
  SET stockquantity -= 100
  WHERE modelcode = 2877

--2877  500 14  black Acer  500 300

-- Deleting Data
-- Q1.4.3

/*
40  2 450 2876  1000
41  2 460 2877  500
42  1 470 2876  500
43  3 480 2879  1050
44  1 490 2878  400
45  4 500 2878  1600 
*/

DELETE FROM Sales.Saledetail
  WHERE saledetailid <= 42

/*
43  3 480 2879  1050
44  1 490 2878  400
45  4 500 2878  1600 
*/

/* Attempt to delete a row referenced by a FK
DELETE FROM Sales.Sale
  WHERE salespersonname = 'Smith Johnson'

Msg 547, Level 16, State 0, Line 2
The DELETE statement conflicted with the REFERENCE constraint "FK_Saledetail_Sale". The conflict occurred in database "Sales", table "Sales.Saledetail", column 'saleid'.
The statement has been terminated.*/

--Merging Data and Output
--Q1.4.4

-- WHEN MATCHED
--  SRC compared_attribute = TGT compared_attribute
--    BUT ALSO at least 1 SRC non-compared_attribute <> TGT non-compared_attribute => update TGT row from SRC
-- WHEN NOT MATCHED [implied BY TARGET]
--  SRC compared_attribute not in TGT => insert SRC row into TGT
-- WHEN NOT MATCHED BY SOURCE
--  TGT compared_attribute not in SRC => delete TGT row

/* initial Saledetail
40  2 1000  2876  450
41  2 500 2877  460
42  1 500 2876  470
43  3 1050  2879  480
44  1 400 2878  490
45  4 1600  2878  500
*/

DECLARE @sd2 AS TABLE
(saledetailid INT NOT NULL PRIMARY KEY,
 salequantity INT,
 linetotal DECIMAL,
 modelcode VARCHAR(4) NOT NULL,
 saleid INT NOT NULL)

INSERT INTO @sd2(saledetailid, salequantity, linetotal, modelcode, saleid)
  VALUES(40, 2, 1000, '2876', 450),
        (46, 2, 250, '2877', 460),
        (42, 1, 400, '2876', 470)

MERGE INTO Sales.Saledetail AS TGT
USING @sd2 AS SRC
  ON SRC.saledetailid = TGT.saledetailid
WHEN MATCHED AND EXISTS(SELECT SRC.* EXCEPT SELECT TGT.*) THEN 
  UPDATE
    SET
      TGT.saledetailid= SRC.saledetailid,
      TGT.salequantity = SRC.salequantity,
      TGT.linetotal = SRC.linetotal,
      TGT.modelcode = SRC.modelcode,
      TGT.saleid = SRC.saleid
WHEN NOT MATCHED THEN
  INSERT VALUES(SRC.saledetailid, SRC.salequantity, SRC.linetotal, SRC.modelcode, SRC.saleid)
WHEN NOT MATCHED BY SOURCE THEN
  DELETE --;

/* updated Saledetail
40  2 1000  2876  450
42  1 400 2876  470
46  2 250 2877  460
*/

--OUTPUT including MERGE ABOVE
--Q1.4.5

OUTPUT 
  $action AS ACTIONTAKEN,
  COALESCE(inserted.saledetailid, deleted.saledetailid) as saledetailid;

/*
DELETE  41
UPDATE  42
DELETE  43
DELETE  44
DELETE  45
INSERT  46
*/

-- Impact on Structural Changes
--Q1.4.6

TRUNCATE TABLE Sales.Saledetail

--THEN

ALTER TABLE Sales.Saledetail ADD customertitle VARCHAR(3) NOT NULL
CONSTRAINT DFT_Saledetail_customertitle DEFAULT 'MR'

-- To remove column first remove constraint
ALTER TABLE Sales.Saledetail DROP CONSTRAINT DFT_Saledetail_customertitle

--THEN

ALTER TABLE Sales.Saledetail DROP COLUMN CustomerTitle

-- Subqueries
--Q2.1.1

SELECT modelcode, brand, price
FROM Sales.Product
WHERE brand = 'Acer' AND Price <
  (SELECT MAX(price) FROM Sales.Product)

--2877  Acer  500

-- The APPLY Operator
--Q2.1.2
SELECT TOP (2) P.modelcode, P.brand, P.price, R.ratingstars, R.ratingdate
FROM Sales.Product AS P
  CROSS/*OUTER*/ APPLY (SELECT ratingstars, ratingdate
               FROM Sales.rating
               WHERE P.modelcode = Rating.modelcode) AS R
WHERE R.ratingstars = 5
ORDER BY stockquantity DESC

/*2877  Acer  500 5 2020-02-16
2876  Acer  1000  5 2020-07-18
*/

--Derived tables
--Q2.2.1
SELECT rownum, modelcode, brand, cpuspeed, price
FROM (SELECT
        ROW_NUMBER() OVER(PARTITION BY brand
                          ORDER BY price, modelcode) AS rownum, -- inline alias
        modelcode, brand, cpuspeed, price
      FROM Sales.Product) AS P --table alias
WHERE rownum <= 2;
-- in this eg only first 2 rows are ordered according to price as these are the only records that have duplicate brands. 
-- Partition by is simular to Group by used with row number and similar

/*
1 2877  Acer  500 500
2 2876  Acer  250 1000
1 2879  HP  750 300
1 2878  Toshiba 750 300*/

--Common table expressions (CTEs)
--Q2.2.2 simple
WITH View_ratings AS
(
  SELECT
    ROW_NUMBER() OVER(PARTITION BY modelcode
                      ORDER BY ratingstars) AS [number of ratings], -- implicit window frame clause
    modelcode, ratingdate, ratingstars
  FROM Sales.Rating
)
SELECT modelcode, ratingdate, ratingstars, [number of ratings]
FROM View_ratings
WHERE [number of ratings] < 3 -- CTE allows use of window function before SELECT
ORDER BY modelcode, [number of ratings]
/*
2876  2020-06-18  2 1
2876  2020-01-29  3 2
2877  2020-03-01  4 1
2877  2020-02-16  5 2
2879  2020-09-18  1 1
*/

--Q2.2.3 recursive
WITH SalesearchCTE AS
(
  SELECT SD.saledetailid, P.modelcode, P.brand, SD.salequantity, SD.linetotal
  FROM Sales.Saledetail AS SD
    INNER JOIN Sales.Product AS P
      ON SD.modelcode = P.modelcode
  WHERE SD.salequantity = 4
  
  UNION ALL

  SELECT saledetailid, modelcode, brand, salequantity - 1, linetotal 
  FROM SalesearchCTE AS SS
  WHERE salequantity > 0 
)
SELECT saledetailid, modelcode, brand, salequantity, linetotal
FROM SalesearchCTE
GO
/*
45  2878  Toshiba 4 1600
45  2878  Toshiba 3 1600
45  2878  Toshiba 2 1600
45  2878  Toshiba 1 1600
45  2878  Toshiba 0 1600
*/

--Views and inline table-valued functions
--Q2.2.4
DROP VIEW IF EXISTS Sales.View_ratings
GO
CREATE VIEW Sales.View_ratings
AS 

SELECT * 
FROM Sales.rating
WHERE ratingstars < 5 
GO
--Commands completed successfully

/*2876  3864  2020-04-23  4
2876  3866  2020-01-29  3
2876  3866  2020-06-18  2
2876  3866  2020-07-18  4
2877  3865  2020-03-01  4
2879  3867  2020-09-18  1*/

--Q2.2.5 itvf
DROP FUNCTION IF EXISTS Sales.GetRatings
GO
CREATE FUNCTION Sales.GetRatings(@ratingstars AS INT) RETURNS TABLE AS

RETURN

WITH View_ratingsCTE AS
(
  SELECT P.modelcode, P.brand, R.ratingstars, P.price
  FROM Sales.rating AS R
    INNER JOIN Sales.Product AS P
      ON R.modelcode = P.modelcode
  WHERE R.ratingstars = @ratingstars
  
  UNION ALL

  SELECT modelcode, brand, ratingstars - 1, price
  FROM View_ratingsCTE AS SR
  WHERE ratingstars > 0
)
SELECT modelcode, brand, ratingstars, price
FROM View_ratingsCTE
GO

SELECT *
FROM Sales.GetRatings(5)

/*
2876  Acer  5 1000
2877  Acer  5 500
2877  Acer  4 500
2877  Acer  3 500
2877  Acer  2 500
2877  Acer  1 500
2877  Acer  0 500
2876  Acer  4 1000
2876  Acer  3 1000
2876  Acer  2 1000
2876  Acer  1 1000
2876  Acer  0 1000
*/

-- Writing grouped queries
--Q2.3.1
SELECT modelcode, customerid, ratingdate, ratingstars, GROUPING_ID(modelcode, customerid, ratingdate, ratingstars) AS grouping_id
FROM Sales.Rating
GROUP BY GROUPING SETS
-- n: number of attributes inside an item
-- if an item (i) contains brackets, but not as part of a function, counts as 1 group (g)
-- without GROUPING SETS: total groups (tg) = product of groups (Πg)
-- with GROUPING SETS: tg = sum of groups (Σg)
-- here: tg = cg + rg = 2^2 + 2 + 1 = 4 + 3 = 7
(
  CUBE(modelcode, customerid),
  -- with CUBE: cg = 2^n
  -- starts with full set & includes all subsets up to the empty set
  -- (m, c) - rows=distinct count=4
  -- (m) - 3
  -- (c) - 4
  -- () - 1
  -- cube_rows=12
  ROLLUP(ratingdate, ratingstars)
  -- with ROLLUP: rg = n + 1
  -- starts with full set & removes last on each step
  -- (rd, rs) - rows=8
  -- (rd) - 7
  -- () - 1
  -- rollup_rows=16
  -- total_rows=28
)
GO
/*
NULL  NULL  2020-01-29  3 12
NULL  NULL  2020-01-29  NULL  13
NULL  NULL  2020-02-16  5 12
NULL  NULL  2020-02-16  NULL  13
NULL  NULL  2020-03-01  4 12
NULL  NULL  2020-03-01  NULL  13
NULL  NULL  2020-04-23  4 12
NULL  NULL  2020-04-23  NULL  13
NULL  NULL  2020-06-18  2 12
NULL  NULL  2020-06-18  NULL  13
NULL  NULL  2020-07-18  4 12
NULL  NULL  2020-07-18  5 12
NULL  NULL  2020-07-18  NULL  13
NULL  NULL  2020-09-18  1 12
NULL  NULL  2020-09-18  NULL  13
NULL  NULL  NULL  NULL  15
2876  3864  NULL  NULL  3
NULL  3864  NULL  NULL  11
2877  3865  NULL  NULL  3
NULL  3865  NULL  NULL  11
2876  3866  NULL  NULL  3
NULL  3866  NULL  NULL  11
2879  3867  NULL  NULL  3
NULL  3867  NULL  NULL  11
NULL  NULL  NULL  NULL  15
2876  NULL  NULL  NULL  7
2877  NULL  NULL  NULL  7
2879  NULL  NULL  NULL  7
*/

--Pivoting and Unpivoting Data
--Q2.3.2
WITH Pivotsd AS
(
  SELECT
    modelcode, -- grouping column
    saleid,    -- spreading column
    linetotal  -- aggregation column
  FROM Sales.Saledetail
)
SELECT modelcode, [450], [460], [470], [480], [490], [500]
FROM Pivotsd
  PIVOT(SUM(linetotal) FOR saleid IN([450], [460], [470], [480], [490], [500])) AS P;

/*
2876  1000  NULL  500 NULL  NULL  NULL
2877  NULL  500 NULL  NULL  NULL  NULL
2878  NULL  NULL  NULL  NULL  400 1600
2879  NULL  NULL  NULL  1050  NULL  NULL
*/

--Using Window Functions
--Q2.3.3

SELECT modelcode, customerid, ratingdate, ratingstars,
  AVG(ratingstars) OVER(PARTITION BY modelcode
            ORDER BY ratingdate, modelcode, customerid) AS [running star average]
FROM Sales.Rating

/* 2876 3866  2020-01-29  3 3
2876  3864  2020-04-23  4 3
2876  3866  2020-06-18  2 3
2876  3864  2020-07-18  5 3
2876  3866  2020-07-18  4 3
2877  3865  2020-02-16  5 5
2877  3865  2020-03-01  4 4
2879  3867  2020-09-18  1 1*/

-- System-versioned temporal tables
--Q2.4

--Creating Tables
DROP TABLE IF EXISTS Sales.Product_Temporal
CREATE TABLE Sales.Product_Temporal
(
  modelcode INT NOT NULL
  CONSTRAINT PK_Product_Temporal PRIMARY KEY(modelcode),
  cpuspeed VARCHAR(3) NOT NULL,
  memorycapacity VARCHAR(6) NOT NULL,
  colour VARCHAR(10) NOT NULL,
  brand VARCHAR(10) NOT NULL,
  price DECIMAL NOT NULL,
  stockquantity VARCHAR(2) NOT NULL,
  validfrom DATETIME2(3)
  GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
  validto DATETIME2(3)
  GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
  PERIOD FOR SYSTEM_TIME (validfrom, validto)
)
WITH ( SYSTEM_VERSIONING = ON ( HISTORY_TABLE = Sales.Product_History ) );

-- insert data

INSERT INTO Sales.Product_Temporal (modelcode, cpuspeed, memorycapacity, colour, brand, price, stockquantity)
  VALUES ('2876', 250, 12, 'blue', 'Acer', 1000, 50),
         ('2877', 500, 14, 'black', 'Acer', 500, 300),
         ('2878', 750, 14,'white', 'Toshiba', 300, 150),
         ('2879', 750, 10, 'white', 'HP', 300, 100);

--modify data 
/*2876 250 12 blue Acer 1000 50
2877 500 14 black Acer 500 300*/

UPDATE Sales.Product_Temporal
SET price += 50
WHERE brand = 'Acer'; 

--(2 rows affected)

--Completion time: 2020-05-30T13:42:45.9834104+01:00

/*2876  250 12  blue  Acer  1050  50
2877  500 14  black Acer  550 * */

--query data
SELECT modelcode, colour, brand, price, validfrom, validto 
FROM Sales.Product_temporal FOR SYSTEM_TIME Between '20200530 13:40:00.000' AND '20200530 13:46:00.000'
WHERE brand ='Acer'

--2876  blue  Acer  1050  2020-05-30 12:42:45.961 9999-12-31 23:59:59.999
--2877  black Acer  550 2020-05-30 12:42:45.961 9999-12-31 23:59:59.999