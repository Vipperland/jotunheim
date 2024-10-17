package jotun.signals;
import jotun.signals.Flow;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */
class Pipe {
	
	public var name:String;
	
	public var host:Signals;
	
	public var transfer:Bool = true;
	
	public var enabled:Bool = true;
	
	public var calls:UInt = 0;
	
	public var current:Flow;
	
	private var _l:Array<Dynamic>;
	
	private var _v:Flow->Void;
	
	public function new(name:String, host:Signals) {
		this.host = host;
		this.name = name;
		reset();
	}
	
	public function add(handler:Flow->Void):Pipe {
		if (Lambda.indexOf(_l, handler) == -1){
			_l.push(handler);
		}
		return this;
	}
	
	public function remove(handler:Flow->Void):Pipe {
		var i:Int = Lambda.indexOf(_l, handler);
		if (i != -1){
			_l.splice(i, 1);
		}
		return this;
	}
	
	public function disconnect():Pipe {
		if (_v != null){
			remove(_v);
			_v = null;
		}
		return this;
	}
	
	public function call(?data:Dynamic):Pipe {
		if(enabled){
			++calls;
			current = new Flow(this, data);
			transfer = true;
			Dice.Values(_l, function(v:Flow->Void){
				_v = v;
				v(current);
				return !transfer;
			});
			_v = null;
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