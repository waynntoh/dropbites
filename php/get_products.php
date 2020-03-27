<?php

error_reporting(0);
include_once ("dbconnect.php");
$type = $_POST['type'];

if (isset($type)){
    $sql = "SELECT * FROM ITEMS WHERE type = '$type'";
}else{
    $sql = "SELECT * FROM ITEMS";    
}


$result = $conn->query($sql);
if ($result->num_rows > 0)
{
    $response["items"] = array();
    while ($row = $result->fetch_assoc())
    {
        $itemslist = array();
        $itemslist["id"] = $row["id"];
        $itemslist["name"] = $row["name"];
        $itemslist["price"] = $row["price"];
        $itemslist["type"] = $row["type"];
        $itemslist["rating"] = $row["rating"];
        $itemslist["description"] = $row["description"];
        array_push($response["items"], $itemslist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>