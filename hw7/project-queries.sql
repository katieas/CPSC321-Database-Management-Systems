/**********************************************************************
 * NAME: Katie Stevens
 * CLASS: CPSC 321 Database Management Systems
 * DATE: 11/11/21   
 * HOMEWORK: HW7
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
SELECT COUNT(*) * 2.00
FROM Song
WHERE dlc = TRUE;

-- (d)
-- Query returns the average song length by genre
SELECT genre, AVG(length)
FROM Song
GROUP BY genre;

-- (e)
-- Query returns songs by genre from most frequent to least frequent.
SELECT genre
FROM Song
GROUP BY genre
ORDER BY COUNT(*) DESC;