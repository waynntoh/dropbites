<?php

error_reporting(0);
include_once ("dbconnect.php");

$email = $_POST['email'];
$col = $_POST['col'];
$new_data = $_POST['new_data'];

$old_password = $_POST['old_password'];

$old_password1 = sha1($old_password);
$new_data1 = sha1($new_data);

if (isset($old_password)) {
    $sql = "SELECT * FROM USERS WHERE email = '$email' AND password = '$old_password1'";
    $result = $conn->query($sql);
    
    if ($result->num_rows > 0) {
         $sql = "UPDATE USERS SET $col = '$new_data1' WHERE email = '$email'";
    } else {
        echo "-";
    }
    
} else {
    $sql = "UPDATE USERS SET $col = '$new_data' WHERE email = '$email'";
}

if ($conn->query($sql) === true)
{
    echo "Edited Successfully";
}
else
{
    echo "Edit Failed";
}

?>