<?php
session_start();

$_SESSION['email'] = $_POST['useremail'];
$_SESSION['phone'] = $_POST['phone'];
$_SESSION['jpg'] = $_FILES['userfile']['name'];
header('Location:subscription.php');

?>
