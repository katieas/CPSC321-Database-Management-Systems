<html>
<body>
<h1>CIA World Factbook</h1>

<?php
//   $config = parse_ini_file("../private/config.ini");
  $config = parse_ini_file("config.ini");
  $server = $config["servername"];
  $username = $config["username"];
  $password = $config["password"];
  $database = "kstevens3_DB";

  // connect
  $conn = mysqli_connect($server, $username, $password, $database);

  // check connection
  if (!$conn) {
    die("Connection failed: " . mysqli_connect_error()); 
  }
?>

    <form action="hw9output.php" method="POST">
        <label for="countryChoice">Choose a country: </label>
        <select name="countryChoice">
            <?php
                $query = "SELECT country_name FROM Country";
                $result = mysqli_query($conn, $query);

                while ($row = mysqli_fetch_assoc($result)) {
                    echo "<option value=\"" . $row["country_name"] . "\">" . $row["country_name"] . "</option>";
                }
            ?>
        </select>
        <input type="submit" value="Display Information">
    </form>

<?php
  // clean up
  $stmt->close();
  $conn->close();
?>

</body>
</html>
