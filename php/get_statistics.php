<?php

error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

$sql = "SELECT * FROM ORDERS WHERE email = '$email'";

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $total = 0;
    $items_count = 0;
    while ($row = $result->fetch_assoc())
    {
        $total += $row["total"];
        $items_count += $row["items_count"];
        
        array_push($response["cart"], $cartlist);
    }
    
    echo "Success, $result->num_rows, $items_count, $total";
}
else
{
    echo "No Orders";
}

?>