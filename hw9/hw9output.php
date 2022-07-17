<html>
  <style>
    th {
      border: 1px solid black;
      padding: 5px;
    }

    td {
      border: 1px dotted black;
    }
  </style>
<body>
<?php
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

  // Get country from input
  $country = $_POST["countryChoice"];
  
  // Get country code, gdp, and inflation for given country.
  $query = "SELECT c.country_code, c.gdp, c.inflation " .  
           "FROM Country c " .
           "WHERE c.country_name = ?";

  $stmt = $conn->stmt_init();
  $stmt->prepare($query);
  $stmt->bind_param("s", $country);
  $stmt->execute();
  $stmt->bind_result($c_code, $c_gdp, $c_inflation);

  echo "<h2>" . $country;
  while($stmt->fetch()) {
    echo " (" . $c_code . ")</h2>";
    echo "<p>";
    echo "gdp: " . $c_gdp . "<br>";
    echo "inflation: " . $c_inflation . "<br>";
  }

  // Get number of provinces in given country
  $query = "SELECT COUNT(*)" . 
           "FROM Country c JOIN Province p USING (country_code) " . 
           "WHERE c.country_name = ?";

  $stmt = $conn->stmt_init();
  $stmt->prepare($query);
  $stmt->bind_param("s", $country);
  $stmt->execute();
  $stmt->bind_result($p_count);
  
  while($stmt->fetch()) {
    echo "Number of provinces: " . $p_count . "<br>";
  }
  echo "</p>";
?>

<table>
  <tr>
    <th>City Name</th>
    <th>Province Name</th>
    <th>City Population</th>
  </tr>
    <?php
      // Get city names, province names, and populations for given country.
      $query = "SELECT c1.city_name, c1.province_name, c1.population " . 
               "FROM Country c JOIN City c1 USING (country_code) " . 
               "WHERE c.country_name = ?";

      $stmt = $conn->stmt_init();
      $stmt->prepare($query);
      $stmt->bind_param("s", $country);
      $stmt->execute();
      $stmt->bind_result($city_name, $province_name, $city_population);

      while($stmt->fetch()) {
        // table format
        echo "<tr>";
        echo "<td>" . $city_name . "</td>";
        echo "<td>" . $province_name . "</td>";
        echo "<td>" . $city_population . "</td>";
        echo "</tr>";
      }
    ?>
</table>

<?php
  // clean up
  $stmt->close();
  $conn->close();
?>
</body>
</html>