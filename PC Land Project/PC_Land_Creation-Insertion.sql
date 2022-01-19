-- DATABASE & SCHEMA CREATION
CREATE DATABASE Sales;
GO
USE Sales;
GO
CREATE SCHEMA Sales AUTHORIZATION dbo;
GO


-- TABLE CREATION
CREATE TABLE Sales.Customer
(
	customerid INT NOT NULL,
	fullname VARCHAR(20) NOT NULL,
	email VARCHAR(20) NOT NULL,
	address VARCHAR(20) NOT NULL,
	telephone VARCHAR(11) NOT NULL,
	postcode VARCHAR(9) NOT NULL,
	CONSTRAINT PK_Customer PRIMARY KEY(customerid)
);

CREATE TABLE Sales.Product
(
	modelcode VARCHAR(4) NOT NULL,
  cpuspeed VARCHAR(3) NOT NULL,
  memorycapacity VARCHAR(6) NOT NULL,
  colour VARCHAR(10) NOT NULL,
  brand VARCHAR(10) NOT NULL,
  price DECIMAL NOT NULL,
  stockquantity VARCHAR(2) NOT NULL,
  CONSTRAINT PK_Product PRIMARY KEY(modelcode)
);

CREATE TABLE Sales.Sale
(
	saleid INT NOT NULL,
	salespersonname VARCHAR(20) NOT NULL,
	dateofsale DATE NOT NULL,
	totalprice DECIMAL NOT NULL,
	customerid INT NOT NULL,
	CONSTRAINT PK_Sale PRIMARY KEY(saleid),
	CONSTRAINT FK_Sale_Customer FOREIGN KEY(customerid) REFERENCES Sales.Customer(customerid)
);

CREATE TABLE Sales.Saledetail
(
	saledetailid INT NOT NULL,
	salequantity INT NOT NULL,
	linetotal DECIMAL NOT NULL,
	modelcode VARCHAR(4) NOT NULL,
	saleid INT NOT NULL,
	CONSTRAINT PK_Saledetail PRIMARY KEY(saledetailid),
	CONSTRAINT FK_Saledetail_Product FOREIGN KEY(modelcode) REFERENCES Sales.Product(modelcode),
	CONSTRAINT FK_Saledetail_Sale FOREIGN KEY(saleid) REFERENCES Sales.Sale(saleid)
);

CREATE TABLE Sales.Rating
(
  modelcode VARCHAR(4) NOT NULL,
  customerid INT NOT NULL,
  ratingdate DATE NOT NULL,
  ratingstars INT NOT NULL, 
  CONSTRAINT PK_Rating PRIMARY KEY(modelcode, customerid, ratingdate),
  CONSTRAINT FK_Rating_Product FOREIGN KEY(modelcode) REFERENCES Sales.Product(modelcode),
  CONSTRAINT FK_Rating_Customer FOREIGN KEY(customerid) REFERENCES Sales.Customer(customerid)
);

-- DATA INSERTION
INSERT INTO Sales.Customer (customerid, fullname, email, address, telephone, postcode)
  VALUES (3864, 'John Wicks', 'john@hotmail.com', '27 Apple Lane', 07830343344, 'SK718H');
INSERT INTO Sales.Customer (customerid, fullname, email, address, telephone, postcode)
  VALUES (3865, 'Cameron Robson', 'cameron@hotmail.com', '27 Banana Lane', 0787897898, 'SK8343');
INSERT INTO Sales.Customer (customerid, fullname, email, address, telephone, postcode)
  VALUES (3866, 'Ellie Doyle', 'ellie@hotmail.com', '27 Pear Lane', 07830123123, 'SK2734');
INSERT INTO Sales.Customer (customerid, fullname, email, address, telephone, postcode)
  VALUES (3867, 'Jonny Solagdo', 'jonny@hotmail.com', '27 Orange Lane', 07832342344, 'SK3945');
INSERT INTO Sales.Customer (customerid, fullname, email, address, telephone, postcode)
  VALUES (3868, 'Olviia Bellerin', 'olviia@hotmail.com', '27 Peach Lane', 07823423401, 'S78DFE');
INSERT INTO Sales.Customer (customerid, fullname, email, address, telephone, postcode)
  VALUES (3869, 'Wayne Rooney', 'wayne@hotmail.com', '27 Apricot Lane', 07838343400, 'SK8343');

