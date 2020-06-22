<?php
error_reporting(0);
//include_once("dbconnect.php");

$email = $_GET['email'];
$phone_number = $_GET['$phone_number']; 
$name = $_GET['name']; 
$amount = $_GET['amount']; 

$api_key = '6fcb1eec-beeb-4860-8e73-b877947c4eb9';
$collection_id = 'cgfieclz';
$host = 'https://billplz-staging.herokuapp.com/api/v3/bills';


$data = array(
          'collection_id' => $collection_id,
          'email' => $email,
          'mobile' => $phone_number,
          'name' => $name,
          'amount' => $amount * 100, 
		  'description' => 'Payment for DropBites reload',
          'callback_url' => "http://hackanana.com/dropbites/return_url",
          'redirect_url' => "http://hackanana.com/dropbites/php/reload_credits_redirect.php?email=$email&phone_number=$phone_number&amount=$amount" 
);


$process = curl_init($host );
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) ); 

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);

//echo "<pre>".print_r($bill, true)."</pre>";
header("Location: {$bill['url']}");
?>