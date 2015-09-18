package sirius.data;

/**
 * @author Rafael Moreira
 */

interface IDataCache {
	
	#if js
		public function json () : String;
	#elseif php
		public function json (?print:Bool) : String;
	#end
	
	public function refresh () : IDataCache;

	public function clear (?p:String) : IDataCache;

	public function set (p:String, v:Dynamic) : IDataCache;

	public function get (?id:String) : Dynamic;

	public function exists (name:String) : Bool;

	public function save () : IDataCache;

	public function load () : IDataCache;

	public function getData () : Dynamic;

	public function base64 () : String;

	public function isExpired () : Bool;
	
}