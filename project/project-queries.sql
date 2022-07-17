/**********************************************************************
 * NAME: Katie Stevens
 * CLASS: CPSC 321 Database Management Systems
 * DATE: 11/11/21   
 * HOMEWORK: Project
 * DESCRIPTION: 
 **********************************************************************/


-- TODO: add queries with comments below
DROP VIEW IF EXISTS SymmetricPerformance;

-- (a)
-- Query returns total amount of songs played per player.
CREATE VIEW SymmetricPerformance AS
SELECT *
FROM Performance
UNION
SELECT entry_num, date, song_id, player2_id, player2_instrument, player1_id, player1_instrument 
FROM Performance;

SELECT p.player_id, p.first_name, p.last_name, COUNT(*)
FROM SymmetricPerformance SP JOIN Profiles p ON (player1_id = player_id)
GROUP BY SP.player1_id;

-- (b)
-- Query returns song list ordered alphabetically by artist and song title.
SELECT song_id, artist, song_title
FROM Song
ORDER BY artist, song_title;

-- (c)
-- Query returns how much money was spent on dlc songs. Each dlc song costs about $2.00
SELECT COUNT(*) * 2.00 AS dlc_spent
FROM Song
WHERE dlc = TRUE;

-- (d)
-- Query returns the average song length by genre
SELECT genre, AVG(length)
FROM Song
GROUP BY genre;

-- (e)
-- Query returns songs by genre from most frequent to least frequent.
SELECT genre, COUNT(*)
FROM Song
GROUP BY genre
ORDER BY COUNT(*) DESC;



-- most played song
SELECT s.song_title, s.artist, COUNT(*)
FROM Song s JOIN Performance p USING (song_id)
GROUP BY s.song_id
ORDER BY COUNT(*) DESC;

-- most played artist
SELECT s.artist, COUNT(*)
FROM Song s JOIN Performance p USING (song_id)
GROUP BY s.artist
ORDER BY COUNT(*) DESC;

-- number of times chosen player played, time played (sum of song lengths)
SELECT COUNT(*), SUM(s.length)
FROM Performance p JOIN Song s USING (song_id)
     JOIN Profiles p1 ON (p.playerID_guitar = p1.player_id)
WHERE p.playerID_guitar = 4 OR p.playerID_mic = 4;

-- most played song/artist for player
SELECT s.song_id, s.song_title, s.artist, COUNT(*)
FROM Performance p JOIN Song s USING (song_id)
     JOIN Profiles p1 ON (p.playerID_guitar = p1.player_id)
WHERE p.playerID_guitar = 2 OR p.playerID_mic = 2
GROUP BY s.song_id, s.artist
ORDER BY COUNT(*) DESC;

SELECT s.song_title, s.artist, COUNT(*) AS most_played_times
FROM Performance p JOIN Song s USING (song_id)
     JOIN Profiles p1 ON (p.playerID_guitar = p1.player_id)
WHERE p.playerID_guitar = ? OR p.playerID_mic = ?
GROUP BY s.song_id
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
                    FROM Performance p JOIN Song s USING (song_id)
                        JOIN Profiles p1 ON (p.playerID_guitar = p1.player_id)
                    WHERE p.playerID_guitar = ? OR p.playerID_mic = ?
                    GROUP BY s.song_id)

-- guitar/mic play times
SELECT COUNT(*) AS instrument
FROM Performance p JOIN Profiles p1 ON (p.playerID_guitar = p1.player_id)
WHERE p.playerID_guitar = 2 OR p.playerID_mic = 2
GROUP BY p.player_id ----------- idk

-- songs that have not been played 
SELECT *
FROM Performance p RIGHT OUTER JOIN Song s USING (song_id)
WHERE p.entry_num IS NULL;



SELECT * FROM Song ORDER BY song_title;

SELECT s.song_id, s.song_title, s.artist, s.year, s.genre, s.length, 
       s.difficulty_guitar, s.difficulty_mic, s.dlc, COUNT(p.entry_num) AS play_count
FROM Song s LEFT OUTER JOIN Performance p USING (song_id)
GROUP BY s.song_id
ORDER BY s.song_title

-- average difficulties by genre
SELECT genre, COUNT(*), AVG(difficulty_guitar), AVG(difficulty_mic)
FROM Song
GROUP BY genre

SELECT s.song_id, s.song_title, s.artist, COUNT(*)
FROM Performance p JOIN Song s USING (song_id)
GROUP BY s.song_id
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
                    FROM Performance p JOIN Song s USING (song_id)
                    GROUP BY s.song_id)

SELECT genre, AVG(difficulty_guitar) AS avg_guitar, AVG(difficulty_mic) AS avg_mic
FROM Song
GROUP BY genre

