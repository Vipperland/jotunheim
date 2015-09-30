package sirius.net;
import sirius.net.IDomainData;
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
		
		public var data:IDomainData;
		
		public var server:String;
		
		public var client:String;
		
	#end
	
	public var firstFragment : String;
	
	public var lastFragment : String;
	
	public var file:String;
	
	public var params:Dynamic;

	public function fragment (i:Int, ?a:String) : String;

	#if js
		
		public function reload (?force:Bool = false) : Void;
		
	#elseif php
		
		public function require(params:Array<String>) : Bool;
		
	#end
	
}