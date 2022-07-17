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
                            ('Pomerania', 'PL', 30120),
                            ('Lower Silesian', 'PL', 19945);

INSERT INTO City VALUES ('Kaliningrad', 'Kaliningrad Oblast', 'RU', 475000),
                        ('Honolulu', 'Hawaii', 'US', 348985),
                        ('Kahului', 'Hawaii', 'US', 31336), 
                        ('Krakow', 'Lesser Poland', 'PL', 779966),
                        ('Gdansk', 'Pomerania', 'PL', 475000),
                        ('Wroclaw', 'Lower Silesian', 'PL', 690000),
                        ('Kihei', 'Hawaii', 'US', 31336);

INSERT INTO Border VALUES ('RU', 'UA', 1944),
                          ('UA', 'PL', 498);


-- TODO: add select statements (to print tables)
SELECT * FROM Country;
SELECT * FROM Province;
SELECT * FROM City;
SELECT * FROM Border;