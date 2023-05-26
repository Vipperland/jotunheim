package jotun.gateway.objects;
import jotun.gateway.domain.InputCore;

/**
 * ...
 * @author Rafael Moreira
 */
class InputCoreCarrier {

	public var input(get, null):InputCore;
	private function get_input():InputCore {
		return InputCore.getInstance();
	}
	
	public function new() {
		
	}
	
}