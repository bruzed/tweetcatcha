<?php
header("Content-type: text/xml");

error_reporting(E_ALL);
ini_set('display_errors', '1');

include("dbconn.php");

if (isset($_GET['offset'])) $offset 	= stripslashes(strip_tags( $_GET['offset'] ));
if (isset($_GET['limit'])) $limit 	= stripslashes(strip_tags( $_GET['limit'] ));

getAvailDates();

function getAvailDates() {
	global $link, $limit, $offset;
	$dates = array();
	$fullDates = array();
	$tweetTotals = array();
	$result = mysql_query( "SELECT updatedTime FROM newswire_tb ORDER BY updatedTime DESC" );
	
	while( $row = mysql_fetch_assoc( $result ) ) {
		if ( _checkDate($row['updatedTime'], $dates) == 0) {
			$dates[] = _parseDate( $row['updatedTime'] );
			$fullDates[] = $row['updatedTime'];
		}
	}
	
	//mysql_free_result($result);
	//mysql_close($link);
	//echo 'working on it';
	getTotals( $fullDates );
}

function getTotals($dates) {
	global $link;
	
	$totalTweetsAllTime = 0;
	$totalHeadlinesAllTime = 0;
	
	//$result = mysql_query( "SELECT totalTweets, updatedTime FROM newswire_tb WHERE updatedTime=''" );
	//echo 'gettin the totals';
	$doc = new DomDocument('1.0');
	$root = $doc->createElement('root');
	$root = $doc->appendChild($root);
	
	$totalDates = count($dates);
	
	for ($i = 0; $i < $totalDates; $i++) {
		$date_node = $doc->createElement('date');
		$date_node = $root->appendChild($date_node);
		
		$date = _parseDate( $dates[$i]);
		
		//appendAttribute($doc, $date_node, "full", $dates[$i] );
		appendAttribute($doc, $date_node, "date", $date );
							  
		$result = mysql_query("SELECT * FROM newswire_tb WHERE (createdTime >= '".$date."' AND createdTime < '".$date."' + INTERVAL 24 HOUR)");
		$totalTweets = 0;
		while( $row = mysql_fetch_assoc( $result ) ) {
			$totalTweets = $totalTweets + $row['totalTweets'];
			//echo "total is ".$row['totalTweets'];
		}
		$totalHeadlines = mysql_num_rows($result);
		$totalTweetsAllTime = $totalTweetsAllTime + $totalTweets;
		$totalHeadlinesAllTime = $totalHeadlinesAllTime + $totalHeadlines;
		
		appendAttribute($doc, $date_node, "totalNewsItems", $totalHeadlines );
		appendAttribute($doc, $date_node, "totalTweets", $totalTweets );
	
		//mysql_free_result($result);
	}
	appendAttribute($doc, $root, "averageTweetsADay", ceil($totalTweetsAllTime / $totalDates) );
	appendAttribute($doc, $root, "averageHeadlinesADay", ceil($totalHeadlinesAllTime / $totalDates) );
	
	$xml_string = $doc->saveXML();
	echo "$xml_string";
	
	mysql_close($link);
	
}

function _checkDate( $date, $dates ) {
	
	for ($i = 0; $i < count( $dates ); $i++) {
		if ( $dates[$i] == _parseDate( $date ) ) {
			return 1;
		}
	}
	return 0;
}

function _parseDate( $date ) {
	$temp = explode(" ", $date);
	return $temp[0];
}

function outputXML( $dates ) {
	$doc = new DomDocument('1.0');
	$root = $doc->createElement('root');
	$root = $doc->appendChild($root);
	
	for ($i = 0; $i < count( $dates ); $i++) {
		$date_node = $doc->createElement('date');
		$date_node = $root->appendChild($date_node);
		
		appendAttribute($doc, $date_node, "full", $dates[$i] );
		appendAttribute($doc, $date_node, "date",_parseDate( $dates[$i] ) );
	}
	
	$xml_string = $doc->saveXML();
	echo "$xml_string";
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