<?php
function a($i) {
    echo $i . ":" . md5($i)."\n";
}

a("a");
a("b");
a("c");
a("d");
a("e");

?>

