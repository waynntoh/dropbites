<?php

error_reporting(0);
include_once ("dbconnect.php");

$email = $_POST['email'];
$order_id = $_POST['order_id'];
$address = $_POST['address'];
$total = $_POST['total'];
$items_count = $_POST['items_count'];

$items_data = $_POST['items_data'];
$items_json = addslashes($items_data);

$sqlinsert = "INSERT INTO ORDERS(order_id, order_items, total, items_count, email, address) VALUES ('$order_id','$items_json', '$total','$items_count', '$email', '$address')";

if ($conn->query($sqlinsert) === true)
{
    echo "Added Successfully";
}
else
{
    echo "Addition Failed";
}

?>