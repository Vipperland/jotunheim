package jotun.data;
import haxe.Log;
#if js
	import jotun.dom.Displayable;
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
	public static inline var MODULE:Int = 4;
	public static inline var QUERY:Int = 5;
	public static inline var BROADCAST:Int = 6;
	public static inline var OBSOLETE:Int = 7;
	public static inline var TODO:Int = 8;
	
	private var _events:Array<Dynamic->Int->Void>;
	
	private var _levels:Array<Int> = [1,1,1,1,1,0,1,0,0];
	
	public function enable(i:Int):Void {
		_levels[i] = 1;
	}
	
	public function disable(i:Int):Void {
		_levels[i] = 0;
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
		if (_levels[type] != 1){
			return;
		}
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
		if (_levels[type] != 1){
			return;
		}
		var t:String = "";
		if (type != null){
			switch(type) {
				case MESSAGE : t = "[MESSAGE] ";
				case SYSTEM : t = "[>SYSTEM] ";
				case WARNING : t = "[WARNING] ";
				case ERROR : t = "[!ERROR!] ";
				case TODO : t = "[//TODO*] ";
				case QUERY : t = "[$QUERY*] ";
				case BROADCAST : t = "[BRDCAST] ";
				case OBSOLETE : t = "[OBSOLET] ";
				case MODULE : t = "[MODULES] ";
				default : "";
			}
		}
		
		#if js
			q = [t, q];
		#end
		dump(q);
	}
	
}