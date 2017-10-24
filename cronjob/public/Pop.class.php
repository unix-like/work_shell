<?php

class Pop {
  public $title = '';
  
  public function __construct($title='') {
    if($title) {
      $this->title = $title;
    }else {
      $this->title = '脚本';
    }
    $this->show($title . "\t开始执行！");
  }

  public function __destruct() {
    $this->show($this->title . "\t执行结束！\n");
  }
 
  public function show($msg) {
    echo date('Y-m-d H:i:s') . "\t" . $msg . "\n";
  }
}
