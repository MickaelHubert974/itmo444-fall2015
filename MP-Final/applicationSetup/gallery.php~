<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="../favicon.ico">

    <title>Access to the gallery</title>

    <!-- Bootstrap core CSS -->
    <link href="../css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="signin.css" rel="stylesheet">

  </head>

  <body>

    <div class="container">
    


      <form class="form-signin" enctype="multipart/form-data" action="submit.php" method="POST">
        <h2 class="form-signin-heading">Add photo to gallery</h2>
        <input type="file" name="userfile" id="userfile" required>
        <label for="inputEmail" class="sr-only">Email address for gallery to browse</label>
        <input type="email" name="useremail" id="useremail" class="form-control" placeholder="Email address" required autofocus>
        <label for="phone" class="sr-only">Phone</label>
        <input type="phone" name="phone" id="phone" class="form-control" placeholder="Phone number (1-XXX-XXX-XXXX)"required>

        <input class="btn btn-lg btn-primary btn-block" type="submit" value="Send File"/>
      </form>
      
      <form class="form-signin" enctype="multipart/form-data" action="gallery.php" method="POST">
        <h2 class="form-signin-heading">My gallery</h2>
        <label for="inputEmail" class="sr-only">Email address for gallery to browse</label>
        <input type="email" name="useremail" id="useremail" class="form-control" placeholder="Email address" required autofocus>


        <input class="btn btn-lg btn-primary btn-block" type="submit" value="Load Gallery"/>
      </form>

    </div> <!-- /container -->

  </body>
</html>



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



