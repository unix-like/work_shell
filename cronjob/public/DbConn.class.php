<?php

class DbConn {
  
  public static function conn($dbName='db_go2') {
    $dsn    = 'mysql:host=127.0.0.1;port=40003;dbname=' . $dbName;
    $user   = 'root';
    $pass   = 'leweisa';
    $option = array(PDO::MYSQL_ATTR_INIT_COMMAND=>'set names utf8');
    $conn   = new PDO($dsn, $user, $pass, $option);
    $conn->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_OBJ);
    return $conn;
  }
}
