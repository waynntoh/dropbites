<?php

error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$product_id = $_POST['product_id'];
$clear = $_POST['clear'];

if (isset($clear)) {
    $sql = "DELETE FROM CART WHERE email = '$email'";
} else {
    $sql = "DELETE FROM CART WHERE email = '$email' AND product_id = '$product_id'";
}

if ($conn->query($sql) === true)
{
    echo "Deleted Successfully";
}
else
{
    echo "Deletion Failed";
}
?>