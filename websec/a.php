<?php
$input = $_GET["name"];
$input = str_replace("<", "", $input);
$input = str_replace(">", "", $input);
?>

<input type="text" value="<?php echo $input ?>">
