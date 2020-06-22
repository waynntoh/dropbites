<?php

error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

$sql = "SELECT * FROM USERS WHERE email = '$email'";

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        sendEmail($email);
    echo "Sent Successfully";
    }
}else{
    echo "Sent Failed";
}

function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'DropBites Account Password Reset'; 
    $message = 'Proceed to reset your password with the link given: http://hackanana.com/dropbites/php/password_reset.php?email='.$useremail; 
    $headers = 'From: noreply@dropbites.com' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}

?>
