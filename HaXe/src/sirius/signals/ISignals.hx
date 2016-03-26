package sirius.signals;

/**
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */

interface ISignals {
	
	public var object : Dynamic;

	public function has (name:String) : Bool;

	public function get (name:String) : IPipe;

	public function add (name:String, ?handler:IFlow->Void) : IPipe;
	
	public function remove (name:String, ?handler:IFlow->Void) : IPipe;

	public function call (name:String, ?data:Dynamic) : Signals;

	public function reset () : Void;
	
}