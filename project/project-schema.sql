/**********************************************************************
 * NAME: Katie Stevens
 * CLASS: CPSC 321 Database Management Systems Fall 2021
 * DATE: 10/28/21
 * HOMEWORK: HW6
 * DESCRIPTION: Part 2 Project: Rockband
 **********************************************************************/

-- Made some changes to Profiles Table.

USE kstevens3_DB;

-- TODO: add drop table statements
DROP TABLE IF EXISTS Performance;
DROP TABLE IF EXISTS Song;
DROP TABLE IF EXISTS Profiles;


-- TODO: add create table statements

-- For every rockband performance the date, song_title, artist, player1_id, and player1_instrument 
-- will be logged. player2_id and player2_instrument is optional.
CREATE TABLE Profiles (
    player_id INT UNSIGNED NOT NULL,
    first_name TINYTEXT NOT NULL,
    last_name TINYTEXT NOT NULL,
    PRIMARY KEY (player_id)
);

CREATE TABLE Song (
    song_id INT UNSIGNED NOT NULL,
    song_title TINYTEXT NOT NULL,
    artist TINYTEXT NOT NULL,
    year INT UNSIGNED NOT NULL,
    genre TINYTEXT NOT NULL,
    length INT UNSIGNED NOT NULL, -- in seconds
    difficulty_guitar INT UNSIGNED, -- difficulty out of 5
    difficulty_mic INT UNSIGNED, -- difficulty out of 5
    dlc BOOL, -- TRUE if paid dlc song
    PRIMARY KEY (song_id)
);

CREATE TABLE Performance (
    entry_num INT UNSIGNED NOT NULL,
    date TINYTEXT NOT NULL, -- 'mm/dd/yy'
    song_id INT UNSIGNED NOT NULL,
    playerID_guitar INT UNSIGNED,
    playerID_mic INT UNSIGNED,
    PRIMARY KEY (entry_num),
    FOREIGN KEY (song_id) REFERENCES Song(song_id),
    FOREIGN KEY (playerID_guitar) REFERENCES Profiles(player_id),
    FOREIGN KEY (playerID_mic) REFERENCES Profiles(player_id)
);


    

-- TODO: add insert statements
INSERT INTO Profiles (player_id, first_name, last_name)
VALUES  (1, 'Katie', 'Stevens'),
        (2, 'Kimberlee', 'Ung'),
        (3, 'Sami', 'Blevens'),
        (4, 'Hannah', 'Dunn');

INSERT INTO Song (song_id, song_title, artist, year, genre, length, difficulty_guitar, difficulty_mic, dlc)
VALUES  (1, 'Teenagers', 'My Chemical Romance', 2006, 'Emo', 161, 3, 2, TRUE),
        (2, 'Still Into You', 'Paramore', 2013, 'Pop-Rock', 213, 5, 1, FALSE),
        (3, 'Killer Queen', 'Queen', 1974, 'Classic Rock', 181, 3, 5, TRUE),
        (4, 'Santeria', 'Sublime', 1996, 'Reggae', 191, 3, 3, TRUE),
        (5, 'Mr. Brightside', 'The Killers', 2004, 'Alternative', 227, 3, 2, TRUE),
        (6, 'Before He Cheats', 'Carrie Underwood', 2005, 'Country', 204, 3, 4, TRUE),
        (7, 'Arabella', 'Artic Monkeys', 2013, 'Rock', 212, 1, 3, FALSE),
        (8, 'R U Mine?', 'Artic Monkeys', 2013, 'Rock', 205, 3, 5, TRUE),
        (9, 'I Miss the Misery', 'Halestorm', 2012, 'Rock', 189, 2, 5, FALSE),
        (10, 'Little White Church', 'Little Big Town', 2010, 'Country', 191, 2, 3, FALSE),
        (11, 'Somebody Told Me', 'The Killers', 2004, 'Alternative', 202, 3, 2, FALSE),
        (12, 'Heat Waves', 'Glass Animals', 2020, 'Rock', 238, 2, 3, TRUE),
        (13, 'Cowboy Casanova', 'Carrie Underwood', 2009, 'Country', 240, 2, 5, TRUE),
        (14, 'Stolen Dance', 'Milky Chance', 2013, 'Alternative', 305, 3, 2, TRUE),
        (15, 'Teenage Dirtbag', 'Wheatus', 2000, 'Rock', 247, 2, 4, TRUE),
        (16, 'Dont Stop Me Now', 'Queen', 1979, 'Classic Rock', 209, 5, 5, FALSE);                            

INSERT INTO Performance (entry_num, date, song_id, playerID_guitar, playerID_mic)
VALUES  (1, '10/28/21', 2, 1, 2),
        (2, '10/28/21', 4, 1, 2),
        (3, '11/11/21', 10, 2, 3),
        (4, '11/11/21', 14, 4, 3),
        (5, '11/11/21', 15, 1, 3),
        (6, '11/11/21', 2, 1, 2),
        (7, '11/12/21', 7, 3, 1),
        (8, '11/12/21', 16, 4, 2),
        (9, '11/13/21', 13, 3, 2),
        (10, '11/13/21', 10, 3, 2),
        (11, '11/14/21', 4, 3, 1),
        (12, '11/15/21', 11, 1, 4),
        (13, '11/15/21', 9, 3, 1),
        (14, '11/30/21', 1, 3, 1),
        (15, '11/30/21', 15, 1, 2),
        (16, '12/01/21', 5, 1, 2),
        (17, '12/01/21', 8, 4, 2),
        (18, '12/01/21', 6, 1, 4),
        (19, '12/02/21', 4, 3, 1),
        (20, '12/02/21', 12, 1, 4);



-- TODO: add select statements (to print tables)
SELECT * FROM Profiles;
SELECT * FROM Song;
SELECT * FROM Performance;
