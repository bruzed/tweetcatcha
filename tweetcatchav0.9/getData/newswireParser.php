<?php

error_reporting(E_ALL);
ini_set('display_errors', '1');

include("dbconn.php");

$offset = 0;

loadData();

function loadData() {
	global $offset;
	
	$jsonString = getData( "http://api.nytimes.com/svc/news/v2/all/last24hours.json?api-key=6a30bd922857352952ccfd11c2c6b81f:6:59193871&offset=".$offset );
	
	$newsObj = json_decode( $jsonString );
	
	echo "status: ".$newsObj->status;
	
	if ($newsObj->status == "OK") {
		
		echo "<br><br><br><br>";
		
		for ($i = 0; $i < count( $newsObj->results ); $i++) {
			checkNewsItem( $newsObj->results[$i] );
		}
		// keep going till we get an error //
		$offset += 20;
		loadData();
	}
	
}

// json item with format //
/*
{
	"section":"Automobiles",
	"subsection":"New Cars",
	"headline":"A Chip Off the New Block",
	"summary":"A sharper and faster Z-car emerges for 2009, and it is 
				just as tightly focused, just as much fun and just as 
				weird looking as the more exotic GT-R.",
	"url":"http:\/\/www.nytimes.com\/2009\/02\/22\/
				   automobiles\/autoreviews\/22nissan-z.html",
	"byline":"By EDDIE ALTERMAN",
	"platform":"nyt_cms",
	"id":1194837972408,
	"type":"Article",
	"source":"The New York Times",
	"updated":"2009-02-26 11:59:35",
	"created":"2009-02-26 11:59:35",
	"pubdate":"2009-02-26",
	"subtype":"Review",
	"kicker":"Behind the Wheel | 2009 Nissan 370Z",
	"subheadline":"",
	"terms":"Automobiles;Reviews",
	"organizations":"Nissan Motor Co|NSANY|NASDAQ",
	"people":"",
	"locations":"",
	"indexing_terms":"",
	"related_urls":"",
	"categories_tags":""
	}
*/
	 
function checkNewsItem($item) {
	echo "id: ".$item->id."  ".$item->headline."";
	$item_id = $item->id;
	$url = $item->url;
	$result = mysql_query("SELECT newsitem_id, url FROM newswire_tb WHERE newsitem_id=".$item_id." AND url='".$url."'");
	$numResults = mysql_num_rows($result);
	
	echo "  - num results: ".$numResults." byline: ".$item->byline;
	
	if ($numResults < 1) {
		insertNewsItem( $item );
	}
	echo '<br><br>';
}

function insertNewsItem( $item ) {
	$headline 	= urlencode(stripslashes($item->headline));
	$url 		= $item->url;
	$section 		= $item->section;
	$summary 		= urlencode(stripslashes($item->summary));
	$updatedTime 	= $item->updated;
	$createdTime 	= $item->created;
	$pubDate		= $item->pubdate;
	$id			= $item->id;
	$byline		= $item->byline;
	
	$result = mysql_query( "INSERT INTO newswire_tb (headline, url, section, summary, updatedTime, createdTime, pubDate, newsitem_id, indexable, byline) VALUES ('$headline', '$url', '$section', '$summary', '$updatedTime', '$createdTime', '$pubDate', '$id', '1', '$byline')" );
	
	echo "<br>------------ query result: ".$result."";
}

echo "<br><br><br><br>";

//echo $jsonString;


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

function utf8_urldecode($str) {
	$str = preg_replace("/%u([0-9a-f]{3,4})/i","&#x\\1;",urldecode($str));
	return html_entity_decode($str,null,'UTF-8');;
}

?>