<?php
include 'OSC.php';
include 'settings.php';
$c = new OSCClient();
$c->set_destination($IRserver,$IRport);
$c->send(new OSCMessage("/ir", array(0)));
echo "$";
echo $_GET["v"];
?>