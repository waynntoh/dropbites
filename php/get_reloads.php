<?php

error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

$sql = "SELECT * FROM RELOADS WHERE email = '$email' ORDER BY reload_date DESC";

$result = $conn->query($sql);
if ($result->num_rows > 0)
{
    $response["reloads"] = array();
    while ($row = $result->fetch_assoc())
    {
        $reloadslist = array();
        $reloadslist["bill_id"] = $row["bill_id"];
        $reloadslist["email"] = $row["email"];
        $reloadslist["amount"] = $row["amount"];
        $reloadslist["reload_date"] = $row["reload_date"];
        array_push($response["reloads"], $reloadslist);
    }
    echo json_encode($response);
}
else
{
    echo "No Orders";
}
?>