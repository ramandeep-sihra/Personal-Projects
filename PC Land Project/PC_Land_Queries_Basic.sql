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
--Q1--
--what PC models have a speed of at least 150
SELECT brand
FROM Sales.Product
WHERE cpuspeed >= 150;

--Q2--
--find the model number and price of all products (of any type) made by ‘Acer’
SELECT modelcode, price
FROM Sales.Product
WHERE brand = 'Acer';

-- Q3--
--find the model numbers of all products that are white and have a memory capacity of at least 10
SELECT modelcode, price
FROM Sales.Product
WHERE colour = 'white' AND memorycapacity >= 10;


-- Q4--
--details of sales that are handled by an individual sales person
SELECT Sale.saleid, dateofsale, totalprice, customerid, saledetailid, salequantity, linetotal, modelcode
FROM Sales.Sale
  JOIN Sales.Saledetail
    ON Sale.saleid = Saledetail.saleid
WHERE salespersonname = 'Smith Johnson';

--Q5--
--list of products which have been sold on a particular day.
SELECT Product.modelcode, cpuspeed, memorycapacity, colour, brand, price, stockquantity
FROM Sales.Sale
  JOIN Sales.Saledetail
    ON Sale.saleid = Saledetail.saleid
      JOIN Sales.Product
        ON Product.modelcode = Saledetail.modelcode
WHERE dateofsale = '2020-01-01';

--Q6--
--details of the purchases a particular customer has made
SELECT Sale.saleid, salespersonname, dateofsale, totalprice, saledetailid, salequantity, linetotal, modelcode
FROM Sales.Saledetail
  JOIN Sales.Sale
    ON Saledetail.saleid = Sale.Saleid
WHERE customerid = 3864;

--Q7--
--The codes of all products manufactured by Acer in stock in ascending order of price
--IA: brand = 'Acer', stockquantity > 0, price asc
--IT: Product
--OA: modelcode
--OT: Product

SELECT modelcode
FROM Sales.Product
WHERE brand = 'Acer' AND stockquantity > 0
ORDER BY price;

--Q8--
--The non-duplicate codes of all products with at least 1 rating of 3 or more stars
--IA: ratingstars
--IT: Rating
--OA: modelcode
--OT: Rating
SELECT DISTINCT modelcode
FROM Sales.Rating
WHERE ratingstars >= 3;

--Q9--
--For all products, their code, average star rating and the most recent rating date.
--The results should be in descending order of average star rating
--IA: avg(ratingstars)
--IT: Rating
--OA: modelcode, avg(ratingstars), max(rating date)
--OT: Rating
-- 2876 3 2020-06-18
-- 2877 4 2020-03-01
-- 2879 1 2020-09-18
SELECT modelcode, avg(ratingstars), max(ratingdate)
FROM Sales.Rating
GROUP BY modelcode, ratingdate
ORDER BY avg(ratingstars) desc

--Q10--
--For all cases in which the same customer rated the same product more than once,
--and in some point in time gave it a lower rating than before,
--return the customer name, code of product and the lowest star rating that was given
--IA: modelcode, customerid, ratingdate, ratingstars
--IT: Rating
--OA: fullname, modelcode, min(ratingstars)
--OT: Customer, Rating
--self-, non-equi-, composite, multi- join
SELECT fullname, Rating2.modelcode, min(Rating2.ratingstars)
FROM Sales.Customer
  JOIN Sales.Rating AS Rating1
    ON Rating1.customerid = Customer.customerid
  JOIN Sales.Rating AS Rating2
    ON Rating1.modelcode = Rating2.modelcode AND Rating1.customerid = Rating2.customerid
    AND Rating1.ratingdate < Rating2.ratingdate AND Rating1.ratingstars > Rating2.ratingstars
GROUP BY fullname, Rating2.modelcode
/* Cameron Robson  2877  4
   Ellie Doyle     2876  2 */