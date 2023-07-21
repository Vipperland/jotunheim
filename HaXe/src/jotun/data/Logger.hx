package jotun.data;
import haxe.Log;
#if js
	import jotun.dom.IDisplay;
	import js.Syntax;
#elseif php
	import php.Lib;
#end
import jotun.logical.Flag;
import jotun.net.IRequest;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Logger {
	
	public static inline var MESSAGE:Int = 0;
	public static inline var SYSTEM:Int = 1;
	public static inline var WARNING:Int = 2;
	public static inline var ERROR:Int = 3;
	public static inline var TODO:Int = 4;
	public static inline var QUERY:Int = 5;
	public static inline var BROADCAST:Int = 6;
	public static inline var OBSOLETE:Int = 7;
	
	private var _events:Array<Dynamic->Int->Void>;
	
	private var _level:Flag = new Flag(MESSAGE | SYSTEM | WARNING | ERROR);
	
	public function enable(i:Int):Void {
		_level.put(i);
	}
	
	public function disable(i:Int):Void {
		_level.drop(i);
	}
	
	public function new() {
		_events = [];
		#if js 
			_events[0] = query;
		#elseif php
			Reflect.setField(_events, "query", query);
		#end
	}
	
	public function mute():Void {
		if (Lambda.indexOf(_events, query) != -1) {
			_events.splice(0, 1);
		}
	}
	
	public function unmute():Void {
		if (Lambda.indexOf(_events, query) == -1) {
			_events.unshift(query);
		}
	}
	
	public function listen(handler:Dynamic->Int->Void):Void {
		_events[_events.length] = handler;
	}
	
	public function push(q:Dynamic, type:Int) {
		Dice.Values(_events, function(v:Dynamic->Int->Void) {
			v(q, type); 
		});
	}
	
	public function dump(q:Dynamic):Void {
		#if js
			Syntax.code("console.log").apply(null, q);
		#elseif php
			Lib.dump(q);
		#end
	}
	
	public function query(q:Dynamic, type:Int):Void {
		if (!_level.test(type)){
			return;
		}
		var t:String = "";
		if(type != null){
			t = switch(type) {
				case 0 : "[MESSAGE] ";
				case 1 : "[>SYSTEM] ";
				case 2 : "[WARNING] ";
				case 3 : "[!ERROR!] ";
				case 4 : "[//TODO*] ";
				case 5 : "[$QUERY*] ";
				case 6 : "[BRDCAST] ";
				case 7 : "[OBSOLET] ";
				default : "";
			}
		}
		
		#if js
			q = [t, q];
		#end
		dump(q);
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