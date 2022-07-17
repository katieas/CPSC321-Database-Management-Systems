/**********************************************************************
 * NAME: Katie Stevens
 * CLASS: CPSC 321 Database Management Systems Fall 2021
 * DATE: 10/28/21
 * HOMEWORK: HW6
 * DESCRIPTION: Part 2 Project: Rockband
 **********************************************************************/

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
    name TINYTEXT NOT NULL,
    total_songs_played INT UNSIGNED NOT NULL,
    num_times_guitar INT UNSIGNED,
    num_times_mic INT UNSIGNED,
    PRIMARY KEY (player_id)
);

CREATE TABLE Song (
    song_title VARCHAR(100) NOT NULL,
    artist VARCHAR(100) NOT NULL,
    length INT UNSIGNED NOT NULL, -- in seconds
    difficulty_guitar INT UNSIGNED, -- difficulty out of 5
    difficulty_mic INT UNSIGNED, -- difficulty out of 5
    dlc BOOL, -- TRUE if paid dlc song
    PRIMARY KEY (song_title, artist)
);

CREATE TABLE Performance (
    entry_num INT UNSIGNED NOT NULL,
    date TINYTEXT NOT NULL,
    song_title TINYTEXT NOT NULL,
    artist TINYTEXT NOT NULL,
    player1_id INT UNSIGNED NOT NULL,
    player1_instrument TINYTEXT NOT NULL,
    player2_id INT UNSIGNED,
    player2_instrument TINYTEXT,
    PRIMARY KEY (entry_num),
    FOREIGN KEY (player1_id) REFERENCES Profiles(player_id),
    FOREIGN KEY (player2_id) REFERENCES Profiles(player_id)
);


    

-- TODO: add insert statements
INSERT INTO Profiles VALUES (1, 'Katie', 2, 1, 1),
                            (2, 'Kimberlee', 2, 1, 1),
                            (3, 'Sami', 0, 0, 0),
                            (4, 'Hannah', 0, 0, 0);

INSERT INTO Song VALUES ('Teenagers', 'My Chemical Romance', 161, 3, 2, TRUE),
                        ('Still Into You', 'Paramore', 213, 5, 1, FALSE),
                        ('Killer Queen', 'Queen', 181, 3, 5, TRUE),
                        ('Santeria', 'Sublime', 191, 3, 3, TRUE),
                        ('Mr. Brightside', 'The Killers', 227, 3, 2, TRUE);                            

INSERT INTO Performance VALUES  (1, '10/28/21', 'Still Into You', 'Paramore', 1, 'guitar', 2, 'microphone'),
                                (2, '10/28/21', 'Santeria', 'Sublime', 1, 'microphone', 2, 'guitar');



-- TODO: add select statements (to print tables)
SELECT * FROM Profiles;
SELECT * FROM Song;
SELECT * FROM Performance;


