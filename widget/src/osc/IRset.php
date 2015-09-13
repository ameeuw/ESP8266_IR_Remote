<?php
include 'OSC.php';
include 'settings.php';
$c = new OSCClient();
$c->set_destination($IRserver,$IRport);
$c->send(new OSCMessage("/ir", array((int)$_GET["v"],0,0)));
$c->destroy();
echo "$";
echo $_GET["v"];
?>