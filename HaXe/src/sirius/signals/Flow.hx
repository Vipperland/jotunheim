package sirius.signals;

/**
 * ...
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */
class Flow implements IFlow {
	
	public var data:Dynamic;
	
	public var pipe:IPipe;

	public function new(pipe:IPipe, data:Dynamic) {
		this.data = data;
		this.pipe = pipe;
	}
	
}