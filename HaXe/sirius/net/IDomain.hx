package sirius.net;
import sirius.data.IDataCache;

/**
 * @author Rafael Moreira
 */

interface IDomain {
  
	public var host : String;
	
	public var port : String;
	
	public var fragments : Array<String>;
	
	#if js
		
		public var hash:String;
		
	#elseif php
		
		public var server:String;
		
		public var client:String;
		
	#end
	
	public var firstFragment : String;
	
	public var lastFragment : String;
	
	public var directory : String;
	
	public var extension : String;
	
	public var params:Dynamic;

	public function fragment (i:Int, ?a:String) : String;

	#if js
		
		public function reload (?force:Bool = false) : Void;
		
	#end
	
}