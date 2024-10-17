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
	
	static public var current(get, null):DataAccess;
	static private function get_current():DataAccess {
		return current;
	}
	
	private var _tables:Dynamic;
	private var _token:Token;
	
	final public function _error(code:Int):Void {
		output.error(code);
	}
	
	public function new(token:Token) {
		if (current != null){
			throw new ErrorException("DataAccess is a Singleton");
		}
		current = this;
		_token = token;
		super();
	}
	
	final public function connect():Void {
		if (_token != null && !Jotun.gate.isOpen()){
			if (!Jotun.gate.open(_token).isOpen()){
				output.setStatus(ErrorCodes.DATABASE_CONNECT_ERROR);
				output.log(Jotun.gate.errors);
			}
			_token = null;
		}
	}
	
	final public function isConnected():Bool {
		return current != null && Jotun.gate.isOpen();
	}
	
	public function execute(handler:Dynamic->Dynamic):Dynamic {
		if (isConnected()){
			return handler(this);
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
		return execute(function(database:DataAccess):Dynamic {
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