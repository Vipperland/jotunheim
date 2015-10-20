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
	
	public function dev():Void {
		if (_toasts == null) {
			_toasts = new Div();
			_toasts.pin();
			_toasts.css('arial txt-12 txt-white padd-10 z-9999999 bg-black-80 max-height-100pc max-width-100pc scroll-y t-0');
			_toasts.addToBody();
			_toasts.build('Sirius::Logger');
			_bgs = ['txt-cccccc','txt-white','txt-limegreen','txt-yellow','txt-orange bold'];
			Automator.build('arial txt-10 bg-black-80 padd-5 t-0 z-9999999 bg-black-70 padd-10 txt-black txt-white txt-green txt-yellow txt-orange bold');
		}
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
					not.addTo(_toasts);
				}else {
					haxe.Log.trace(t + q);
				}
			#elseif php
				js.Lib.dump(q);
			#end
		}
	}
	
}