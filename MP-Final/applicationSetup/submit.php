
<?php
// Start the session
session_start();



echo $_POST['useremail'];

$uploaddir = '/tmp/';
$uploadfile = $uploaddir . basename($_FILES['userfile']['name']);

echo '<pre>';
if (move_uploaded_file($_FILES['userfile']['tmp_name'], $uploadfile)) {
    echo "File is valid, and was successfully uploaded.\n";
    echo $uploadfile;
} else {
    echo "Possible file upload attack!\n";
}

echo 'Here is some more debugging info:';
print_r($_FILES);

print "</pre>";
require 'vendor/autoload.php';

$s3 = new Aws\S3\S3Client([
    'version' => 'latest',
    'region'  => 'us-east-1'
]);


$bucket = uniqid("php-mh-",false);


# AWS PHP SDK version 3 create bucket
$result = $s3->createBucket([
    'ACL' => 'public-read',
    'Bucket' => $bucket
]);


$result = $s3->putObject([ #client modified to s3
    'ACL' => 'public-read',
    'Bucket' => $bucket,
    'Key' => $uploadfile,
    'SourceFile'=> $uploadfile
]); 


$url = $result['ObjectURL'];
echo $url;

//Transform image to thumbnail
$image= new Imagick(glob($uploadfile));
$image->thumbnailImage(100,0);
$image->setImageFormat ("jpg");
$image->writeImage('/tmp/thumbimage.jpg');

$resultthumb = $s3->putObject([
    'ACL' => 'public-read',
    'Bucket' => $bucket,
    'Key' => "thumb".$uploadfile,
    'SourceFile' => "/tmp/thumbimage.jpg",
]);

$urlthumb = $resultthumb['ObjectURL'];

$rds = new Aws\Rds\RdsClient([
    'version' => 'latest',
    'region'  => 'us-east-1'
]);


$result = $rds->describeDBInstances([
    'DBInstanceIdentifier' => 'itmo444-db',

]);


$endpoint = $result['DBInstances'][0]['Endpoint']['Address'];
//print "============\n". $endpoint . "================\n";

//echo "begin database";^M
$link = mysqli_connect($endpoint,"controller","letmein42","customerrecords") or die("Error " . mysqli_error($link));


/* check connection */
if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    exit();
}


/* Prepared statement, stage 1: prepare */
if (!($stmt = $link->prepare("INSERT INTO MyGuests (uname,email,phone,raws3url,finisheds3url,jpgfilename,status) VALUES (?,?,?,?,?,?,?)"))) {
    echo "Prepare failed: (" . $link->errno . ") " . $link->error;
}

$email = $_POST['useremail'];
$uname=strstr($email, '@', true);
$phone = $_POST['phone'];
$raws3ur = $url; //  $result['ObjectURL']; from above
$finisheds3url = $urlthumb;
$jpgfilename = basename($_FILES['userfile']['name']);
$status =0;

$stmt->bind_param('ssssssi',$uname,$email,$phone,$raws3ur,$finisheds3url,$jpgfilename,$status);

if (!$stmt->execute()) {
    echo "Execute failed: (" . $stmt->errno . ") " . $stmt->error;
}

//publishing";

use Aws\Sns\SnsClient;

$arn = $_SESSION['arn'];

$client = SnsClient::factory(array(
    'version' => 'latest',
    'region'  => 'us-east-1'
));

$result = $client->publish(array(
    	'TopicArn' => $arn,
    	// Message is required
    	'Message' => 'Hello ! Your image has been successfully uploaded',
    	'Subject' => 'Successful upload',
    	'MessageAttributes' => array(
    	    // Associative array of custom 'String' key names
    	    'String' => array(
    	        // DataType is required
    	        'DataType' => 'String',
    	        'StringValue' => 'string',
    	    ),
    	    	// ... repeated
    	),
));


header('Location:mygallery.php'); 


?>
