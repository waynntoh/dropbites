<?php

error_reporting(0);
include_once ("dbconnect.php");

$id = $_POST['id'];
$col = $_POST['col'];
$new_data = $_POST['new_data'];

$sql = "UPDATE ITEMS SET $col = '$new_data' WHERE id = '$id'";

if ($conn->query($sql) === true)
{
    echo "Edited Successfully";
}
else
{
    echo "Edit Failed";
}

?>