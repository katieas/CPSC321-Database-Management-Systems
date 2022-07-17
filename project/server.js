var mysql = require('mysql');
const express = require('express');
const app = express();
const config = require('./private/config.json');
const bodyParser = require('body-parser');

// create the connection
var con = mysql.createConnection(config);

// open the connection
con.connect(function(err) {
    if (err) throw err;
    console.log('>>> Connected to the database');
});

app.use(express.urlencoded({
    extended: true
}));

app.use('/public', express.static('public'));
app.set("view engine", "ejs");

const PORT = 8080;
app.listen(PORT, function () {
    console.log("Server listening on port " + PORT);
})

app.get("/", function(req, res) {
    var query = `SELECT * FROM Profiles`;
    con.query(query, function(err, result) {
        if (err) throw err;
        res.render("index.ejs", {
            Profiles: result
        });
    });
});

app.get("/songList", function(req, res) {
    var query = `SELECT s.song_id, s.song_title, s.artist, s.year, s.genre, s.length, s.difficulty_guitar, s.difficulty_mic, s.dlc, COUNT(p.entry_num) AS play_count
                 FROM Song s LEFT OUTER JOIN Performance p USING (song_id)
                 GROUP BY s.song_id
                 ORDER BY s.song_title`
    con.query(query, function(err, result) {
        if (err) throw err;
        res.render("songList.ejs", {
            songList: result
        });
    });
});

app.get("/songStats", function(req, res) {
    // Total spent on DLC Songs
    var query = `SELECT COUNT(*) * 2.00 AS dlc_spent
                 FROM Song
                 WHERE dlc = TRUE`;
    var dlc_spent;
    con.query(query, function(err, result) {
        if (err) throw err;
        dlc_spent = result[0]['dlc_spent'];
    });
    
    // Most played songs
    var query = `SELECT s.song_id, s.song_title, s.artist, COUNT(*) AS song_count
                 FROM Performance p JOIN Song s USING (song_id)
                 GROUP BY s.song_id
                 HAVING COUNT(*) >= ALL (SELECT COUNT(*)
                                         FROM Performance p JOIN Song s USING (song_id)
                                         GROUP BY s.song_id)`;
    con.query(query, function(err, result1) {
        if (err) throw err;
        var song_count = result1[0]['song_count'];

        // Average Difficulties by Genre
        var query = `SELECT genre, AVG(difficulty_guitar) AS avg_guitar, AVG(difficulty_mic) AS avg_mic
                    FROM Song
                    GROUP BY genre`;
        con.query(query, function(err, result2) {
            if (err) throw err;
            res.render("songStats.ejs", {
                dlc_spent: dlc_spent,
                most_played_songs: result1,
                song_count: song_count,
                genre_difficulty: result2
            });
        });
    });
});

app.get("/profiles", (req, res) => {
    var query = `SELECT * FROM Profiles`;
    con.query(query, function(err, result) {
        if (err) throw err;
        res.render("profiles.ejs", {
            Profiles: result
        });
    });
});

app.get("/profileStats/:id", function(req, res) {
    var player_id = req.params.id;

    var query = `SELECT COUNT(*) AS times_played, SUM(s.length) AS total_time
                 FROM Performance p JOIN Song s USING (song_id)
                      JOIN Profiles p1 ON (p.playerID_guitar = p1.player_id)
                 WHERE p.playerID_guitar = ? OR p.playerID_mic = ?`;

    var minutes, seconds, times_played;
    con.query(query, [player_id, player_id], function(err, result) {
        if (err) throw err;
        minutes = Math.floor(result[0]['total_time'] / 60);
        seconds = result[0]['total_time'] % 60;
        times_played = result[0]['times_played'];
    });

    var query = `SELECT s.song_title, s.artist, COUNT(*) AS most_played_times
                    FROM Performance p JOIN Song s USING (song_id)
                        JOIN Profiles p1 ON (p.playerID_guitar = p1.player_id)
                    WHERE p.playerID_guitar = ? OR p.playerID_mic = ?
                    GROUP BY s.song_id
                    HAVING COUNT(*) >= ALL (SELECT COUNT(*)
                                            FROM Performance p JOIN Song s USING (song_id)
                                                JOIN Profiles p1 ON (p.playerID_guitar = p1.player_id)
                                            WHERE p.playerID_guitar = ? OR p.playerID_mic = ?
                                            GROUP BY s.song_id)`;
    
    con.query(query, [player_id, player_id, player_id, player_id], function(err, result) {
        if (err) throw err;

        res.render("profileStats.ejs", {
            times_played: times_played,
            played_minutes: minutes,
            played_seconds: seconds,
            most_played_songs: result,
            most_played_times: result[0]['most_played_times']
        });
    });

});

