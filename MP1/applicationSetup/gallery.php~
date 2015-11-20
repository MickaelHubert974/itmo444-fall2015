<html>
<head><title>Gallery</title>
</head>
<body>

<?php
session_start();
$email =$_GET['email'];
echo $email;


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

