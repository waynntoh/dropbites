<?php

error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

$sql = "SELECT i.name, i.id, i.price, i.rating, i.type, i.description, c.product_count, i.price*c.product_count FROM ITEMS AS i, CART AS c WHERE c.product_id = i.id AND c.email = '$email'";

$result = $conn->query($sql);
if ($result->num_rows > 0)
{
    $response["cart"] = array();
    while ($row = $result->fetch_assoc())
    {
        $cartlist = array();
        $cartlist["name"] = $row["name"];
        $cartlist["id"] = $row["id"];
        $cartlist["price"] = $row["price"];
        $cartlist["rating"] = $row["rating"];
        $cartlist["type"] = $row["type"];
        $cartlist["description"] = $row["description"];
        $cartlist["product_count"] = $row["product_count"];
        $cartlist["subtotal"] = $row["i.price*c.product_count"];
        array_push($response["cart"], $cartlist);
    }
    echo json_encode($response);
}
else
{
    echo "Cart Empty";
}
?>