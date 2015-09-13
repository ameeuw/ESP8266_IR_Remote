<?php
$db = pg_connect("host=localhost dbname=005694 user=005694 password=i0Isjvr4xmbF"); 
$query = "SELECT * FROM interface"; 
$result = pg_query($query);
$result_row = pg_fetch_assoc($result);
//recall echo
echo "$";
echo $result_row["red"];
echo "$";
echo $result_row["green"];
echo "$";
echo $result_row["blue"];
?>