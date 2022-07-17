/**********************************************************************
 * NAME: Katie Stevens
 * CLASS: CPSC 321 Database Management Systems
 * DATE: 11/11/21
 * HOMEWORK: HW7
 * DESCRIPTION: 
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
                        ('Gdansk', 'Pomerania', 'PL', 475000),
                        ('Kihei', 'Hawaii', 'US', 31336);

INSERT INTO Border VALUES ('RU', 'UA', 1944),
                          ('UA', 'PL', 498);


-- TODO: add select statements (to print tables)
-- SELECT * FROM Country;
-- SELECT * FROM Province;
-- SELECT * FROM City;
-- SELECT * FROM Border;


-- TODO: add queries with comments below
DROP VIEW IF EXISTS SymmetricBorder;

-- (a)
SELECT AVG(gdp), AVG(inflation)
FROM Country;

-- (b)
SELECT AVG(area), SUM(area)
FROM Province
WHERE country_code="PL";

-- (c)
SELECT AVG(C1.population)
FROM City C1 JOIN Country C USING (country_code)
WHERE C.gdp > 30000 AND C.inflation < 4.5; -- high gdp and low inflation

-- (d)
SELECT SUM(C1.population)
FROM Country C JOIN Province P USING (country_code)
     JOIN City C1 USING (province_name)
WHERE P.area > 15000 AND C.inflation < 4.5; -- large area and low inflation

-- (e) given city = Kahului
SELECT AVG(C1.population)
FROM Country C JOIN Province P USING (country_code)
     JOIN City C1 USING (province_name)
WHERE C1.country_code = 'US' AND C1.province_name = 'Hawaii' AND C1.city_name != 'Kahului';

-- (f)
SELECT COUNT(*), AVG(border_length)
FROM Border
WHERE country_code_1 = 'UA' OR country_code_2 = 'UA';

-- (g)
CREATE VIEW SymmetricBorder AS
SELECT *
FROM Border
UNION
SELECT country_code_2, country_code_1, border_length
FROM Border;

-- (h) country c = RU
SELECT COUNT(*)
FROM Country C JOIN SymmetricBorder SB ON (C.country_code = SB.country_code_1)
WHERE SB.country_code_2 = 'RU' AND C.gdp < 31000 AND C.inflation > 4.4;

-- (i)
SELECT C1.country_code, C1.inflation, C1.gdp, C2.country_code, C2.inflation, C2.gdp
FROM SymmetricBorder SB Join Country C1 ON (SB.country_code_1 = C1.country_code)
     JOIN Country C2 ON (SB.country_code_2 = C2.country_code)
WHERE C1.inflation <= (0.9 * C2.inflation) AND C1.gdp >= (0.8 * C2.gdp)
ORDER BY C1.country_code, C2.inflation DESC, C2.gdp ASC, C2.country_code;

-- (j)
SELECT C1.city_name, C1.population, P.province_name, C.country_name
FROM Country C JOIN Province P USING (country_code)
     JOIN City C1 USING (province_name)
ORDER BY C.country_name, P.province_name, C1.population, C1.city_name;