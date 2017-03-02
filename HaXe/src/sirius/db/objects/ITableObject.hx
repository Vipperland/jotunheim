package sirius.db.objects;

/**
 * @author Rafael Moreira
 */
interface ITableObject {
	
	public var data : Dynamic;

	public var id(get, null):UInt;

	public function create (data:Dynamic) : TableObject;

	public function update (data:Dynamic) : Void;

	public function copy () : TableObject;

	public function delete () : Void;
	
}