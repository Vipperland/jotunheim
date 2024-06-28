package jotun.net;
#if php
	import haxe.io.Bytes;
	import php.Lib;
	import php.NativeArray;
#end
import jotun.gaming.dataform.Pulsar;
import jotun.net.DataSource;
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
		
		public var server:IDomainData;
		
		public var input:DataSource;
		
		public var pulsar:Pulsar;
		
		public var domain:String;
		
		public var client:String;
		
		public function parseFiles( onPart : String -> String -> Void, onData : Bytes -> Int -> Int -> Void ) : Void ;
		
	#end
	
	public var file:String;
	
	#if js
		
		public function reload (?force:Bool = false):Void;
		
		public function location():String;
		
	#elseif php
		
		public function getRequestMethod():String;
		
		public function isRequestMethod(q:String):Bool;
		
		public function getInput():String;
		
	#end
	
	public function getDomain(?len:Int = 2):String;
	
}