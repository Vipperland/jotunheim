package jotun.gateway.database;
import jotun.Jotun;
import jotun.gateway.database.objects.ZoneCoreObject;
import jotun.gateway.domain.Input;
import jotun.gateway.domain.Output;
import jotun.gateway.errors.ErrorCodes;
import jotun.php.db.Token;
import jotun.php.db.objects.IDataTable;
import jotun.gateway.database.objects.ZoneCoreSession;
import php.ErrorException;

/**
 * ...
 * @author 
 */
class DataAccess {
	
	static private var _instance:DataAccess;
	static public function getInstance():DataAccess {
		return _instance;
	}
	
	static public function execute(handler:Dynamic):Dynamic {
		if (_instance != null){
			return handler();
		}
		Output.ME.error(ErrorCodes.DATABASE_UNAVAILABLE);
		return  null;
	}
	
	public function _error(code:Int):Void {
		Output.ME.error(code);
	}
	
	public function new(token:Token) {
		if (_instance != null){
			throw new ErrorException("DataAccess is a Singleton");
		}
		_instance = this;
		if (!Jotun.gate.isOpen()){
			if (!Jotun.gate.open(token).isOpen()){
				_error(ErrorCodes.DATABASE_CONNECT_ERROR);
			}
		}
	}
	
	public function isConnected():Bool {
		return _instance != null;
	}
	
	private function _tryAssemble(table:String, Def:Dynamic):IDataTable {
		return execute(function(){
			var table:IDataTable = Jotun.gate.table(table);
			if (table != null){
				table.setClassObj(Def);
				return table;
			}else{
				Output.ME.error(ErrorCodes.DATABASE_MISSING_TABLE);
				return  null;
			}
		});
	}
	
	public var user_session(get, null):IDataTable;
	private function get_user_session():IDataTable {
		return this.user_session;
	}
	
	
}