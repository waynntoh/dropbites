<?php

include_once ("dbconnect.php");

$email = $_GET['email'];

$sql = "UPDATE USERS SET verified = True WHERE email = '$email'";

if ($conn->query($sql) === true)
{
    echo "$email is verified successfully.";
}
else
{
    echo "Verification Failed";
}

?>