<?php
error_reporting(E_ALL);
ini_set('display_errors', '1');

include("dbconn.php");

loadNewswireItems();

function loadNewswireItems() {
	$result = mysql_query( "SELECT * FROM newswire_tb ORDER BY id DESC LIMIT 1000" );
	$total = mysql_num_rows( $result );
	echo "total: ".$total."<br>";
	
	while($row = mysql_fetch_assoc($result)) {
		checkTweets( $row );
	}
	
}

function checkTweets( $newsitem ) {
	$backtweet_api_key = "93cf9404dc4d8aebe92f";
	
	$q = $newsitem["url"];
	$newsitem_id = $newsitem["id"];
	echo "querying: ".$q."<br>";
	$sinceString = "";
	$since_result = mysql_query("SELECT * FROM backtweets_db WHERE newswire_id=".$newsitem_id." ORDER BY tweet_id DESC LIMIT 1");
	if ($since_result) {
		$since_row = mysql_fetch_assoc( $since_result );
		$since_id = $since_row["tweet_id"];
		$sinceString .= "&since_id=".$since_id;
	}
	echo "<br>since string: ".$sinceString." since_id: ".$since_id."<br>";
	
	$jsonString = getData( "http://backtweets.com/search.json?q=".$q."&key=".$backtweet_api_key."&itemsperpage=100".$sinceString );
	
	$tweetsObj = json_decode( $jsonString );
	
	//echo "status: ".$tweetsObj->status;
	//echo $jsonString;.
	
	echo "total results: ".$tweetsObj->totalresults."<br>";
	
	//$indexable = 1;
	//if ($tweetsObj->totalresults < 1) {
	//	if ($newsitem["indexed"] > 2) {
			//$indexable = 0;
	//	}
	//}
	
	//mysql_query( "UPDATE newswire_tb SET indexable=".$indexable.", indexed=indexed+1 WHERE id=".$newsitem["id"] );
	$addedTweets = 0;
	
	for ($i = 0; $i < count( $tweetsObj->tweets ); $i++) {
	//	echo $tweetsObj->tweets[$i]->tweet_from_user ."<br>";
		echo "<br>Tweet: since id : ".$sinceString."<br>";
		if (insertTweet( $tweetsObj->tweets[$i], $newsitem["id"] )) {
			$addedTweets += 1;
		}
		echo "<br><br>";
	}
	if ($addedTweets > 0) {
		updateTweetTotal($newsitem, $addedTweets);
	}
	
}

function insertTweet($tweet, $newswire_id) {
	$tweet_id					= $tweet->tweet_id;
	$tweet_from_user_id			= $tweet->tweet_from_user_id;
	$tweet_from_user			= $tweet->tweet_from_user;
	$tweet_profile_image_url		= $tweet->tweet_profile_image_url;
	$tweet_created_at			= $tweet->tweet_created_at;
	$tweet_text				= $tweet->tweet_text;
	
	
	$result = mysql_query( "INSERT INTO backtweets_db (tweet_id, tweet_from_user_id, tweet_from_user, tweet_profile_image_url, tweet_created_at, tweet_text, newswire_id) VALUES ('$tweet_id', '$tweet_from_user_id', '$tweet_from_user', '$tweet_profile_image_url', '$tweet_created_at', '$tweet_text', '$newswire_id')" );
	
	//$result = mysql_query( "INSERT INTO backtweets_db (tweet_id) VALUES ('$tweet_id')" );
	
	echo "result: ".$result." id: ".$tweet_id." user_id: ".$tweet_from_user_id." user: ".$tweet_from_user." profile image: ".$tweet_profile_image_url." created: ".$tweet_created_at."\n".$tweet_text;
	if ($result) return true;
	
	return false;
	
}

function updateTweetTotal($newsitem, $addedTweets) {
	//$result = mysql_query( "SELECT * FROM newswire_tb WHERE id=".$newsitem['id']);
	$result = mysql_query("UPDATE newswire_tb SET totalTweets=totalTweets+".$addedTweets." WHERE id=".$newsitem["id"] );
}

//cURLs a URL and returns it
function getData($query) {
	
	// create curl resource
	$ch = curl_init();
	
	// cURL url
	curl_setopt($ch, CURLOPT_URL, $query);
	
	//Set some necessary params for using CURL
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	
	//Execute the curl function, and decode the returned JSON data
	$result = curl_exec($ch);
	return $result;
	
	// close curl resource to free up system resources
	curl_close($ch);
}

?>