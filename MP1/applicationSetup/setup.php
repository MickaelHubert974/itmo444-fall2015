<?php
// Start the session^M
require 'vendor/autoload.php';
$rds = new Aws\Rds\RdsClient([
    'version' => 'latest',
    'region'  => 'us-east-1'
]);

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
    'VpcSecurityGroupIds' => 'sg-cc1029ab',
]);

print "Create RDS DB results: \n";
# print_r($rds);

$result = $rds->waitUntil('DBInstanceAvailable',['DBInstanceIdentifier' => 'itmo444-db',
]);


// Create a table 
$result = $rds->describeDBInstances([
    'DBInstanceIdentifier' => 'itmo444-db',
]);


$endpoint = $result['DBInstances'][0]['Endpoint']['Address'];
print "============\n". $endpoint . "================\n";



$link = mysqli_connect($endpoint,"controller","letmein42","3306") or die("Error " . mysqli_error($link)); 

echo "Here is the result: " . $link;


$sql = "CREATE TABLE comments 
(
ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
PosterName VARCHAR(32),
Title VARCHAR(32),
Content VARCHAR(500)
)";

$con->query($sql);

?>

