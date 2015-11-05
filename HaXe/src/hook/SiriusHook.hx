package hook;


/**
 * ...
 * @author Rafael Moreira
 */

@:native('Sirius')
extern public class SiriusHook {
	
	/// Global resource loader
	static public var resources:Dynamic;
	
	/// Domain information
	static public var domain:Dynamic;
	
	/// Debug tools
	static public var logger:Dynamic;
	
	/// Resource loader
	static public var loader:Dynamic;
	
	#if js
		
		/// Main Document
		static public var document:Dynamic;
		
		/// Browser information
		static public var agent:Dynamic;
		
		/// SEO Tools
		static public var seo:Dynamic;
		
		/// External Plugins
		static public var plugins:Dynamic;
		
		static public function updatePlugins():Void;
		
		static public function one(?q:String = "*", ?t:Dynamic = null, ?h:Dynamic->Void = null):DisplayHook;
		
		static public function all(?q:String = "*", ?t:Dynamic = null, ?h:Dynamic->Void = null):TableHook;
		
		static public function run(handler:Dynamic):Void;
		
		static public function onInit(handler:Dynamic->Void, ?files:Array<String> = null):Void;
		
		static public function addScript(url:Dynamic, ?handler:Null<Void>->Void):Void;
		
	#elseif php
		
		public static var header:Dynamic;
		
		public static var gate:Dynamic;
		
		static public var loader:Dynamic;
		
	#end
	
	static public function module(file:String, #if js ?target:Dynamic, #end ?content:Dynamic, ?handler:String->String->Void):Void;
	
	static public function request(url:String, ?data:Dynamic, ?handler:Dynamic->Void, method:String = 'post'):Void;
	
	static public function log(q:Dynamic, type:UInt = -1):Void;
	
}