app.get("/profileStats", (req, res) => {
    return res.render("profileStats.ejs");
});

app.get("/createPerformance", function(req, res) {
    var query = `SELECT * FROM Profiles`;
    con.query(query, function(err, result) {
        if (err) throw err;
        res.render("createPerformance.ejs", {
            Profiles: result
        });
    });
});

app.get("/newPlayer", function(req, res) {
    return res.render("newPlayer.ejs");
});

// Get Number of Players for Profiles
var num_players;
var query = `SELECT COUNT(*) AS total FROM Profiles`;
con.query(query, function(err, result) {
    if (err) throw err;
    num_players = result[0]['total'];
});

app.post("/profiles", function(req, res) {
    num_players = num_players + 1;
    var first_name = req.body.first_name;
    var last_name = req.body.last_name;
    
    var query = `INSERT INTO Profiles (player_id, first_name, last_name) VALUES (?, ?, ?)`;
    con.query(query, [num_players, first_name, last_name], function(err, result) {
        if (err) throw err;
        console.log(result[0]);
    });
    res.redirect("/profiles");
});

// Get Number of Entries for Performance
var num_entries;
var query = `SELECT COUNT(*) AS total FROM Performance`;
con.query(query, (err, result) => {
    if (err) throw err;
    num_entries = result[0]['total'];
});

app.get("/viewPerformance", function(req, res) {
    var query = `SELECT p.date, s.song_title, s.artist, 
                        p1.first_name AS guitar_first, p1.last_name AS guitar_last, p2.first_name AS mic_first, p2.last_name AS mic_last
                 FROM Performance p JOIN Song s USING (song_id)
                      JOIN Profiles p1 ON (p1.player_id = p.playerID_guitar)
                      JOIN Profiles p2 ON (p2.player_id = p.playerID_mic)
                 ORDER BY date DESC`;
    con.query(query, function(err, result) {
        if (err) throw err;
        res.render("viewPerformance.ejs", {
            Performance: result
        })
    });
});

app.post("/viewPerformance", function(req, res) {
    // Increment number of entries
    num_entries = num_entries + 1;

    // get date
    var date = req.body.date;

    // Get player ID's
    var guitar_player = req.body.guitar;
    var mic_player = req.body.mic;

    // Find Song
    var query = `SELECT song_id
                 FROM Song
                 WHERE INSTR(song_title, ?) AND INSTR(artist, ?)`;
    var songTitle = req.body.song_title;
    var songArtist = req.body.song_artist;
    var songId;
    con.query(query, [songTitle, songArtist], function(err, result) {
        if (err) throw err;
        songId = result[0]['song_id'];
        
        var query = `INSERT INTO Performance 
                 (entry_num, date, song_id, playerID_guitar, playerID_mic)
                 VALUES (?, ?, ?, ?, ?)`;
    
        con.query(query, [num_entries, date, songId, guitar_player, mic_player], (err, result) => {
            if (err) throw err;
            console.log(result[0]);
        });
    });
    res.redirect("/viewPerformance");
});

// close the connection
// con.end(function(err) {
//     if (err) throw err;
//     console.log('>>> Connection to the database closed');
// });