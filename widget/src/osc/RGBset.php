<?php
include 'OSC.php';
include 'settings.php';
$c = new OSCClient();
$c->set_destination($RGBserver,$RGBport);

//Original OSCMessage format for old code - now all channels are seperate:
//$c->send(new OSCMessage("/rgb", array((int)$_GET["r"],(int)$_GET["g"],(int)$_GET["b"])));

$c->send(new OSCMessage("/r", array(((int)$_GET["r"])/255)));
$c->send(new OSCMessage("/g", array(((int)$_GET["g"])/255)));
$c->send(new OSCMessage("/b", array(((int)$_GET["b"])/255)));

$c->destroy();

echo "$";
echo $_GET["r"];
echo "$";
echo $_GET["g"];
echo "$";
echo $_GET["b"];
?>