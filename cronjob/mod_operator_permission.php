#!/bin/php
<?php

require_once '/gotwo_data/scripts/crontab/public/DbConn.class.php';
require_once '/gotwo_data/scripts/crontab/public/Pop.class.php';

$mod = new Mod_operator_permission;
$mod->go();

class Mod_operator_permission {
  private $db  = null;
  private $pop = null;
  private $operators = array(
                             'zhouyuanjing',
                             'jiangjiang',
                             'chenhh'
                             );

  public function __construct() {
    $this->pop = new Pop('管理员权限升级脚本');
  }

  public function go() {
    $database = array('db_go2', 'db_2mm', 'db_3e3e', 'db_bag8');
    foreach($database as $dbName) {
      $this->db  = DbConn::conn($dbName);
      foreach($this->operators as $operator) {
        $result = $this->mod($operator);
        $this->showMsg($operator, $result);
      }
    }
  }

  private function mod($operator) {
    $sql   = 'update operator set role=1, permission="false" where username="' . $operator . '"';
    return $this->db->exec($sql);
  }

  private function showMsg($operator, $result) {
    if($result) {
      $this->pop->show($operator . "\t权限成功升级为超级管理员！");;
    }else {
      $this->pop->show($operator . "\t权限升级失败！");;
    }
  }
}
