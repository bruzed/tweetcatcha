﻿package com.nickhardeman.twitter {		import flash.events.EventDispatcher;	import flash.events.Event;	import flash.events.ProgressEvent;		import flash.net.URLLoader;	import flash.net.URLRequest;		import flash.utils.Dictionary;		import com.swfjunkie.tweetr.Tweetr;	import com.swfjunkie.tweetr.events.TweetEvent;	import com.swfjunkie.tweetr.data.objects.SearchResultData;		public class SuperTweetSearch extends EventDispatcher {		private var _loader				:URLLoader;				private var _tweetr				:Tweetr;		private var _tweetrs			:Vector.<Tweetr>;				//private var _tweets				:Vector.<SearchResultData> = new Vector.<SearchResultData>();		private var _tweets				:Dictionary = new Dictionary( true );				private var _bitlyUn		:String = "";		private var _bitlyAPIKey	:String = "";		private var _bitlyHash		:String = "";				private var _headlineURL	:String = "";						public function setBitlyInfo($un:String, $apiKey:String):void {			_bitlyUn = $un;			_bitlyAPIKey = $apiKey;		}				public function setHeadlineURL($str:String):void {			_headlineURL = $str;		}				public function search( $param:String, $headlineURL:String = "" ):void {						if ($headlineURL != "")				_headlineURL = $headlineURL;						_loader = new URLLoader();			_loader.addEventListener(Event.COMPLETE, _onBitlyHashLoaded, false, 0, true);			_loader.load(new URLRequest("http://api.bit.ly/shorten?version=2.0.1&longUrl="+_headlineURL+"&login="+_bitlyUn+"&apiKey="+_bitlyAPIKey+"&format=xml"));		}				private function _onBitlyHashLoaded($e:Event):void {			_loader.removeEventListener(Event.COMPLETE, _onBitlyHashLoaded);			_loader = null;			_bitlyHash = XML($e.target.data)..hash;			trace("SuperTweetSearch :: _onBitlyHashLoaded : hash is "+$e.target.data);			_searchWithHash();		}				private function _searchWithHash() {			cleanTweetr();			_tweets = new Dictionary( true );						_tweetr = new Tweetr();			_tweetr.addEventListener(TweetEvent.COMPLETE, _onTweetsHeadlinesLoaded, false, 0, true);			_tweetr.addEventListener(TweetEvent.FAILED, _onTweetLoadFailBlog, false, 0, true);			_tweetr.search( "http://bit.ly/"+_bitlyHash );		}				private function _onTweetsHeadlinesLoaded($e:TweetEvent):void {						cleanTweetr();			_parseResponseEvent($e);			trace("SuperTweetSearch :: _onTweetsHeadlinesLoaded : headline as search complete numTweets = "+numTweets);			_loadHeadlineUrlTweets();		}				private function _loadHeadlineUrlTweets():void {			cleanTweetr();						_tweetr = new Tweetr();			_tweetr.addEventListener(TweetEvent.COMPLETE, _onTweetsHeadlineUrlLoaded, false, 0, true);			_tweetr.search( _headlineURL );		}				private function _onTweetsHeadlineUrlLoaded($e:TweetEvent):void {						cleanTweetr();			_parseResponseEvent($e);			trace("SuperTweetSearch :: _onTweetsHeadlineUrlLoaded : url as search for headline complete numTweets = "+numTweets);			_searchWithBitlys();		}				private function _searchWithBitlys():void {			_tweetrs = new Vector.<Tweetr>();			var bitlys:Dictionary = new Dictionary( true );			for (var key in _tweets) {				//trace("SuperTweetSearch : _searchWithBitlys : "+key+" : "+_tweets[key].text); 				var _content:String = _tweets[key].text;				if (_content.indexOf("http://bit.ly") > -1) {					var bitlyURL:String = getBitlySearchString(_content.slice( _content.indexOf("http://bit.ly"), _content.length));					//trace( bitlyURL+"-");					if (!bitlys[bitlyURL]) {						var tweetster:Tweetr = new Tweetr();						tweetster.addEventListener(TweetEvent.COMPLETE, _onBitlySearchLoaded, false, 0, true);						_tweetrs.push( tweetster );						tweetster.search( bitlyURL );					}				}			}			if (_tweetrs.length == 0) {				_onBitlySearchComplete();			}		}				private function _onBitlySearchLoaded($e:TweetEvent):void {			$e.currentTarget.removeEventListener(TweetEvent.COMPLETE, _onBitlySearchLoaded);			_parseResponseEvent($e);			for (var i:int = 0; i < _tweetrs.length; i++) {				if (Tweetr(_tweetrs[i]) == Tweetr($e.currentTarget)) {					_tweetrs.splice(i, 1);				}			}			if(_tweetrs.length == 0) {				_onBitlySearchComplete();			}		}				private function _onBitlySearchComplete():void {			trace("SuperTweetSearch :: _onBitlySearchComplete : all Bitlys have been searched numTweets = "+numTweets);			for (var key in _tweets) {				trace(_tweets[key].text);			}		}				private function getBitlySearchString($origString:String):String {			if ($origString.indexOf(" ") > -1) {				return $origString.slice( 0, $origString.indexOf(" ") );			}			if ($origString.indexOf(")") > -1) {				return $origString.slice( 0, $origString.indexOf(")") );			}			return $origString;		}				private function _onTweetLoadFailBlog($e:TweetEvent):void {			trace("SuperTweetSearch :: _onTweetLoadFailBlog : There has been a problem with the tweets");					}				private function _parseResponseEvent($e:TweetEvent):void {			for (var i:int = 0; i < $e.responseArray.length; i++) {				//trace("Tweet: "+$e.responseArray[i].text);				if (!_tweets[$e.responseArray[i].id])					_tweets[$e.responseArray[i].id] = $e.responseArray[i];			}					}				private function cleanTweetr():void {			if (_tweetr) {				_tweetr.removeEventListener(TweetEvent.COMPLETE, _onTweetsHeadlinesLoaded);				_tweetr.destroy();			}		}				public function destroy():void {			cleanTweetr();			if (_tweetr) _tweetr.removeEventListener(TweetEvent.FAILED, _onTweetLoadFailBlog);		}				public function get numTweets():int {			var num:int = 0;			for (var key in _tweets) {				num += 1;			}			return num;		}				}		}