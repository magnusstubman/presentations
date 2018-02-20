<?php

function myhash($password, $salt) {
    $iterations = 1000;
    $hash = hash_pbkdf2("sha512", $password, $salt, $iterations);
    return $hash;
}


echo myhash("pass123", "0hK53wquk")."\n";
echo myhash("m0ney", "yEQ9PjDRZg")."\n";
echo myhash("619air", "2jLyqfZ3E1")."\n";
?>
