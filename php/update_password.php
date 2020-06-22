<?php

error_reporting(0);
include_once ("dbconnect.php");

$email = $_POST['email'];
$new_password = sha1($_POST['new_password']);

$sql = "UPDATE USERS SET password = '$new_password' WHERE email = '$email'";

if ($conn->query($sql) === true)
{
    echo "Reset Password Successfull";
}
else
{
    echo "Reset Failed";
}

?>