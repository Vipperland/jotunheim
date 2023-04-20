package jotun.gateway.domain;
import jotun.Jotun;
import jotun.gateway.database.DataAccess;
import jotun.gateway.domain.Input;
import jotun.gateway.domain.Output;

/**
 * ...
 * @author 
 */
class DomainServices {

	public var database(get, null):DataAccess;
	private function get_database():DataAccess {
		return DataAccess.getInstance();
	}
	
	public var output(get, null):Output;
	private function get_output():Output {
		return Output.ME;
	}
	
	public var input(get, null):Input;
	private function get_input():Input {
		return Input.ME;
	}
	
	private function error(id:Int):Bool {
		output.error(id);
		return false;
	}
	
	public function new() {
		
	}
	
}