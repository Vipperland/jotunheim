package jotun.idb;
import js.Syntax;
import js.html.DOMError;
import js.html.Event;
import js.html.idb.Database;
import js.html.idb.ObjectStore;
import js.html.idb.Request;

/**
 * ...
 * @author ...
 */
class WebDBTable {
	
	private var _db:Database;
	
	private var _name:String;
	
	private var _table:ObjectStore;
	
	private var _error:DOMError;
	
	private var _result:Dynamic;
	
	private function _request_io(r:Request, handler:WebDBTable->Void):Request {
		if(handler != null){
			r.onsuccess = function(e:Event){
				_result = (cast e.target).result;
				handler(this);
			}
			r.onerror = function(e:Event){
				_error = cast r.error;
				handler(this);
			}
		}
		return r;
	}
	
	public function new(name:String, db:Database, store:ObjectStore) {
		_db = db;
		_name = name;
		_table = store;
	}
	
	public function destroy():Void {
		_db.deleteObjectStore(_name);
	}
	
	/**
	 * 
	 * @param	key
	 * @param	path
	 * @param	props unique:bool,multiEntry:bool,locale
	 */
	public function addIndex(key:String, path:Dynamic, ?props:Dynamic):Void {
		_table.createIndex(key, path, props);
	}
	
	public function deleteIndex(?key:Dynamic):Void {
		_table.deleteIndex(key);
	}
	
	public function index(?key:Dynamic):Void {
		_table.index(key);
	}
	
	public function count(?key:Dynamic, ?handler:WebDBTable-> Void):Request {
		_error = null;
		return _request_io(_table.count(key), handler);
	}
	
	public function clear(?handler:WebDBTable-> Void):Request {
		_error = null;
		return _request_io(_table.clear(), handler);
	}
	
	public function delete(?key:Dynamic, ?handler:WebDBTable-> Void):Request {
		_error = null;
		return _request_io(_table.delete(key), handler);
	}
	
	public function add(data:Dynamic, ?key:Dynamic, ?handler:WebDBTable-> Void):Request {
		_error = null;
		return _request_io(_table.add(data, key), handler);
	}
	
	public function put(data:Dynamic, ?key:Dynamic, ?handler:WebDBTable-> Void):Request {
		_error = null;
		return _request_io(_table.put(data, key), handler);
	}
	
	public function get(key:Dynamic, ?handler:WebDBTable-> Void):Request {
		_error = null;
		return _request_io(_table.get(key), handler);
	}
	
	public function getAll(?key:Dynamic, ?limit:Int, ?handler:WebDBTable-> Void):Request {
		_error = null;
		return _request_io(_table.getAll(key, limit), handler);
	}
	
	public function getAllKeys(?key:Dynamic, ?limit:Int, ?handler:WebDBTable-> Void):Request {
		_error = null;
		return _request_io(_table.getAllKeys(key, limit), handler);
	}
	
	public function openCursor(?key:Dynamic, ?direction:Dynamic, ?handler:WebDBTable-> Void):Request {
		_error = null;
		return _request_io(_table.openCursor(key, direction), handler);
	}
	
	public function openKeyCursor(?key:Dynamic, ?direction:Dynamic, ?handler:WebDBTable-> Void):Request {
		_error = null;
		return _request_io(_table.openKeyCursor(key, direction), handler);
	}
	
	public function each(handler:Dynamic->Bool):Request {
		_error = null;
		return _request_io(_table.openCursor(), function(h:WebDBTable):Void{
			/**
				let key = _result.primaryKey;
				let value = _result.value;
				_result.continue();
			 */
			handler(_result);
		});
	}
	
	public function isSuccess():Bool {
		return _error == null;
	}
	
	public function getResult():Dynamic {
		return _result;
	}
	
	//public function callNext():Void {
		//if (_result != null){
			//Syntax.code('{0}.continue();', _result);
		//}
	//}
	
}