package jotun.gateway.database;
import jotun.Jotun;
import jotun.gateway.domain.OutputCore;
import jotun.gateway.errors.ErrorCodes;
import jotun.gateway.flags.GatewayOptions;
import jotun.gateway.objects.OutputCoreCarrier;
import jotun.logical.Flag;
import jotun.php.db.Token;
import jotun.php.db.objects.IDataTable;
import php.ErrorException;

/**
 * ...
 * @author 
 */
class DataAccess extends OutputCoreCarrier {
	
	static private var _instance:DataAccess;
	static public function getInstance():DataAccess {
		return _instance;
	}
	
	public function _error(code:Int):Void {
		output.error(code);
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
		super();
	}
	
	public function isConnected():Bool {
		return _instance != null && Jotun.gate.isOpen();
	}
	
	public function execute(handler:Dynamic):Dynamic {
		if (isConnected()){
			return handler();
		}
		output.error(ErrorCodes.DATABASE_UNAVAILABLE);
		return null;
	}
	
	public function setOptions(value:Int):Void {
		if (Flag.FTest(value, GatewayOptions.DATABASE)){
			Jotun.gate.listen(_dbLog);
		}
	}
	
	private function _dbLog(message:String):Void {
		output.log(message, 'sql');
	}
	
	private function _tryAssemble(table:String, Def:Dynamic):IDataTable {
		return execute(function(){
			var table:IDataTable = Jotun.gate.table(table);
			if (table != null){
				table.setClassObj(Def);
				return table;
			}else{
				output.error(ErrorCodes.DATABASE_MISSING_TABLE);
				return  null;
			}
		});
	}
	
	
}