package jotun.data;

/**
 * @author Rafael Moreira
 */

interface IDataCache {
	
	/**
	 * All data access
	 * @return
	 */	
	public var data(get_data, null):Dynamic;
	
	/**
	 * Convert data to JSON
	 * @param	print
	 * @return
	 */
	public function json (?print:Bool) : String;
	
	/**
	 * Convert data to JSON+Base64 encoded
	 * @param	print
	 * @return
	 */
	public function base64 (?print:Bool) : String;
	
	/**
	 * Update object active time
	 * @return
	 */
	public function refresh () : IDataCache;
	
	/**
	 * Clear a property or all data
	 * @param	p
	 * @return
	 */
	public function clear (?p:String) : IDataCache;
	
	/**
	 * Set a property value
	 */
	public function set (p:String, v:Dynamic) : IDataCache;
	
	/**
	 * Get a property value
	 */
	public function get (?id:String) : Dynamic;
	
	/**
	 * Check if a property exists
	 * @param	name
	 * @return
	 */
	public function exists (?name:String) : Bool;

	/**
	 * Write data to disk or cookie based on a environment
	 * @param	base64
	 * @return
	 */
	public function save () : IDataCache;
	
	/**
	 * Load data from disk or cookie based on a environment
	 * @return
	 */
	public function load():Bool;
	
}