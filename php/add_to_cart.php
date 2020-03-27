<?php

error_reporting(0);
include_once ("dbconnect.php");

$email = $_POST['email'];
$product_id = $_POST['product_id'];
$product_count = $_POST['product_count'];

$sqlcount = "SELECT * FROM CART WHERE product_id = '$product_id' AND email = '$email'";

$result = $conn->query($sqlcount);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        $product_count = $product_count + $row['product_count'];
    }
    $sqlinsert = "UPDATE CART SET product_count = '$product_count' WHERE product_id = '$product_id' AND email = '$email'";
}
else 
{
    $sqlinsert = "INSERT INTO CART(product_id, product_count, email) VALUES ('$product_id','$product_count', '$email')";
}

if ($conn->query($sqlinsert) === true)
{
    echo "Added Successfully";
}
else
{
    echo "Addition Failed";
}

?>