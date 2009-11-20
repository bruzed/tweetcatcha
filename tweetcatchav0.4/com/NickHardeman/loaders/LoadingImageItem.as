﻿package com.NickHardeman.loaders {	import flash.net.URLRequest;	import flash.display.Loader;	import flash.events.Event;	import flash.events.ProgressEvent;	import flash.events.IOErrorEvent;	import flash.events.EventDispatcher;	import flash.utils.getTimer;		public class LoadingImageItem extends EventDispatcher {		public static const IMAGE:String = "LoadingImageItem_Image";		public static const MOVIE:String = "LoadingImageItem_Movie";		// keep track of what or loader is doing //		public var status:String = WAITING;		public var id:String;				public static const LOADING:String = "loading";		public static const WAITING:String = "waiting";		public static const LOADED:String = "loaded";				// for the loading of the content, image files or swfs		private var loader:Loader;		private var url:String;		private var urlReq:URLRequest;		public var disableCache:Boolean = false;		private var stuff:*;		public var _type:String;				// vars to hold the progress of the loader //		public var _percent:Number = 0;		public var _bytesLoaded:Number = 0;		public var _bytesTotal:Number = 1;				public var _timeStarted:int = 0;		public var _timeFinished:int = 0;		public var _timeElapsed:int = 0;				public function LoadingImageItem(id:String, url:String) {			this.id = id;			urlReq = new URLRequest();			this.url = url;			urlReq.url = url;		}				private function init():void {			status = WAITING;						if (url.indexOf("swf")) {				_type = MOVIE;			} else {				_type = IMAGE;			}					}				public function load():void {			if (disableCache) {				if (url.indexOf("?") == -1) {					url += "?killCache="+String(getTimer() + int(Math.random() * 2500));					urlReq.url = url;				}			}			if (loader == null) {				loader = new Loader();			}						loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLIProgressHandler, false, 0, true);			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLICompleteHandler, false, 0, true);			loader.contentLoaderInfo.addEventListener(Event.OPEN, onLIOpenHandler, false, 0, true);			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLIErrorHandler, false, 0, true);			loader.load(urlReq);			_timeStarted = getTimer();			status = LOADING;					}				private function onLIProgressHandler(pe:ProgressEvent):void {			_bytesLoaded = pe.bytesLoaded;			_bytesTotal = pe.bytesTotal;			_percent = _bytesLoaded/_bytesTotal;			_timeElapsed = getTimer() - _timeStarted;			status = LOADING;			if (isNaN(_percent)) {				_percent = 0;			}			dispatchEvent(pe);		}				private function onLICompleteHandler(e:Event):void {			_timeFinished = getTimer();			_timeElapsed = _timeFinished - _timeStarted;			stuff = loader.content;			removeListeners();			killLoader();			status = LOADED;			dispatchEvent(e);		}				private function onLIOpenHandler(e:Event):void {			_timeStarted = getTimer();			dispatchEvent(e);		}				private function onLIErrorHandler(e:IOErrorEvent):void {			dispatchEvent(e);		}				public function removeListeners():void {			if (loader) {				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLIProgressHandler);				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLICompleteHandler);				loader.contentLoaderInfo.removeEventListener(Event.OPEN, onLIOpenHandler);				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLIErrorHandler);			}		}				public function getContent():* {			return stuff;		}				public override function toString():String {			return "LoadingImageItem - Id : "+id+"  Percent : "+_percent+"  Status : "+status;		}				public function destroy():void {			killLoader();			stuff = null;		}				private function killLoader():void {			if (loader) {				try {loader.close();} catch(e:Error) {};				removeListeners();			}			loader = null;		}	}}