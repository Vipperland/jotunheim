package sirius.data;
import haxe.Log;
import js.Browser;
import sirius.css.Automator;
import sirius.dom.Div;
import sirius.dom.IDisplay;
import sirius.tools.Ticker;

/**
 * ...
 * @author Rafael Moreira
 */
class Logger{
	
	private var _loglevel:UInt = 12;
	
	private var _toasts:IDisplay = null;
	
	private var _bgs:Array<String>;
	
	public function new() {
		
	}
	
	public function clear():Void {
		if (_toasts != null) _toasts.clear(true);
		Log.clear();
	}
	
	public function push(q:Dynamic, level:UInt, type:UInt) {
		if (level <= _loglevel) {
			var t:String = switch(type) {
				case -1 : "";
				case 0 : "[MESSAGE] ";
				case 1 : "[>SYSTEM] ";
				case 2 : "[WARNING] ";
				case 3 : "[!ERROR!] ";
				case 4 : "[//TODO:] ";
				default : "";
			}
			#if js
				if (_toasts != null) {
					var not:IDisplay = new Div();
					not.css(_bgs[type+1] + ' arial');
					not.build(t + q);
					not.addTo(_toasts.children().first());
				}else {
					haxe.Log.trace(t + q);
				}
			#elseif php
				js.Lib.dump(q);
			#end
		}
	}
	
}