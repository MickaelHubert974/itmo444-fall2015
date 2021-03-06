<?php
session_start();

require 'vendor/autoload.php';
use Aws\Sns\SnsClient;


$email = $_SESSION['email'];

print "Hello $email ! \n";


$arn = 'arn:aws:sns:us-east-1:519662356897:ImageUploaded';//hardcoded for now
$_SESSION['arn']=$arn;
$client = SnsClient::factory(array(
    'version' => 'latest',
    'region'  => 'us-east-1'
));


$result = $client->listSubscriptionsByTopic(array(
    // TopicArn is required
    'TopicArn' => $arn,
));

//print $result;

$subscription = $result->get('Subscriptions');
foreach ($subscription as $table) {
	if (in_array($email, $table)){
		echo "\n $email is already subscribed to the topic. \n";
		$subscriptionArn = $table['SubscriptionArn'];
		//print $subscriptionArn;
		if ($subscriptionArn == 'PendingConfirmation'){
		echo "\nPlease confirm your subscription with the email you received.\n";
		}
		else{
			header('Location:gallery.php');
		}
	}
}

if ($subscriptionArn == 'PendingConfirmation'){
	echo "\n";
}
else{
	echo "\nPlease subscribe";
}





?>

<html>
<body>
<form method="post">
<input type="submit" name="conf" value="Confirm subscription" />
<input type="submit" name="subs" value="Subscribe" />
</form>
</html>

<?php

if(isset($_POST['conf'])){

	$result = $client->listSubscriptionsByTopic(array(
   		// TopicArn is required
    	'TopicArn' => $arn,
	));
	$subscription = $result->get('Subscriptions');
	foreach ($subscription as $table) {
		if (in_array('mhubert1@hawk.iit.edu', $table)){
			echo "$email is already subscribed to the topic. \n";
			$subscriptionArn = $table['SubscriptionArn'];
			print $subscriptionArn;
			if ($subscriptionArn == 'PendingConfirmation'){
				echo "\nPlease confirm your subscription with the email you received.\n";
				header('Location:subscription.php'); 
			}
			else{ //user's subscription already confirmed
				header('Location:subscription.php'); 
			}
		}
	}

	
		/*
		echo "\n publishing";
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
		));*/
	
}

if(isset($_POST['subs'])){
	$result = $client->subscribe(array(
    	// TopicArn is required
    	'TopicArn' => $arn,
    	// Protocol is required
    	'Protocol' => 'email',
    	'Endpoint' => $email,
	));

	print $result;
	header('Location:subscription.php'); 
}


?>

