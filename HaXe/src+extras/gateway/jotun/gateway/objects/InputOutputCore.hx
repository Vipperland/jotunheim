package jotun.gateway.objects;
import jotun.gateway.domain.InputCore;
import jotun.gateway.domain.OutputCore;

/**
 * ...
 * @author Rafael Moreira
 */
class InputOutputCore {
	
	public var output(get, null):OutputCore;
	private function get_output():OutputCore {
		return OutputCore.getInstance();
	}
	
	public var input(get, null):InputCore;
	private function get_input():InputCore {
		return InputCore.getInstance();
	}
	
	public function new() {
		
	}
	
}