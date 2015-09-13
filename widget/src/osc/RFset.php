<?php
include 'OSC.php';
include 'settings.php';
$c = new OSCClient();
$c->set_destination($RFserver,$RFport);
$c->send(new OSCMessage("/rf", array((int)$_GET["v"],0,0)));
$c->destroy();
echo "$";
echo $_GET["v"];
?>