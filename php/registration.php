<?php

error_reporting(0);
include_once ("dbconnect.php");
$full_name = $_POST['full_name'];
$email = $_POST['email'];
$phone_number = $_POST['phone_number'];
$password = sha1($_POST['password']);

$sqlinsert = "INSERT INTO USERS(full_name, email, password, phone_number) VALUES ('$full_name','$email','$password','$phone_number')";

if ($conn->query($sqlinsert) === true)
{
    sendEmail($email);
    echo "Registration Successful";
}
else
{
    echo "Registration Failed";
}

function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'DropBites Registration Verification'; 
    $message = 'Verify your email with the link provided here: http://hackanana.com/dropbites/php/registration_verification.php?email='.$useremail; 
    $headers = 'From: noreply@dropbites.com' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}

// http://hackanana.com/dropbites/php/registration.php?full_name=Waynn&email=waynn@gmail.com&phone_number=0192723163&password=123456

?>