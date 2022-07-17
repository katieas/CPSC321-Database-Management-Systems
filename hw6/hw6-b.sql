/**********************************************************************
 * NAME: Katie Stevens
 * CLASS: CPSC 321 Database Management Systems Fall 2021
 * DATE: 10/28/21
 * HOMEWORK: HW6
 * DESCRIPTION: Part 1 LEGO tables
 **********************************************************************/

USE kstevens3_DB;

-- TODO: add drop table statements
DROP TABLE IF EXISTS PartList;
DROP TABLE IF EXISTS Brick;
DROP TABLE IF EXISTS Dimensions;
DROP TABLE IF EXISTS YearRange;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS Theme;
DROP TABLE IF EXISTS LegoSet;


-- TODO: add create table statements

/*
The LegoSet table describes specific sets of legos and their attributes.
minifigure_count is an optional attribute.
*/
CREATE TABLE LegoSet (
    item_num INT UNSIGNED NOT NULL,
    set_name TINYTEXT NOT NULL,
    theme TINYTEXT NOT NULL,
    age_range VARCHAR(50) NOT NULL,
    price FLOAT NOT NULL,
    minifigure_count INT UNSIGNED,
    vip_points INT UNSIGNED NOT NULL,
    total_pieces INT UNSIGNED NOT NULL,
    PRIMARY KEY(item_num)
);

CREATE TABLE YearRange (
    item_num INT UNSIGNED NOT NULL,
    start_year INT UNSIGNED NOT NULL,
    end_year INT UNSIGNED NOT NULL,
    PRIMARY KEY(item_num, start_year, end_year),
    FOREIGN KEY(item_num) REFERENCES LegoSet(item_num)
);

/*
The category table compares lego set item numbers with their categories.
*/
CREATE TABLE Category (
    item_num INT UNSIGNED NOT NULL,
    category_name VARCHAR(50) NOT NULL,
    PRIMARY KEY(item_num, category_name),
    FOREIGN KEY(item_num) REFERENCES LegoSet(item_num)
);

/*
The Theme table comapares the lego set item numbers with their themes. 
Themes have a theme_name, year_range, description, and who it was lisenced from.
*/
CREATE TABLE Theme (
    item_num INT UNSIGNED NOT NULL,
    theme_name VARCHAR(50) NOT NULL,
    year_range VARCHAR(50) NOT NULL,
    description TINYTEXT,
    license TINYTEXT,
    PRIMARY KEY(item_num),
    FOREIGN KEY(item_num) REFERENCES LegoSet(item_num)
);

/*
The Dimensions table has item_num with height, width, and depth of the lego set.
*/
CREATE TABLE Dimensions (
    item_num INT UNSIGNED NOT NULL,
    height INT,
    width INT,
    depth INT,
    PRIMARY KEY(item_num),
    FOREIGN KEY(item_num) REFERENCES LegoSet(item_num)
);

/*
The brick table represents a brick within a legoset. 
It has element_id, design_id, brick_name, color, and price.
Some bricks can have "identical parts" where they have different element_id's but
are identical in every other attribute.
*/
CREATE TABLE Brick (
    element_id INT UNSIGNED NOT NULL,
    design_id INT UNSIGNED NOT NULL,
    brick_name TINYTEXT,
    color TINYTEXT,
    price FLOAT,
    PRIMARY KEY(element_id)
);

/*
The PartList table represents a list of bricks and how many of each brick are within a set.
*/
CREATE TABLE PartList (
    item_num INT UNSIGNED NOT NULL,
    element_id INT UNSIGNED NOT NULL,
    pieces INT UNSIGNED,
    PRIMARY KEY(item_num, element_id),
    FOREIGN KEY(item_num) REFERENCES LegoSet(item_num),
    FOREIGN KEY(element_id) REFERENCES Brick(element_id)
);


-- TODO: add insert statements
INSERT INTO LegoSet VALUES  (123, 'Epic Farm', 'Farmland', '3+', 49.99, 3, 501, 200),
                            (234, 'Gotham City', 'Batman', '18+', 99.99, 5, 300, 500),
                            (345, 'Chinese New Year Pandas', 'BrickHeadz', '10+', 19.99, 10, 900, 249),
                            (456, 'Rapunzels Tower', 'Disney', '6+', 59.99, 3, 390, 369);

INSERT INTO YearRange VALUES (123, 2000, 2001),
                             (234, 2010, 2011),
                             (234, 2015, 2020),
                             (345, 2014, 2019),
                             (456, 2019, 2021);

INSERT INTO Category VALUES (123, 'Animals'),
                            (234, 'Building'),
                            (234, 'Sports'),
                            (345, 'Animals'),
                            (456, 'Building'),
                            (456, 'Disney');

