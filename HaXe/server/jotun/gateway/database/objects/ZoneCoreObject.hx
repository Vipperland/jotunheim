package jotun.gateway.database.objects;
import jotun.Jotun;
import jotun.gateway.database.DataAccess;
import jotun.utils.Dice;
import jotun.gateway.domain.Input;
import jotun.gateway.domain.Output;

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
		return DataAccess.execute(handler);
	}
	
	private var _output(get, null):Output;
	private function get__output():Output {
		return Output.ME;
	}
	
	private var _input(get, null):Input;
	private function get__input():Input {
		return Input.ME;
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