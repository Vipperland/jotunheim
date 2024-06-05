package jotun.net;
#if php
	import haxe.io.Bytes;
	import php.Lib;
	import php.NativeArray;
#end
import jotun.net.IDomainData;

/**
 * @author Rafael Moreira
 */

interface IDomain {
  
	public var host:String;
	
	public var port:String;
	
	public var url:Array<String>;
	
	#if js
		
		public var hash:Array<String>;
		
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
	
	public function getDomain(?len:Int = 2):String;
	
	public function paramAsBool(q:String):Bool;
	
	public function paramAsInt(q:String):Int;
	
	public function paramAsFloat(q:String):Float;
	
	public function paramAsArray(q:String, ?split:String = ','):Array<Dynamic>;
	
	public function paramAsObject(q:String):Dynamic;
}