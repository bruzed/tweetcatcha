<?php
header("Content-type: text/xml");

error_reporting(E_ALL);
ini_set('display_errors', '1');

include("dbconn.php");

$limit = 0;
$offset = 0;
$getTotal = 1;
$date = "2009-11-18";
$minTweets = 1;

if (isset($_GET['limit'])) $limit = $_GET['limit'];
if (isset($_GET['offset'])) $offset = $_GET['offset'];
if (isset($_GET['getTotal'])) $getTotal = $_GET['getTotal'];
if (isset($_GET['date'])) $date = $_GET['date'];
if (isset($_GET['minTweets'])) $minTweets = $_GET['minTweets'];

//DATE('2003-12-31 01:02:03')
//2009-11-13 02:33:24

//WHERE date >= ‘2005-01-07’ AND date < ‘2005-01-07’ + INTERVAL 24 HOUR;

$doc = new DomDocument('1.0');
$root = $doc->createElement('results');
$root = $doc->appendChild($root);


$limitString = '';
if ($limit > 0) {
	$limitString .= "LIMIT ".$offset.", ".$limit;
}
$result = mysql_query("SELECT * FROM newswire_tb WHERE (createdTime >= '".$date."' AND createdTime < '".$date."' + INTERVAL 24 HOUR) ORDER BY createdTime ASC ".$limitString);
$totalNewsitems = 0;

while( $row = mysql_fetch_assoc( $result ) ) {
	//echo $row['updatedTime'];
	$newsNode = $doc->createElement('news_item');
	//$root->appendChild( $newsNode );
	appendNewsNodeItems( $newsNode, $row );
	$tweetNode = $doc->createElement('tweets');
	$newsNode->appendChild( $tweetNode );
	$totalTweets = getTweets($row, $tweetNode);
	
	if ($totalTweets >= $minTweets) {
		$root->appendChild( $newsNode );
		$totalNewsitems += 1;
	}
}
appendAttribute($doc, $root, 'totalNewsItems', strval($totalNewsitems) );
echo $xml_string = $doc->saveXML();

////////////////////////////////////////////////////////////////////////////////////

function getTweets($newsitem, $parentNode) {
	global $doc, $root, $minTweets;
	$newsitem_id = $newsitem["id"];
	$newsitem_time = strtotime($newsitem['createdTime']);
	
	$result = mysql_query("SELECT * FROM backtweets_db WHERE newswire_id=".$newsitem_id." ORDER BY tweet_id ASC");
	
	$totalTweets  = mysql_num_rows($result);
		
	if ($totalTweets >= $minTweets) {
		appendAttribute($doc, $parentNode, 'total', $totalTweets);
		while( $row = mysql_fetch_assoc( $result ) ) {
			$tweet = addTweet($row, $parentNode);
			$tweetTime = strtotime($row['tweet_created_at']);
			
			$hours = floor( ($tweetTime - $newsitem_time ) / (60 * 60) );
			$minutes = (($tweetTime - $newsitem_time ) / 60) % 60;
			
			appendAttribute($doc, $tweet, 'hourDiff', $hours);
			appendAttribute($doc, $tweet, 'minDiff', $minutes);
		}
	}
	
	return $totalTweets;
}

function addTweet($tweetitem, $parentNode) {
	global $doc;
	$entry = appendElement($doc, $parentNode, 'tweet');
	foreach ($tweetitem as $key => $value) {
		$node = appendElement($doc, $entry, $key);
		appendTextNode($doc, $node, $value);
	}
	return $entry;
}

function appendNewsNodeItems( $newsNode, $newsitem ) {
	global $doc, $root;
	appendAttribute($doc, $newsNode, 'url', $newsitem['url']);
	appendAttribute($doc, $newsNode, 'id', $newsitem['id']);
	
	$sectionNode = appendElement($doc, $newsNode, 'section');
	appendTextNode($doc, $sectionNode, ($newsitem['section']));
	
	$headlineNode = appendElement($doc, $newsNode, 'headline');
	appendTextNode($doc, $headlineNode, urldecode($newsitem['headline']));
	
	$summaryNode = appendElement($doc, $newsNode, 'summary');
	appendTextNode($doc, $summaryNode, urldecode($newsitem['summary']));
	
	$byNode = appendElement($doc, $newsNode, 'byline');
	appendTextNode($doc, $byNode, ($newsitem['byline']));
	
	$updatedNode = appendElement($doc, $newsNode, 'updatedTime');
	appendTextNode($doc, $updatedNode, ($newsitem['updatedTime']));
	
	$createdNode = appendElement($doc, $newsNode, 'createdTime');
	appendTextNode($doc, $createdNode, ($newsitem['createdTime']));
	
	$pubNode = appendElement($doc, $newsNode, 'pubDate');
	appendTextNode($doc, $pubNode, ($newsitem['pubDate']));
}

function appendElement($doc, $parentNode, $nodeName) {
	$node = $doc->createElement($nodeName);
	$parentNode->appendChild($node);
	return $node;
}

function appendTextNode($doc, $parentNode, $value) {
	$parentNode->appendChild( $doc->createTextNode( $value ) );
}

function appendAttribute($doc, $node, $attName, $attVal) {
	// create attribute node
	$att = $doc->createAttribute( $attName );
	$node->appendChild( $att );
	
	// create attribute value node
	$val = $doc->createTextNode( $attVal );
	$att->appendChild( $val );
}


?>