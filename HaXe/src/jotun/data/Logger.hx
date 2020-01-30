package jotun.data;
import haxe.Log;
#if js
	import jotun.dom.IDisplay;
#end
import jotun.net.IRequest;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Logger{
	
	private var _events:Array<Dynamic->Int->Void>;
	
	private var _level:Int = 4;
	
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
	
	public function listen(handler:Dynamic->Int->Void):Void {
		_events[_events.length] = handler;
	}
	
	public function push(q:Dynamic, type:Int) {
		Dice.Values(_events, function(v:Dynamic->Int->Void) { 	v(q, type); });
	}
	
	public function dump(q:Dynamic):Void {
		#if js
			untyped __js__("console.log")(q);
		#elseif php
			php.Lib.dump(q);
		#end
	}
	
	public function query(q:Dynamic, type:Int):Void {
		if (type > _level){
			return;
		}
		var t:String = switch(type) {
			case 0 : "[MESSAGE] ";
			case 1 : "[>SYSTEM] ";
			case 2 : "[WARNING] ";
			case 3 : "[!ERROR!] ";
			case 4 : "[//TODO*] ";
			case 5 : "[$QUERY*] ";
			default : "";
		}
		#if js
			dump(t + q);
		#elseif php
			dump(q);
		#end
	}
	
	#if js
		public function showConsole(?url:String = 'modules/dev/console.html'):Void {
			Jotun.module(url, 'jotun-console', null, function(r:IRequest){
				var ui:IDisplay = Jotun.one('jotun-console');
				if (ui == null){
					ui = Jotun.resources.build('jotun-console');
					if (ui != null){
						ui.addToBody();
					}
				}
				if (ui != null){
					ui.show();
				}
			});
		}
		
		public function hideConsole():Void {
			var ui:IDisplay = Jotun.one('jotun-console');
			if (ui != null){
				ui.hide();
			}
		}
	#end
	
}