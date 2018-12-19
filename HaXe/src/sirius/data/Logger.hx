package sirius.data;
import haxe.Log;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Logger{
	
	private var _events:Array<Dynamic->UInt->Void>;
	
	private var _level:UInt = 4;
	
	public function maxLvLog(i:Int):Void {
		_level = i;
	}
	
	public function new() {
		_events = [];
		#if js 
			_events[0] = query;
		#elseif php
			Reflect.setField(_events, "query", query);
		#end
	}
	
	#if js
		public function clear():Void {
			Log.clear();
		}
	#end
	
	public function mute():Void {
		if (Lambda.indexOf(_events, query) != -1) _events.splice(0, 1);
	}
	
	public function unmute():Void {
		if (Lambda.indexOf(_events, query) == -1) _events.unshift(query);
	}
	
	public function listen(handler:Dynamic->UInt->Void):Void {
		_events[_events.length] = handler;
	}
	
	public function push(q:Dynamic, type:UInt) {
		Dice.Values(_events, function(v:Dynamic->UInt->Void) { 	v(q, type); });
	}
	
	public function query(q:Dynamic, type:UInt):Void {
		if (type > _level){
			return;
		}
		var t:String = switch(type) {
			case 0 : "[MESSAGE] ";
			case 1 : "[>SYSTEM] ";
			case 2 : "[WARNING] ";
			case 3 : "[!ERROR!] ";
			case 4 : "[//TODO:] ";
			case 5 : "[*QUERY:] ";
			default : "";
		}
		#if js
			untyped __js__("console.log")(t + q);
		#elseif php
			php.Lib.dump(q);
		#end
	}
	
}