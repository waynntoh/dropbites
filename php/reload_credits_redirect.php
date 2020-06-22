<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_GET['email'];
$phone_number = $_GET['phone_number'];
$amount = $_GET['amount'];

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus=="true"){
    $paidstatus = "Success";
}else{
    $paidstatus = "Failed";
}
$receiptid = $_GET['billplz']['id'];
$signing = '';
foreach ($data as $key => $value) {
    $signing.= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}
 
 
$signed= hash_hmac('sha256', $signing, 'S-C1nKtyVrBQEafw1y-Go4XA');
if ($signed === $data['x_signature']) {

    if ($paidstatus == "Success"){
        $sqlremainingcredits = "SELECT * FROM USERS WHERE email = '$email'";
        
        // Update new credits
        $result = $conn->query($sqlremainingcredits);
        while ($row = $result ->fetch_assoc()){
            $credits = $amount + $row['credits'];
        }
        $sqlupdatecredits = "UPDATE USERS SET credits = '$credits' WHERE email = '$email'";
        
        // Insert new row to reloads
        $sqlinsert = "INSERT INTO RELOADS(bill_id, email, amount) VALUES ('$receiptid','$email', '$amount')";
        
        $conn->query($sqlupdatecredits);
        $conn->query($sqlinsert);
        
        echo '<br><br><body><div><h2><br><br><center>Reload Receipt</center></h1><table border=1 width=80% align=center><tr></tr><tr><td>Receipt ID</td><td>'.$receiptid.'</td></tr><tr><td>Email to </td><td>'.$email. ' </td></tr><td>Amount </td><td>RM '.$amount.'</td></tr><tr><td>Payment Status </td><td>'.$paidstatus.'</td></tr><tr><td>Date </td><td>'.date("d/m/Y").'</td></tr><tr><td>Time </td><td>'.date("h:i a").'</td></tr></table><br><p><center>Press the back button to return to DropBites</center></p></div></body>';
        
    } 
        else 
    {
    echo 'Payment Failed!';
    }
}

?>