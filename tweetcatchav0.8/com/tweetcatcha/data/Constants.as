﻿package com.tweetcatcha.data {	import com.tweetcatcha.data.objects.NewsItem;		public class Constants {				public static const ANIMATE_IN_COMPLETE		:String = "animateInComplete";		public static const ANIMATE_OUT_COMPLETE	:String = "animateOutComplete";				public static const HEADLINE_ID_SELECTED	:String = "headlineIDSelected";		public static const ZOOM_IN_CLICK			:String = "zoomInClicked";		public static const ZOOM_OUT_CLICK			:String = "zoomOutClicked";				public static const CONFIGURE_CIRCLES		:String = "timeToOrganizeCircles";				public static const COLORS					:Array = new Array(0x9edeae, 0x6ebeb1, 0x4784ba, 0x579da7, 0x76c3cd, 0xade0e4, 																	   0x632c25, 0xbcc0b2, 0xe5ff1f, 0x60a632, 0x1e4f61, 0x43566b,																	   0x68a8a8, 0x97a12d, 0x00b4cc, 0xcfae2c, 0x2ccf88, 0xcf902c,																	   0xe2e75b, 0x59b111, 0xcf652c, 0x07d296, 0xf9df76, 0x76f9d3,																	   0xebf976);		public static  var _sections				:Array = new Array();				public static function createSections( $newsItems:Array ):void {			for (var j:Number = 0; j < $newsItems.length; j++) {				var _addSection:Boolean = true;				for (var i:int = 0; i < _sections.length; i++) {					if (_sections[i] == $newsItems[j].section) {						_addSection = false;						break;					}				}				if (_addSection) _sections.push($newsItems[j].section);			}		}				public static function getColorForSection( $s:String ):uint {			for (var i:int = 0; i < _sections.length; i++) {				if (_sections[i] == $s) {					return COLORS[i];				}			}			return 0x00fff0;		}				public static function get sections():Array {			return _sections;		}				// date format 2009-11-31 22:22:02 //		public static function parseDate($date:String = ""):Object {			var obj:Object = new Object();			if ($date != "") {				var dArr:Array = $date.split(" ");				var dateArr:Array = String(dArr[0]).split("-");				var timeArr:Array = String(dArr[1]).split(":");				 				obj.hour = int(timeArr[0]);				obj.minute = int(timeArr[1]);				obj.second = int(timeArr[2]);								obj.month = int(dateArr[1]);				obj.day = int(dateArr[2]);				obj.year = int(dateArr[0]);			}						return obj;		}	}	}