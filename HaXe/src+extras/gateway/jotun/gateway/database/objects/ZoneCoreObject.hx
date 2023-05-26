package jotun.gateway.database.objects;
import jotun.Jotun;
import jotun.gateway.database.DataAccess;
import jotun.utils.Dice;
import jotun.gateway.domain.InputCore;
import jotun.gateway.domain.OutputCore;

/**
 * ...
 * @author 
 */
class ZoneCoreObject {

	private var _database(get, null):DataAccess;
	private function get__database():DataAccess {
		return DataAccess.getInstance();
	}
	
	private function RunSQL(handler:Dynamic):Dynamic {
		return _database.execute(handler);
	}
	
	private var _output(get, null):OutputCore;
	private function get__output():OutputCore {
		return OutputCore.getInstance();
	}
	
	private var _input(get, null):InputCore;
	private function get__input():InputCore {
		return InputCore.getInstance();
	}
	
	private function _error(id:Int, ?not:Dynamic):Bool {
		_output.error(id);
		return false;
	}
	
	private function _hasError(id:Int):Bool {
		return _output.hasError(id);
	}
	
	public function new() {
		
	}
	
}