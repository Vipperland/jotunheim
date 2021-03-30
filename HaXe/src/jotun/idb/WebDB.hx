package jotun.idb;
import jotun.utils.Dice;
import js.Browser;
import js.html.DOMError;
import js.html.Event;
import js.html.idb.Database;
import js.html.idb.ObjectStore;
import js.html.idb.OpenDBRequest;
import js.html.idb.Transaction;
import js.html.idb.TransactionMode;

/**
 * ...
 * @author ...
 */
@:expose("J_WebDB")
class WebDB {
	
	public static function open(name:String, options:Dynamic, handler:WebDB->Void):Void {
		var request:OpenDBRequest = Browser.window.indexedDB.open(name, options);
		request.onsuccess = function(e:Event){
			handler(new WebDB(request.result, null, false));
		}
		request.onerror = function(e:Event){
			handler(new WebDB(null, cast request.error, false));
		}
		request.onupgradeneeded = function(e:Event){
			handler(new WebDB(request.result, null, true));
		}
	}
	
	private var _db:Database;
	
	private var _error:DOMError;
	
	private var _need_upgrade:Bool;
	
	private var _tables:Dynamic;
	
	private var _transaction:Transaction;
	
	public function new(db:Database, error:DOMError, upgrade:Bool):Void {
		_tables = [];
		_need_upgrade = upgrade;
		_db = db;
		_error = error;
	}
	
	public function isOpen():Bool {
		return _db != null;
	}
	
	public function isUpgradeNeeded():Bool {
		return _need_upgrade;
	}
	
	public function getError():DOMError	{
		return _error;
	}
	
	/**
	 * 
	 * @param	name
	 * @param	structure
	 * @param	options		keyPath:bool, autoIncrement:Bool
	 * @return
	 */
	public function createTable(name:String, ?options:Dynamic):WebDBTable {
		_regTable(name, _db.createObjectStore(name, options));
		return table(name);
	}
	
	public function getTables(name:Dynamic, mode:String, ?handler:WebDB->Void):Void {
		if (Std.is(name, String)){
			if (name == '*'){
				name = _db.objectStoreNames;
			}else{
				name = [name];
			}
		}
		switch(mode.toLowerCase()){
			case 'r' : {
				mode = 'read';
			}
			case 'w' : {
				mode = 'write';
			}
			default : {
				mode = 'readwrite';
			}
		}
		_transaction = _db.transaction(name, cast mode);
		Dice.Values(name, function(v:String){
			_regTable(v, _transaction.objectStore(v));
		});
		if(handler != null){
			_transaction.oncomplete = function(e:Event){
				handler(this);
			}
			_transaction.onerror = function(e:Event){
				_error = cast _transaction.error;
				handler(this);
			}
		}
	}
	
	private function _regTable(name:String, store:ObjectStore):Void {
		Reflect.setField(_tables, name, new WebDBTable(name, _db, store));
	}
	
	public function table(name:String):WebDBTable {
		return Reflect.field(_tables, name);
	}
	
}