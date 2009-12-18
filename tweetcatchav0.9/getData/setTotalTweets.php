<?php
error_reporting(E_ALL);
ini_set('display_errors', '1');

include("dbconn.php");

loadNewswireItems();

function loadNewswireItems() {
	$result = mysql_query( "SELECT * FROM newswire_tb" );
	$total = mysql_num_rows( $result );
	echo "total: ".$total."<br>";
	
	while($row = mysql_fetch_assoc($result)) {
		checkTweets( $row );
	}
	echo "<br /><br /><h1>COMPLETE</h1>";
	
}

function checkTweets( $newsitem ) {
	
	$q = $newsitem["url"];
	$newsitem_id = $newsitem["id"];
	echo "querying: ".$q."<br>";
	$sinceString = "";
	$tweet_result = mysql_query("SELECT * FROM backtweets_db WHERE newswire_id=".$newsitem_id);
	
	$addedTweets = mysql_num_rows($tweet_result);
	
	if ($addedTweets > 0) {
		setTweetTotal($newsitem, $addedTweets);
	}
	
}

function setTweetTotal($newsitem, $addedTweets) {
	//$result = mysql_query( "SELECT * FROM newswire_tb WHERE id=".$newsitem['id']);
	$result = mysql_query("UPDATE newswire_tb SET totalTweets=".$addedTweets." WHERE id=".$newsitem["id"] );
}



?>