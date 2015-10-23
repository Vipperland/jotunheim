package sirius.data;
import haxe.Log;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Logger{
	
	private var _bgs:Array<String>;
	
	private var _events:Array<Dynamic->UInt->Void>;
	
	public function new() {
		_events = [trace];
	}
	
	#if js
		public function clear():Void {
			Log.clear();
		}
	#end
	
	public function silent():Void {
		if (Lambda.indexOf(_events, trace) != -1) _events.splice(0, 1);
	}
	
	public function listen(handler:Dynamic->UInt->Void):Void {
		_events[_events.length] = handler;
	}
	
	public function push(q:Dynamic, type:UInt) {
		Dice.Values(_events, function(v:Dynamic->UInt->Void) { v(q, type); });
	}
	
	public function trace(q:Dynamic, type:UInt):Void {
		var t:String = switch(type) {
			case 0 : "[MESSAGE] ";
			case 1 : "[>SYSTEM] ";
			case 2 : "[WARNING] ";
			case 3 : "[!ERROR!] ";
			case 4 : "[//TODO:] ";
			default : "";
		}
		#if js
			haxe.Log.trace(t + q);
		#elseif php
			php.Lib.dump(q);
		#end
	}
	
}