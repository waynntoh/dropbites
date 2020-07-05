<?php

error_reporting(0);
include_once ("dbconnect.php");

$id = $_POST['id'];
$name = $_POST['name'];
$price = $_POST['price'];
$rating = $_POST['rating'];
$type = $_POST['type'];
$description = $_POST['description'];

$sqlinsert = "INSERT INTO ITEMS(id, name, price, rating, type, description) VALUES ('$id','$name', '$price','$rating', '$type', '$description')";

if ($conn->query($sqlinsert) === true)
{
    echo "Added Successfully";
}
else
{
    echo "Addition Failed";
}

?>