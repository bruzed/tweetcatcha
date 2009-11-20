﻿package com.tweetcatcha.visual {	import flash.display.MovieClip;	import flash.events.Event;	import flash.geom.Point;	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.Shape;		import com.gskinner.utils.Rndm;		import com.tweetcatcha.data.objects.Tweet;		import com.caurina.transitions.*;		public class TweetManager {				private var _mc			:MovieClip;		public var _tweets		:Vector.<TweetClip>;		private var point		:Point;		private var xPos		:Number = 10;		private var yPos		:Number = 0;		private var line		:Bitmap;		private var lineBmd		:BitmapData;		private var stageWidth	:int;		private var stageHeight	:int;		private var shape		:Shape = new Shape();				Rndm.seed = 10;				public function setup( ):void {			_tweets = new Vector.<TweetClip>();			stageWidth = _mc.parent.stage.stageWidth;			stageHeight = _mc.parent.stage.stageHeight;		}				public function addTweet($tarX:Number, $tarY:Number, $t:Tweet):void {			var tc:TweetClip = new TweetClip();			//tc.x = 0;			//tc.y = 0;			tc.x = $tarX + 10;			tc.y = $tarY + Rndm.integer(-50, 50);			//trace("tc.x:" + tc.x + "tc.y" + tc.y);			_tweets.push( tc );			_mc.addChild(tc);			drawTweet(tc);			//Tweener.addTween(tc, {x:$tarX, y:$tarY, time:1, transition:"easeOutCubic"});		}				public function drawTweet(tc:TweetClip):void {			var lineBmd = new BitmapData(stageWidth, stageHeight, true, 0x00FFFFFF);			/*for ( var i:int = 0; i < tc.x; i++) {				var point = new Point(i, 50 + tc.y);				lineBmd.setPixel32(point.x, point.y, 0xFFFFFFFF);			}*/						/*shape.graphics.lineStyle(1, 0xFFFFFF, 0.3);			shape.graphics.moveTo(200 , 100);			shape.graphics.curveTo(Rndm.integer(100, 200), Rndm.integer(-50, 200), tc.x, 100 + tc.y);						lineBmd.draw(shape);			shape.graphics.clear();						line = new Bitmap(lineBmd);			line.y = -100;			//line.alpha = .3;			_mc.addChild(line);			*/					}				public function set mc($mc:MovieClip):void {			_mc = $mc;		}	}}