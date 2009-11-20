﻿/*This class load the xml file and passes it to the newswire class*/package com.tweetcatcha.data {		import flash.display.MovieClip;	import flash.events.*;	import flash.net.URLLoader;	import flash.net.URLRequest;		import com.tweetcatcha.data.Newswire;		import com.tweetcatcha.events.TweetIDEvent;		public class Data extends MovieClip {				//newswire		private var newswire:Newswire;				//news items		private var newsItems:Array = [];				//tweets		private var tweets:Array = [];				//fire loaded event when news items are loaded		public static const NEWS_ITEMS_LOADED	:String = "newsItemsLoaded";				//stiff for loading the xml data		//private var loader:URLLoader = new URLLoader();		private var loader:URLLoader;		private var xml:XML;		private const XML_URL:String = "day1.xml";		//track the number of the items to load		public static var totalItems:int;		public static var itemsLoaded:int;				//constructor		public function Data() {		}				//initialize loading the data		public function init():void {			//loader.load(new URLRequest(XML_URL));			var loader = new URLLoader();			loader.load(new URLRequest(XML_URL));			loader.addEventListener(Event.COMPLETE, _onXMLLoaded, false, 0, true);			loader.addEventListener(IOErrorEvent.IO_ERROR, _onIOErrorEvent, false, 0, true);		}				//on xml loaded		public function _onXMLLoaded($e:Event):void {			//trace($e.target.data);			xml = new XML($e.target.data);			//set the total items			totalItems = xml.totalitems;			trace("ID:" + itemsLoaded + xml.news_item.headline);			//trace(totalItems);			//send the data to the newswire class			//newswire = new Newswire(xml);			newswire = new Newswire(xml);			newswire.addEventListener(Newswire.LOADED, _newsItemsLoaded, false, 0, true);			newswire.addEventListener(TweetIDEvent.TWEETID, _onTweetsLoadedForId, false, 0, true);			newswire.load();		}				//on IO error		public function  _onIOErrorEvent($e:Event):void {			//trace($e.target.data);			trace("DATA IO ERROR::Couldn't load the XML file " + XML_URL);		}						private function _onTweetsLoadedForId($e:TweetIDEvent):void {			trace("another something?" + $e.getID);			dispatchEvent( $e );		}				//newitems loaded		public function _newsItemsLoaded($e:Event):void {			//trace("news loaded");			newsItems = newswire.getNewsItems;			newswire.removeEventListener(Newswire.LOADED, _newsItemsLoaded);			//trace(newsItems);			dispatchEvent( new Event(NEWS_ITEMS_LOADED) );			//if all the items are not loaded yet then increment and load again			//increment the items loaded			itemsLoaded++;			if (itemsLoaded < totalItems) {				//trace("all items not loaded yet" + itemsLoaded);				//crash flash				init();			}		}				//return all the news items		public function get getNewsItems():Array {			return newsItems;		}							}}