package jotun.gateway.objects;
import jotun.gateway.domain.InputCore;
import jotun.gateway.domain.OutputCore;

/**
 * ...
 * @author Rafael Moreira
 */
class OutputCoreCarrier extends InputCoreCarrier {
	
	public var output(get, null):OutputCore;
	private function get_output():OutputCore {
		return OutputCore.getInstance();
	}
	
	public function new() {
		super();
	}
	
}