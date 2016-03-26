package sirius.signals;

/**
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */

interface IPipe {
  
	public var name : String;
	
	public var transfer : Bool;
	
	public var enabled : Bool;
	
	public var calls : UInt;
	
	public var current : IFlow;

	public function add (handler:IFlow->Void) : IPipe;

	public function remove (handler:IFlow->Void) : IPipe;

	public function call (?data:Dynamic) : IPipe;

	public function stop () : Void;
	
	public function reset():Void;
	
}