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
	
	private var _tables:Dynamic;
	
	final public function _error(code:Int):Void {
		output.error(code);
	}
	
	public function new(token:Token) {
		if (_instance != null){
			throw new ErrorException("DataAccess is a Singleton");
		}
		_instance = this;
		if (!Jotun.gate.isOpen()){
			if (!Jotun.gate.open(token).isOpen()){
				output.setStatus(ErrorCodes.DATABASE_CONNECT_ERROR);
			}
		}
		super();
	}
	
	final public function isConnected():Bool {
		return _instance != null && Jotun.gate.isOpen();
	}
	
	public function execute(handler:Void->Dynamic):Dynamic {
		if (isConnected()){
			return handler();
		}
		return null;
	}
	
	public function setOptions(value:Int):Void {
		if (Flag.FTest(value, GatewayOptions.DATABASE_LOG)){
			Jotun.gate.listen(_dbLog);
		}
	}
	
	final private function _dbLog(message:String):Void {
		output.log(message, 'sql');
	}
	
	final private function _tryAssemble(table:String, Def:Dynamic):IDataTable {
		return execute(function(){
			var table:IDataTable = Jotun.gate.table(table);
			if (table != null){
				return table.setClassObj(Def);
			}else{
				if (output.getStatus() == 200){
					output.error(ErrorCodes.DATABASE_MISSING_TABLE);
				}
				return  null;
			}
		});
	}
	
	
}