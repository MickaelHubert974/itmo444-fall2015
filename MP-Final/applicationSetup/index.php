<?php session_start(); ?>
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
    


      <form class="form-signin" enctype="multipart/form-data" action="redirect.php" method="POST">
        <h2 class="form-signin-heading">Identification</h2>
        <label for="inputEmail" class="sr-only">Email address for gallery to browse</label>
        <input type="email" name="useremail" id="useremail" class="form-control" placeholder="Email address" required autofocus>

		<input class="btn btn-lg btn-primary btn-block" type="submit" value="Load Gallery" />
      </form>

    </div> <!-- /container -->

  </body>
</html>


















