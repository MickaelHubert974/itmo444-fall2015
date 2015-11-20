<html>
<head><title>Gallery</title>
</head>
<body>

<!-- The data encoding type, enctype, MUST be specified as below -->
<form enctype="multipart/form-data" action="submit.php" method="POST">
    <!-- MAX_FILE_SIZE must precede the file input field -->
    <input type="hidden" name="MAX_FILE_SIZE" value="3000000" />
    <!-- Name of input element determines name in $_FILES array -->
    Send this file: <input name="userfile" type="file" /><br />
Enter Email of user: <input type="email" name="useremail"><br />
Enter Phone of user (1-XXX-XXX-XXXX): <input type="phone" name="phone">


<input type="submit" value="Send File" />
</form>
<hr />
<!-- The data encoding type, enctype, MUST be specified as below -->
<form enctype="multipart/form-data" action="gallery.php?email=email&amp" method="GET">
    
Enter Email of user for gallery to browse: <input type="email" name="useremail">
<input type="submit" value="Load Gallery" />
</form>



<?php
session_start();
$email = $_SESSION['email'];
echo "Welcome $email";


require 'vendor/autoload.php';

$rds = new Aws\Rds\RdsClient([
    'version' => 'latest',
    'region'  => 'us-east-1'
]);

$result = $rds->describeDBInstances([
    'DBInstanceIdentifier' => 'itmo444-db',
]);

$endpoint = $result['DBInstances'][0]['Endpoint']['Address'];
echo "<br/>";
print "============\n". $endpoint . "================\n";


//echo "begin database";
$link = mysqli_connect($endpoint,"controller","letmein42","customerrecords") or die("Error " . mysqli_error($link));

/* check connection */
if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    exit();
}

$link->real_query("SELECT * FROM MyGuests WHERE email = '$email'");

$res = $link->use_result();

echo "<br/>";
while ($row = $res->fetch_assoc()) {
    echo "<img src =\" " . $row['raws3url'] . "\" />";
}
$link->close();
?>


</body>
</html>
