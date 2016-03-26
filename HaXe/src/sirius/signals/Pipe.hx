package sirius.signals;
import sirius.signals.Flow;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */
class Pipe implements IPipe {
	
	public var name:String;
	
	public var transfer:Bool = true;
	
	public var enabled:Bool = true;
	
	public var calls:UInt = 0;
	
	public var current:IFlow;
	
	private var _l:Array<Dynamic>;
	
	public function new(name:String, host:Signals) {
		this.name = name;
		reset();
	}
	
	public function add(handler:IFlow->Void):IPipe {
		if (Lambda.indexOf(_l, handler) == -1)
			_l.push(handler);
		return this;
	}
	
	public function remove(handler:IFlow->Void):IPipe {
		var i:Int = Lambda.indexOf(_l, handler);
		if (i != -1)
			_l.splice(i, 1);
		return this;
	}
	
	public function call(?data:Dynamic):IPipe {
		if(enabled){
			++calls;
			current = new Flow(this, data);
			transfer = true;
			Dice.Values(_l, function(v:IFlow->Void){
				v(current);
				return !transfer;
			});
		}
		current = null;
		return this;
	}
	
	public function stop():Void {
		transfer = false;
	}
	
	public function reset():Void {
		_l = [];
	}

}