<?php
//error_reporting(0);
$id = $_POST['id'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);

$path = '../product_images/'.$id.'.jpg';

if (file_put_contents($path, $decoded_string)){
    echo 'Upload Successful';
}else{
    echo 'Upload Failed';
}

?>