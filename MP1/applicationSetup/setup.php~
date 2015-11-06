<?php
// Start the session^M
require 'vendor/autoload.php';

$rds = new Aws\Rds\RdsClient([
    'version' => 'latest',
    'region'  => 'us-east-1'
]);

//DB created in launch-all script
//uncomment to create db here
/*
$result = $rds->createDBInstance([
    'AllocatedStorage' => 10,
    #'AutoMinorVersionUpgrade' => true || false,
    'AvailabilityZone' => 'us-east-1a',
    #'BackupRetentionPeriod' => <integer>,
   # 'CharacterSetName' => '<string>',
   # 'CopyTagsToSnapshot' => true || false,
   # 'DBClusterIdentifier' => '<string>',
    'DBInstanceClass' => 'db.t1.micro', // REQUIRED
    'DBInstanceIdentifier' => 'itmo444-db', // REQUIRED
    'DBName' => 'customerrecords',
    #'DBParameterGroupName' => '<string>',
    #'DBSecurityGroups' => ['<string>', ...],
    #'DBSubnetGroupName' => '<string>',
    'Engine' => 'MySQL', // REQUIRED
    'EngineVersion' => '5.5.41',
    #'Iops' => <integer>,
    #'KmsKeyId' => '<string>',
   # 'LicenseModel' => '<string>',
  'MasterUserPassword' => 'letmein42',
    'MasterUsername' => 'controller',
    #'MultiAZ' => true || false,
    #'OptionGroupName' => '<string>',
    #'Port' => <integer>,
    #'PreferredBackupWindow' => '<string>',
    #'PreferredMaintenanceWindow' => '<string>',
    'PubliclyAccessible' => true,
    #'StorageEncrypted' => true || false,
    #'StorageType' => '<string>',
   # 'Tags' => [
   #     [
   #         'Key' => '<string>',
   #         'Value' => '<string>',
   #     ],
        // ...
   # ],
    #'TdeCredentialArn' => '<string>',
    #'TdeCredentialPassword' => '<string>',
    #'VpcSecurityGroupIds' => ['<string>', ...],
]);

print "Create RDS DB results: \n";
# print_r($rds);
*/

$result = $rds->waitUntil('DBInstanceAvailable',['DBInstanceIdentifier' => 'itmo444-db',
]);


// Create a table 
$result = $rds->describeDBInstances([
    'DBInstanceIdentifier' => 'itmo444-db',
]);


$endpoint = $result['DBInstances'][0]['Endpoint']['Address'];
print "============\n". $endpoint . "================\n";

// Create connection
#http://www.w3schools.com/php/php_mysql_create_table.asp

$servername = $endpoint; 
$username = "controller";
$password = "letmein42";
$dbname = "customerrecords";

$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// sql to create table
$sql = "CREATE TABLE MyGuests (
id INT NOT NULL AUTO_INCREMENT primary key,
uname VARCHAR(20) NOT NULL,
email VARCHAR(20) NOT NULL,
phone VARCHAR(20) NOT NULL,
raws3url VARCHAR(256) NOT NULL,
finisheds3url VARCHAR(256) NOT NULL,    
jpgfilename VARCHAR(256) NOT NULL,	
status TINYINT(3),
date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)";

if ($conn->query($sql) === TRUE) {
    echo "Table MyGuests created successfully";
} else {
    echo "Error creating table: " . $conn->error;
}

$conn->close();


?>

