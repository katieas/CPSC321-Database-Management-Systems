/**********************************************************************
 * NAME: Katie Stevens
 * CLASS: CPSC 321 Database Management Systems Fall 2021
 * DATE: 10/28/21
 * HOMEWORK: HW6
 * DESCRIPTION: Part 1 Factbook tables
 **********************************************************************/

USE kstevens3_DB;

-- TODO: add drop table statements
DROP TABLE IF EXISTS City;
DROP TABLE IF EXISTS Border;
DROP TABLE IF EXISTS Province;
DROP TABLE IF EXISTS Country;


-- TODO: add create table statements

/*
Country table represents each country with country_code, country_name, gdp, and inflation.
*/
CREATE TABLE Country(
    country_code CHAR(2) NOT NULL,
    country_name TINYTEXT NOT NULL,
    gdp INT UNSIGNED,
    inflation FLOAT,
    PRIMARY KEY(country_code)
);

/*
Province table represents each province within a country with 
province_name, country_code, and area.
*/
CREATE TABLE Province(
    province_name VARCHAR(50) NOT NULL,
    country_code CHAR(2) NOT NULL,
    area INT UNSIGNED,
    PRIMARY KEY(province_name, country_code),
    FOREIGN KEY(country_code) REFERENCES Country(country_code)
);

/*
City table represents each city within a province within a country with city_name,
province_name, country_code, and population.
*/
CREATE TABLE City(
    city_name VARCHAR(50) NOT NULL,
    province_name VARCHAR(50) NOT NULL,
    country_code CHAR(2) NOT NULL,
    population INT UNSIGNED,
    PRIMARY KEY(city_name, province_name, country_code),
    FOREIGN KEY(province_name) REFERENCES Province(province_name),
    FOREIGN KEY(country_code) REFERENCES Province(country_code)
);

/*
Border table represents a border between two countries with country_code_1, country_code_2,
and border_length.
*/
CREATE TABLE Border(
    country_code_1 CHAR(2) NOT NULL,
    country_code_2 CHAR(2) NOT NULL,
    border_length INT UNSIGNED NOT NULL,
    PRIMARY KEY(country_code_1, country_code_2),
    FOREIGN KEY(country_code_1) REFERENCES Country(country_code),
    FOREIGN KEY(country_code_2) REFERENCES Country(country_code)
);


-- TODO: add insert statements
INSERT INTO Country VALUES  ('RU', 'Russia', 31000, 4.4),
                            ('US', 'United States of America', 62530, 1.8),
                            ('PL', 'Poland', 33321, 2.1),
                            ('UA', 'Ukraine', 12810, 7.9);

INSERT INTO Province VALUES ('Kaliningrad Oblast', 'RU', 15100),
                            ('Hawaii', 'US', 10430),
                            ('Lesser Poland', 'PL', 15108),
                            ('Pomerania', 'PL', 30120);

INSERT INTO City VALUES ('Kaliningrad', 'Kaliningrad Oblast', 'RU', 475000),
                        ('Honolulu', 'Hawaii', 'US', 348985),
                        ('Kahului', 'Hawaii', 'US', 31336), 
                        ('Krakow', 'Lesser Poland', 'PL', 779966),
                        ('Gdansk', 'Pomerania', 'PL', 475000);

INSERT INTO Border VALUES ('RU', 'UA', 1944),
                          ('UA', 'PL', 498);


-- TODO: add select statements (to print tables)
SELECT * FROM Country;
SELECT * FROM Province;
SELECT * FROM City;
SELECT * FROM Border;


-- TODO: Queries
-- (a)
SELECT *
FROM Country
WHERE gdp > 40000 AND inflation < 2.0;

-- (b)
SELECT  C.country_code, C.country_name, C.inflation, P.province_name, P.area
FROM    Country C, Province P
WHERE   C.country_code = P.country_code AND area < 15101 AND inflation > 4.0;

-- (c)
SELECT C.country_code, C.country_name, C.inflation, P.province_name, P.area
FROM    Country C JOIN Province P ON (C.country_code = P.country_code)
WHERE   area < 15101 AND inflation > 4.0;

-- (d)
SELECT DISTINCT C.country_code, C.country_name, P.province_name, P.area
FROM    Country C, Province P, City C1
WHERE   C.country_code = P.country_code AND P.province_name = C1.province_name AND C1.population > 1000;

-- (e)
SELECT DISTINCT C.country_code, C.country_name, P.province_name, P.area
FROM    Country C JOIN Province P USING (country_code) 
        JOIN City USING (province_name)
WHERE   population > 1000;

-- (f)
SELECT DISTINCT C.country_code, C.country_name, P.province_name, P.area
FROM    Country C, Province P, City C1, City C2
WHERE   C.country_code = P.country_code AND P.province_name = C1.province_name AND P.province_name = C2.province_name
        AND C1.city_name != C2.city_name AND C1.population > 1000 AND C2.population > 1000;

-- (g)
SELECT DISTINCT C.country_code, C.country_name, P.province_name, P.area
FROM    Country C JOIN Province P USING (country_code) 
        JOIN City C1 USING (province_name) 
        JOIN City C2 USING (province_name)
WHERE   C1.population > 1000 AND C2.population > 1000 AND C1.city_name != C2.city_name;

-- (h) 
SELECT DISTINCT C1.city_name, C1.province_name, C1.country_code, C2.city_name, C2.province_name, C2.country_code, C1.population
FROM    City C1 JOIN City C2 USING (population) 
WHERE   C1.population = C2.population 
        AND (C1.city_name != C2.city_name OR C1.country_code != C2.country_code OR C1.province_name != C2.province_name);

-- (i)
SELECT  C1.country_code, C1.country_name
FROM    Country C1, Country C2, Border B
WHERE   C1.gdp > 30000 AND  C1.inflation < 4.5 AND C2.gdp < 15000 AND C2.inflation > 4.0 
        AND C1.country_code = B.country_code_1 AND C2.country_code = B.country_code_2;


-- (j)
SELECT  C1.country_code, C1.country_name
FROM    Country C1 JOIN Border B ON (C1.country_code = B.country_code_1)
        JOIN Country C2 ON (C2.country_code = B.country_code_2)
WHERE   C1.gdp > 30000 AND  C1.inflation < 4.5 AND C2.gdp < 15000 AND C2.inflation > 4.0;