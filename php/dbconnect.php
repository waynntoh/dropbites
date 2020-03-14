<?php
$servername = "localhost";
$username   = "hackanan_waynnt98";
$password   = "5SJ_1tmk1zH9";
$dbname     = "hackanan_dropbites";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    echo "Connection Failed : " . $conn->connect_error;
}
?>