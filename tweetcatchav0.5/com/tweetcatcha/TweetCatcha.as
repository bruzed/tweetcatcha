﻿package com.tweetcatcha {		import flash.display.MovieClip;	import flash.events.*;		import com.tweetcatcha.data.Data;	import com.tweetcatcha.data.Constants;	//import com.tweetcatcha.nav.MainNav;	import com.tweetcatcha.visual.Dreamweaver;		import com.tweetcatcha.events.TweetIDEvent;	import com.reintroducing.events.CustomEvent;		public class TweetCatcha extends MovieClip {				//object to load all the data		private var theData:Data;		//object to hold all news items		private var newsItems:Array = [];				private var DW				:Dreamweaver;		//private var MN				:MainNav = new MainNav();				//constructor		public function TweetCatcha() {			//get it up and running			theData = new Data();			theData.init();						DW = new Dreamweaver();			DW.mc = dreamweaver_mc;			//MN.mc = mainMenuHolda_mc;						theData.addEventListener(Data.NEWS_ITEMS_LOADED, getNewsItems, false, 0, true);			//theData.addEventListener(TweetIDEvent.TWEETID, _onTweetsLoadedForId, false, 0, true);		}				//get the news items once the data is loaded		public function getNewsItems($e:Event):void {			//theData.removeEventListener(Data.NEWS_ITEMS_LOADED, getNewsItems);			//get the news items			newsItems = theData.getNewsItems;			//trace(newsItems[0].tweets[0].user);									Constants.createSections(newsItems);			for (var i:int = 0; i < Constants.sections.length; i++) {				//trace("Main :: getNewsItems : section " +Constants.sections[i]);			}						//create a new dreamweaver object			//trace("create a new object");			//var DW = new Dreamweaver();			//DW.mc = dreamweaver_mc;						DW.onStageResize(stage.stageWidth, stage.stageHeight);			DW.setData(theData);			DW.setup();						DW.addEventListener(Constants.HEADLINE_ID_SELECTED, _onHeadlineSelected, false, 0, true);						//_onHeadlineClick(5);						//MN.setup(newsItems);			//MN.onStageResize(stage.stageWidth, stage.stageHeight);			//MN.addEventListener(Constants.HEADLINE_ID_SELECTED, _onHeadlineSelected, false, 0, true);						//stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove, false, 0, true);			//MN.animateOut();		}				public function _onTweetsLoadedForId($e:TweetIDEvent):void {			trace("when does it come here" + $e.getID);			//DW.onTweetsLoaded($e.getID);		}			public function _onHeadlineSelected($e:CustomEvent = null):void {			_onHeadlineClick( $e.params.ID );		}				public function _onHeadlineClick( $id:int ):void {			DW.headlineSelected( $id );		}				private function _onStageResize( $e:Event ):void {			DW.onStageResize($e.target.stageWidth, $e.target.stageHeight);			//MN.onStageResize($e.target.stageWidth, $e.target.stageHeight);		}				/*private function _onMouseMove($e:MouseEvent):void {			MN.checkMouse( mouseY );		}*/							}}