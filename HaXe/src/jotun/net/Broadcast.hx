package jotun.net;
import haxe.Json;
import jotun.events.Event;
import jotun.utils.Dice;
import js.Browser;
import js.html.StorageEvent;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("J_Broadcast")
class Broadcast {
	
	private static var __me__:Broadcast;
	
	static public function ME():Broadcast {
		return __me__ == null ? new Broadcast() : __me__;
	}
	
	private var _listeners:Dynamic = {};
	
	public function new() {
		if (__me__ == null){
			Browser.window.addEventListener('storage', function(e:StorageEvent){
				var channel:String = e.key;
				var events:Array<Dynamic->Void> = Reflect.field(_listeners, channel);
				if(event != null && events.length > 0){
					var data:Dynamic = e.newValue;
					if(data != null){
						data = Json.parse(data);
						trace('[BROADCAST <<] CHANNEL {' + channel + '} @ DATA RECEIVED', data);
						Dice.Values(_listeners[channel], function(handler:Dynamic->Void){
							handler(data);
						});
					}
				}
			});
			__me__ = this;
		}else{
			throw new js.lib.Error("Broadcast is a singleton, use Broadcast.ME() instead of new");
		}
	}
	
	public function listen(channel:String, handler:Dynamic->Void):Void {
		var events:Array<Dynamic->Void> = Reflect.field(_listeners, channel);
		if (events == null){
			trace('[BROADCAST ++] CHANNEL {' + channel + '} CONNECTED');
			events = [];
			Reflect.setField(_listeners, channel, events);
		}
		events.push(handler);
	}
	
	public function unlisten(channel:String, handler:Dynamic->Void):Void {
		var events:Array<Dynamic->Void> = Reflect.field(_listeners, channel);
		if (events != null){
			var iof:Int = events.indexOf(handler);
			if (iof != -1){
				events.slice(iof, 1);
			}
			if (events.length == 0){
				trace('[BROADCAST --] CHANNEL {' + channel + '} DISCONNECTED');
			}
		}
	}
	
	public function send(channel:String, data:Dynamic){
		trace('[BROADCAST >>] CHANNEL {' + channel + '} @ DATA SENT', data);
		Browser.window.localStorage.setItem(channel, Json.stringify(data));
		Browser.window.localStorage.removeItem(channel);
	}
	
	
}