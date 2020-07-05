<?php

error_reporting(0);
include_once ("dbconnect.php");
$id = $_POST['id'];

$sql = "DELETE FROM ITEMS WHERE id = '$id'";

if ($conn->query($sql) === true)
{
    echo "Deleted Successfully";
}
else
{
    echo "Deletion Failed";
}
?>