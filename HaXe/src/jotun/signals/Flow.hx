package jotun.signals;

/**
 * ...
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */
class Flow  {
	
	public var data:Dynamic;
	
	public var pipe:Pipe;

	public function new(pipe:Pipe, data:Dynamic) {
		this.data = data;
		this.pipe = pipe;
	}
	
}