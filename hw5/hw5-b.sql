/**********************************************************************
 * NAME: Katie Stevens
 * CLASS: CPSC 321
 * DATE: 10/19/2021
 * HOMEWORK: HW5
 * DESCRIPTION: 
 **********************************************************************/

USE kstevens3_DB;

-- TODO: add drop table statements
DROP TABLE IF EXISTS PartList;
DROP TABLE IF EXISTS Brick;
DROP TABLE IF EXISTS Dimensions;
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
    year_range VARCHAR(50) NOT NULL,
    category VARCHAR(50) NOT NULL,
    set_name TINYTEXT NOT NULL,
    theme TINYTEXT NOT NULL,
    age_range VARCHAR(50) NOT NULL,
    price FLOAT NOT NULL,
    minifigure_count INT UNSIGNED,
    vip_points INT UNSIGNED NOT NULL,
    total_pieces INT UNSIGNED NOT NULL,
    PRIMARY KEY(item_num, year_range, category)
);

/*
The category table compares lego set item numbers with their categories.
*/
CREATE TABLE Category (
    item_num INT UNSIGNED NOT NULL,
    category_name VARCHAR(50),
    PRIMARY KEY(item_num),
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
    brick_id INT UNSIGNED NOT NULL,
    pieces INT UNSIGNED,
    PRIMARY KEY(item_num, brick_id),
    FOREIGN KEY(item_num) REFERENCES LegoSet(item_num),
    FOREIGN KEY(brick_id) REFERENCES Brick(element_id)
);


-- TODO: add insert statements
INSERT INTO LegoSet VALUES (123, '2000 to 2001', 'Animals', 'Farmland', 'Epic Farm', '3+', 49.99, 3, 501, 200),
                            (234, '2010 to 2011', 'Cities', 'Batman', 'Gotham City', '18+', 99.99, 5, 300, 500);

INSERT INTO Category VALUES (123, 'Animals'),
                            (234, 'Cities');

INSERT INTO Theme VALUES (123, 'Farmland', '2000 to 2001', 'Exciting Farmland Experience!', 'Farming Industries'),
                         (234, 'Batman', '2010 to 2011', 'Help Batman Rescue Gotham', 'DC');

INSERT INTO Dimensions VALUES (123, 5, 10, 15),
                              (234, 1, 1, 1);

INSERT INTO Brick VALUES (2, 9874546, 'BRICK 2x4', 'Bright Red', 0.21),
                         (3, 98656, 'BRICK 1x4', 'White', 0.15),
                         (9, 7845, 'BRICK 5x5', 'Blue', 0.11);
                         
INSERT INTO PartList VALUES (123, 2, 10),
                            (123, 3, 3),
                            (234, 3, 19),
                            (234, 9, 1);


-- TODO: add select statements (to print tables)
SELECT * FROM LegoSet;
SELECT * FROM Category;
SELECT * FROM Theme;
SELECT * FROM Dimensions;
SELECT * FROM PartList;
SELECT * FROM Brick;

