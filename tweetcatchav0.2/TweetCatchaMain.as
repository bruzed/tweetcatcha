﻿package {		import flash.display.MovieClip;		import flash.events.Event;	import flash.events.ProgressEvent;		import flash.net.URLLoader;	import flash.net.URLRequest;		import com.swfjunkie.tweetr.Tweetr;	import com.swfjunkie.tweetr.events.TweetEvent;	import com.swfjunkie.tweetr.data.objects.SearchResultData;		import com.nickhardeman.twitter.SuperTweetSearch;		public class TweetCatchaMain extends MovieClip {		private var _loader				:URLLoader;				private var _headline			:String = "U.S. Declares Public Health Emergency Over Swine Flu";		private var _headlineURL		:String = "http://www.nytimes.com/2009/04/27/world/27flu.html?scp=10&sq=swine%20flu&st=cse";				private var _backTypeKey		:String = "93cf9404dc4d8aebe92f";				public function TweetCatchaMain() {			trace("The root has started loading");			root.loaderInfo.addEventListener(Event.COMPLETE, _onRootLoaded);		}				private function _onRootLoaded($e:Event):void {			trace("The root has loaded");			root.loaderInfo.removeEventListener(Event.COMPLETE, _onRootLoaded);			//_searchHeadline("http://www.nytimes.com/2009/10/30/world/middleeast/30nuke.html?hp");			//_searchHeadline("Iran Said to Reject Key Element of Nuclear Deal");			_searchHeadline("http://www.nytimes.com/2009/11/04/nyregion/04elect.html?hp");			// http://backtweets.com/search.xml?q=http%3A%2F%2Fwww.youtube.com&key=key		}				private function _searchHeadline($key:String):void {			_loader = new URLLoader();			_loader.addEventListener(Event.COMPLETE, _onBackTypeLoaded, false, 0, true);			_loader.load( new URLRequest( "http://backtweets.com/search.xml?q="+$key+"&key="+_backTypeKey ) );						//_loader.load( new URLRequest( "http://api.backtype.com/comments/search.xml?q="+$key+"&key="+_backTypeKey ) );		}				private function _onBackTypeLoaded($e:Event):void {			_loader.removeEventListener(Event.COMPLETE, _onBackTypeLoaded);			trace("These are the results : "+XML($e.target.data).toXMLString());		}																			}}