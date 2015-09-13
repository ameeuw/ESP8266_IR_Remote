<?php
include 'OSC.php';
include 'settings.php';
$c = new OSCClient();
$c->set_destination($RFserver,$RFport);
$c->send(new OSCMessage("/rf", array(0,0,0)));
echo "$";
echo $_GET["v"];
?>