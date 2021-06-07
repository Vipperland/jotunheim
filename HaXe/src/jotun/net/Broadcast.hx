package jotun.net;
import haxe.Json;
import jotun.events.Event;
import jotun.utils.Dice;
import js.Browser;
import js.html.BroadcastChannel;
import js.html.MessageEvent;
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
	
	private var _muted:Bool = true;
	private var _listeners:Dynamic = {};
	private var _channels:Dynamic;
	
	private function _openChannel(name:String):BroadcastChannel {
		var bc:BroadcastChannel = Reflect.field(_channels, name);
		if (bc == null){
			bc = new BroadcastChannel(name);
			bc.onmessage = _onChannelMsg;
			Reflect.setField(_channels, name, bc);
		}
		return bc;
	}
	
	private function _onChannelMsg(e:MessageEvent):Void {
		_proccessMsg((cast e.target).name, e.data);
	}
	
	private function _proccessMsg(channel:String, data:Dynamic):Void {
		if (!_muted){
			Jotun.log(['[BROADCAST <<] CHANNEL {' + channel + '} @ DATA RECEIVED', data]);
		}
		Dice.Values(Reflect.field(_listeners, channel), function(handler:Dynamic->Void){
			handler(data);
		});
	}
	
	public function new() {
		if (__me__ == null){
			if(Reflect.hasField(Browser.window, 'BroadcastChannel')){
				// Compatible Browsers
				_channels = {};
			}else{
				// Non compatible Browsers
				Browser.window.addEventListener('storage', function(e:StorageEvent){
					var channel:String = e.key;
					var events:Array<Dynamic->Void> = Reflect.field(_listeners, channel);
					if(events != null && events.length > 0){
						var data:Dynamic = e.newValue;
						if(data != null){
							data = Json.parse(data);
							_proccessMsg(channel, data);
						}
					}
				});
			}
			__me__ = this;
		}else{
			throw new js.lib.Error("Broadcast is a singleton, use Broadcast.ME() instead of new");
		}
	}
	
	public function listen(channel:String, handler:Dynamic->Void):Void {
		if(handler != null){
			var events:Array<Dynamic->Void> = Reflect.field(_listeners, channel);
			if (events == null){
				if (_channels != null){
					_openChannel(channel);
				}
				events = [];
				Reflect.setField(_listeners, channel, events);
				if (!_muted){
					Jotun.log(['[BROADCAST ++] CHANNEL {' + channel + '} CONNECTED']);
				}
			}
			events.push(handler);
		}else{
			if (!_muted){
				Jotun.log(['[BROADCAST !!] CHANNEL {' + channel + '} NOT CONNECTED (null)']);
			}
		}
	}
	
	public function unlisten(channel:String, handler:Dynamic->Void):Void {
		var events:Array<Dynamic->Void> = Reflect.field(_listeners, channel);
		if (events != null && handler != null){
			var iof:Int = events.indexOf(handler);
			if (iof != -1){
				events.slice(iof, 1);
				if (events.length == 0){
					if (_channels != null){
						Reflect.field(_channels, channel).close();
						Reflect.deleteField(_channels, channel);
					}
					if (!_muted){
						Jotun.log(['[BROADCAST --] CHANNEL {' + channel + '} DISCONNECTED']);
					}
				}
			}
		}
	}
	
	public function send(channel:String, data:Dynamic){
		if (!_muted){
			Jotun.log(['[BROADCAST >>] CHANNEL {' + channel + '} @ DATA SENT', data]);
		}
		if (_channels != null){
			_openChannel(channel).postMessage(data);
		}else{
			Browser.window.localStorage.setItem(channel, Json.stringify(data));
			Browser.window.localStorage.removeItem(channel);
		}
	}
	
	public function mute(){
		_muted = true;
	}
	
	public function unmute(){
		_muted = false;
	}
	
	
}