INSERT INTO Sales.Product (modelcode, cpuspeed, memorycapacity, colour, brand, price, stockquantity)
  VALUES ('2876', 250, 12, 'blue', 'Acer', 1000, 50);
INSERT INTO Sales.Product (modelcode, cpuspeed, memorycapacity, colour, brand, price, stockquantity)
  VALUES('2877', 500, 14, 'black', 'Acer', 500, 300);
INSERT INTO Sales.Product (modelcode, cpuspeed, memorycapacity, colour, brand, price, stockquantity)
  VALUES('2878', 750, 14,'white', 'Toshiba', 300, 150);
INSERT INTO Sales.Product (modelcode, cpuspeed, memorycapacity, colour, brand, price, stockquantity)
  VALUES ('2879', 750, 10, 'white', 'HP', 300, 100);

INSERT INTO Sales.Sale (saleid, salespersonname, dateofsale, totalprice, customerid)
  VALUES (450, 'Eric Willson', '2019-03-10', 1000, 3864);
INSERT INTO Sales.Sale (saleid, salespersonname, dateofsale, totalprice, customerid)
  VALUES (460, 'John Smith', '2020-01-01', 500, 3865);
INSERT INTO Sales.Sale (saleid, salespersonname, dateofsale, totalprice, customerid)
  VALUES (470, 'Smith Johnson', '2020-01-01', 300, 3866);
INSERT INTO Sales.Sale (saleid, salespersonname, dateofsale, totalprice, customerid)
  VALUES (480, 'Jones Smithers', '2019-12-12', 1050, 3867)
INSERT INTO Sales.Sale (saleid, salespersonname, dateofsale, totalprice, customerid)
  VALUES (490, 'Jimmy Blue', '2020-02-10', 400, 3868);
INSERT INTO Sales.Sale (saleid, salespersonname, dateofsale, totalprice, customerid)
  VALUES (500, 'Raj Khare', '2020-03-03', 100, 3869);

INSERT INTO Sales.Saledetail (saledetailid, salequantity, linetotal, modelcode, saleid)
  VALUES (40, 2, 1000, '2876', 450);
INSERT INTO Sales.Saledetail (saledetailid, salequantity, linetotal, modelcode, saleid)
  VALUES (41, 2, 500, '2877', 460);
INSERT INTO Sales.Saledetail (saledetailid, salequantity, linetotal, modelcode, saleid)
  VALUES (42, 1, 500, '2876', 470); --300
INSERT INTO Sales.Saledetail (saledetailid, salequantity, linetotal, modelcode, saleid)
  VALUES (43, 3, 1050, '2879', 480);
INSERT INTO Sales.Saledetail (saledetailid, salequantity, linetotal, modelcode, saleid)
  VALUES (44, 1, 400, '2878', 490);
INSERT INTO Sales.Saledetail (saledetailid, salequantity, linetotal, modelcode, saleid)
  VALUES (45, 4, 1600, '2878', 500); --100
--INSERT INTO Sales.Saledetail (saledetailid, salequantity, linetotal, modelcode, saleid)
-- VALUES (46, 6, 1500, '2877', 500); --100  

INSERT INTO Sales.Rating (modelcode, customerid, ratingdate, ratingstars)
  VALUES ('2876', 3864, '2020-04-23', 4);
INSERT INTO Sales.Rating (modelcode, customerid, ratingdate, ratingstars)
  VALUES ('2876', 3864, '2020-07-18', 5);
INSERT INTO Sales.Rating (modelcode, customerid, ratingdate, ratingstars)
  VALUES ('2876', 3866, '2020-01-29', 3);
INSERT INTO Sales.Rating (modelcode, customerid, ratingdate, ratingstars)
  VALUES ('2876', 3866, '2020-06-18', 2);
INSERT INTO Sales.Rating (modelcode, customerid, ratingdate, ratingstars)
  VALUES ('2876', 3866, '2020-07-18', 4);
INSERT INTO Sales.Rating (modelcode, customerid, ratingdate, ratingstars)
  VALUES ('2879', 3867, '2020-09-18', 1);
INSERT INTO Sales.Rating (modelcode, customerid, ratingdate, ratingstars)
  VALUES ('2877', 3865, '2020-02-16', 5);
INSERT INTO Sales.Rating (modelcode, customerid, ratingdate, ratingstars)
  VALUES ('2877', 3865, '2020-03-01', 4);