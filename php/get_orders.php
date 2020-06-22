<?php

error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

$sql = "SELECT * FROM ORDERS WHERE email = '$email' ORDER BY order_date DESC";

$result = $conn->query($sql);
if ($result->num_rows > 0)
{
    $response["orders"] = array();
    while ($row = $result->fetch_assoc())
    {
        $orderslist = array();
        $orderslist["order_id"] = $row["order_id"];
        $orderslist["order_items"] = $row["order_items"];
        $orderslist["items_count"] = $row["items_count"];
        $orderslist["total"] = $row["total"];
        $orderslist["order_date"] = $row["order_date"];
        $orderslist["address"] = $row["address"];
        array_push($response["orders"], $orderslist);
    }
    echo json_encode($response);
}
else
{
    echo "No Orders";
}
?>