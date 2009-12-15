<?php
header("Content-type: text/xml");

error_reporting(E_ALL);
ini_set('display_errors', '1');

include("dbconn.php");

getAvailDates();

function getAvailDates() {
	global $link;
	$dates = array();
	$fullDates = array();
	$result = mysql_query( "SELECT updatedTime FROM newswire_tb ORDER BY updatedTime DESC" );
	
	while( $row = mysql_fetch_assoc( $result ) ) {
		if ( _checkDate($row['updatedTime'], $dates) == 0) {
			$dates[] = _parseDate( $row['updatedTime'] );
			$fullDates[] = $row['updatedTime'];
			//$dates[] = $row['updatedTime'];
		}
		//echo "date: "._parseDate( $row['updatedTime'] )."<br>";
	}
	for ($i = 0; $i < count( $dates ); $i++) {
		//echo 'selected date: '.$dates[$i]."<br>";
	}
	
	mysql_free_result($result);
	mysql_close($link);
	outputXML( $fullDates );
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