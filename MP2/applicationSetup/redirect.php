<?php
session_start();

$_SESSION['email'] = $_POST['useremail'];
header('Location:subscription.php');

?>
