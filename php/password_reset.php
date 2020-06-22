<html>
<body>

<?php

error_reporting(0);
include_once ("dbconnect.php");
$email = $_GET['email'];

?>
    
<form action="update_password.php" method="post">
<p>Enter Your New Password</p>
<input type="hidden" name="email" value="<?php echo $email ?>"><br>
New Password: <input type="text" name="new_password"><br>
<input type="submit">
</form>

</body>
</html>