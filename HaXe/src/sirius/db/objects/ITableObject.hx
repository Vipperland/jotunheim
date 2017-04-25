package sirius.db.objects;

/**
 * @author Rafael Moreira
 */
interface ITableObject {
	
	/**
	 * Current object properties in database
	 */
	public var data : Dynamic;
	
	/**
	 * The unique and auto increment identifier
	 */
	public var id(get, null) : UInt;
	
	/**
	 * Create a new object specified by data
	 * @param	data
	 * @param	verify
	 * @return
	 */
	public function create (data:Dynamic, ?verify:Bool=false) : ITableObject;
	
	/**
	 * Update current object with new values
	 * @param	data
	 * @param	verify
	 */
	public function update (data:Dynamic, ?verify:Bool=false) : Void;
	
	/**
	 * Copy current data to a new object
	 * @return
	 */
	public function copy () : ITableObject;
	
	/**
	 * Delete current object from database
	 */
	public function delete () : Void;
	
}