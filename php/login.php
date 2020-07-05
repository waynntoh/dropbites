<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);

$sql = "SELECT * FROM USERS WHERE email = '$email' AND password = '$password'";
$result = $conn->query($sql);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        echo $data = "Login Successful,".$row["full_name"].",".$row["email"].",".$row["phone_number"].",".$row["credits"].",".$row["reg_date"].",".$row["verified"].",".$row["admin_privilege"];
    }
}else{
    echo "Login Failed";
}
?>