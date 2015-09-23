package sirius.data;

/**
 * @author Rafael Moreira
 */

interface IDataCache {
	
	public function json (?print:Bool) : String;
	
	public function refresh () : IDataCache;

	public function clear (?p:String) : IDataCache;

	public function set (p:String, v:Dynamic) : IDataCache;

	public function get (?id:String) : Dynamic;

	public function exists (?name:String) : Bool;

	public function save () : IDataCache;

	public function load () : IDataCache;

	public function getData () : Dynamic;
	
}