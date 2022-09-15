package jotun.net;
#if php
	import haxe.io.Bytes;
	import php.Lib;
	import php.NativeArray;
#end
import jotun.data.IDataCache;
import jotun.data.IFragments;
import jotun.net.IDomainData;

/**
 * @author Rafael Moreira
 */

interface IDomain {
  
	public var host:String;
	
	public var port:String;
	
	public var url:IFragments;
	
	#if js
		
		public var hash:IFragments;
		
	#elseif php
		
		public var data:IDomainData;
		
		public var input:Dynamic;
		
		public var server:String;
		
		public var client:String;
		
		public function parseFiles( onPart : String -> String -> Void, onData : Bytes -> Int -> Int -> Void ) : Void ;
		
	#end
	
	public var file:String;
	
	public var params:Dynamic;

	#if js
		
		public function reload (?force:Bool = false):Void;
		
		public function location():String;
		
	#elseif php
		
		public function require(params:Array<String>):Bool;
		
		public function getRequestMethod():String;
		
		public function isRequestMethod(q:String):Bool;
		
		public function getInput():String;
		
	#end
	
	public function getFQDN(?len:Int = 2):String;
	
}