INSERT INTO Theme VALUES (123, 'Farmland', '2000 to 2001', 'Exciting Farmland Experience!', 'Farming Industries'),
                         (234, 'Batman', '2010 to 2011', 'Help Batman Rescue Gotham', 'DC'),
                         (345, 'BrickHeadz', '2021 to 2022', 'Wish a LEGO® fan good luck with the gift of these cute LEGO BrickHeadz™ Chinese New Year Pandas', 'BrickHeadz'),
                         (456, 'Disney', '2019 to 2021', 'Give Disney Princess fans of all ages an exciting and fulfilling building experience', 'Disney');

INSERT INTO Dimensions VALUES (123, 5, 10, 15),
                              (234, 1, 1, 1),
                              (345, 8, 5, 5),
                              (456, 44, 11, 8);

INSERT INTO Brick VALUES (2, 9874546, 'BRICK 2x4', 'Bright Red', 0.21),
                         (4, 98656, 'BRICK 1x4', 'White', 0.15),
                         (6, 7845, 'BRICK 5x5', 'Blue', 0.11),
                         (8, 32165, 'BRICK 1x2', 'Bright Blue', 0.50),
                         (10, 544556, 'PLATE 2x4', 'Bright Red', 0.20);
                         
INSERT INTO PartList VALUES (123, 2, 10),
                            (123, 4, 3),
                            (234, 4, 19),
                            (234, 8, 1),
                            (345, 4, 11),
                            (345, 8, 2),
                            (345, 10, 3),
                            (456, 2, 1);


-- TODO: add select statements (to print tables)
SELECT * FROM LegoSet;
SELECT * FROM YearRange;
SELECT * FROM Category;
SELECT * FROM Theme;
SELECT * FROM Dimensions;
SELECT * FROM PartList;
SELECT * FROM Brick;


-- TODO: QUERIES

-- (a)
-- Finds Lego Sets that are less that $20.00 and have at least 10 of some brick.
SELECT  L.item_num, L.set_name
FROM    LegoSet L JOIN PartList P USING (item_num)
WHERE   L.price < 25.00 AND P.pieces >= 10; 

-- (b)
-- Finds Lego Sets that have either a Bright Blue 1x2 Brick or a Bright Red 2x4 Plate.
SELECT DISTINCT L.item_num, L.set_name
FROM    LegoSet L JOIN PartList P USING (item_num)
        JOIN Brick B USING (element_id)
WHERE   (B.brick_name = 'BRICK 1x2' AND B.color = 'Bright Blue') 
        OR (B.brick_name = 'PLATE 2x4' AND B.color = 'Bright Red');

-- (c)
-- Finds Lego sets that are in the Disney theme and also in the Building category.
SELECT  L.item_num, L.set_name
FROM    LegoSet L JOIN Category C1 USING (item_num)
        JOIN Category C2 USING (item_num)
WHERE   C1.category_name = 'Disney' AND C2.category_name = 'Building' AND C1.item_num = C2.item_num;

-- (d)
-- Finds Lego sets that are in both the Building category and the Sports category.
SELECT DISTINCT L.item_num, L.set_name
FROM    LegoSet L JOIN Category C1 USING (item_num)
        JOIN Category C2 USING (item_num)
WHERE   C1.category_name = 'Sports' AND C2.category_name = 'Building' AND C1.item_num = C2.item_num;

-- (e)
-- Finds lego sets that were produced under two different year ranges. 
SELECT DISTINCT L.item_num, L.set_name
FROM    LegoSet L JOIN YearRange Y1 USING (item_num)
        JOIN YearRange Y2 USING (item_num)
WHERE   (Y1.start_year != Y2.start_year OR Y1.end_year != Y2.end_year) AND Y1.item_num = Y2.item_num;

-- (f)
-- Finds lego sets that have a low price, a large number of minifigures, and a large number of vip points.
SELECT  item_num, set_name
FROM    LegoSet
WHERE   price < 20.00 AND vip_points > 500 
        AND (minifigure_count > 8 AND minifigure_count IS NOT NULL);

-- (g) Year Range: 2015 - 2021
-- Finds lego sets that were produced within a given year range. 
SELECT  L.item_num, L.set_name
FROM    LegoSet L JOIN YearRange Y USING (item_num)
WHERE   (Y.start_year >= 2015 AND Y.end_year <= 2021) OR (Y.start_year <= 2015 AND Y.end_year >= 2015);

-- (h) My developed queries
-- 1. lego sets that have at least one brick that costs more than $0.20
SELECT DISTINCT L.item_num, L.set_name, B.price
FROM    LegoSet L JOIN PartList P USING (item_num)
        JOIN Brick B USING (element_id)
WHERE   B.price > 0.20;

-- 2. lego sets that are tall (height is greater than 10cm)
SELECT  L.item_num, L.set_name
FROM    LegoSet L JOIN Dimensions D USING (item_num)
WHERE   D.height > 10 AND D.height IS NOT NULL;

-- 3. lego sets with more than one category
SELECT DISTINCT L.item_num, L.set_name
FROM    LegoSet L JOIN Category C1 USING (item_num)
        JOIN Category C2 USING (item_num)
WHERE   C1.category_name != C2.category_name AND C1.item_num = C2.item_num;
