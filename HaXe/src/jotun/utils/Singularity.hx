package jotun.utils;
import haxe.DynamicAccess;
import haxe.Timer;
import jotun.events.Event;
import jotun.signals.Signals;
import js.Browser;

typedef TabInstance = {
	var id:String;
	var main:Bool;
	var name:String;
	var time:Float;
	var url:String;
	var visible:Bool;
	var ?current:Bool;
}

/**
 * ...
 * @author 
 */
@:expose("Singularity")
class Singularity {

	private static var _channel:String = 'jotumhein';
	
	private static var _name:String;
	
	private static var _engines:DynamicAccess<TabInstance>;
	
	private static var _data:TabInstance;
	
	private static var _is_main:Bool;
	
	private static var _is_active:Bool;
	
	private static var _self_activate:Timer;
	
	public static var signals:Signals = new Signals(Singularity);
	
	static private function _selfActivate():Void {
		_checkIfUnique();
	}
	
	static private function _stopVerification():Void {
		if(_self_activate != null){
			_self_activate.stop();
			_self_activate = null;
		}
	}
	
	static private function _checkIfUnique():Bool {
		if (!_is_main){
			_is_main = Dice.Values(_engines, function(v:TabInstance){
				return v.main;
			}).completed;
			_syncMain();
		}
		return _is_main;
	}
	
	static function _syncMain() {
		_data.main = true;
		Jotun.broadcast.send(_channel, {
			action:'main',
			id:id(),
		});
		signals.call('onMain', _data);
	}
	
	private static function _getHeir():String {
		var r:String = null;
		 Dice.Values(_engines, function(v:TabInstance){
			if (v.id != _data.id){
				r = v.id;
				return true;
			}else{
				return false;
			}
		});
		return r;
	}
	
	public static function id():String {
		return Jotun.broadcast.getUID();
	}
	
	
	static private function _register(data:Dynamic):TabInstance {
		var ndata:TabInstance = {
			id: data.id,
			name: data.name,
			url: data.url,
			main: data.main,
			time: data.time,
			visible: data.visible,
		};
		_engines.set(data.id, ndata);
		return ndata;
	}
	
	static private function _unregister(data:Dynamic):TabInstance {
		data = _engines.get(data.id);
		_engines.remove(data.id);
		return data;
	}
	
	static private function _onEngine(data:Dynamic):Void {
		switch(data.action){
			case 'connect' : {
				data = _register(data);
				Jotun.broadcast.send(_channel, {
					action:'update',
					id:id(),
					url: Jotun.domain.location(),
					time: _data.time,
					main: _is_main,
					visible: _is_active,
				});
				signals.call('onConnect', data);
				signals.call('onInstance', data);
			}
			case 'update' : {
				data = _register(data);
				if (data.main && _is_main){
					_is_main = false;
					_data.main = false;
				}
				if(data.main){
					_stopVerification();
				}
				signals.call('onUpdate', data);
				signals.call('onInstance', data);
			}
			case 'visibility' : {
				var engine:TabInstance = _engines.get(data.id);
				if (engine != null){
					engine.visible = data.visible ? data.visible : false;
				}
				signals.call('onVisibility', engine);
			}
			case 'sync' : {
				if (Std.isOfType(data.filter, String)){
					data.filter = [data.filter];
				}
				if (data.filter == null || (Std.isOfType(data.filter, Array) && data.filter.indexOf(id()) != -1)){
					var engine:TabInstance = _engines.get(data.id);
					if(engine != null){
						signals.call('onSync', {
							engine: engine,
							syncedData: data.data,
						});
					}
				}
			}
			case 'main' : {
				var engine:TabInstance = _engines.get(data.id);
				if (engine != null){
					engine.main = true;
					if (_is_main){
						_is_main = false;
						_data.main = false;
					}
				}
				_stopVerification();
				signals.call('onMain', engine);
			}
			case 'disconnect' : {
				var drop:Dynamic = _unregister(data);
				if (data.main && data.heir == id()){
					_is_main = true;
					_syncMain();
				}
				signals.call('onDisconnect', drop);
			}
		}
	}
	
	static public function instances():Array<Dynamic> {
		var r:Array<Dynamic> = [];
		Dice.Values(_engines, function(v:TabInstance){
			r.push(v);
		});
		Dice.Sort(r, 'time', true);
		return r;
	}
	
	public static function count():Int {
		var i:Int = 0;
		Dice.Values(_engines, function(v:TabInstance){
			++i;
		});
		return i;
	}
	
	public static function channel(value:String = null):String {
		if (value != null && value != ""){
			_channel = "singularity." + value;
		}
		return _channel;
	}
	
	public static function sync(data:Dynamic, ?id:Dynamic = null):Void {
		Jotun.broadcast.send(_channel, {
			action: 'sync',
			id: Singularity.id(),
			filter: id,
			data: data,
		});
	}
	
	private static function _onVisibilityChanged(e:Event):Void {
		_is_active = (cast Browser.document.visibilityState) == 'visible';
		_data.visible = _is_active;
		Jotun.broadcast.send(_channel, {
			action:'visibility', 
			id:id(), 
			visible:_is_active
		});
	}
	
	public static function connect(?options:Dynamic):Void {
		if (_engines == null){
			_engines = {};
			if (options != null){
				if (options.name != null){
					_name = options.name;
				}
				if (options.channel != null){
					_channel = options.channel;
				}
			}
			_is_active = (cast Browser.document.visibilityState) != 'visible' ? false : true;
			_data = {
				id: id(),
				name: _name,
				url: Jotun.domain.location(),
				visible: _is_active,
				main: false,
				current: true,
				time: Date.now().getTime(),
			};
			_engines.set(_data.id, _data);
			Jotun.broadcast.listen(_channel, _onEngine);
			Jotun.broadcast.send(_channel, {
				action:'connect', 
				id:_data.id, 
				name:_data.name, 
				url: _data.url, 
				visible: _is_active, 
				time: _data.time
			});
			Browser.document.addEventListener("visibilitychange", _onVisibilityChanged, false);
			Browser.window.addEventListener("beforeunload", function(e){
				Browser.document.removeEventListener("visibilitychange", _onVisibilityChanged);
				_stopVerification();
				Jotun.broadcast.send(_channel, {
					action:'disconnect', 
					id:id(), 
					main: _is_main, 
					heir:_getHeir()
				});
			}, true);
			_self_activate = Timer.delay(_selfActivate, 1000);
		}
	}
	
	static public function isMain():Bool {
		return _is_main == true;
	}
	
	static public function isActive():Bool {
		return _is_active == true;
	}
	
	static public function fetch(o:Dynamic):Void {
		Dice.Values(['onMain','onConnect','onDisconnect','onSync','onInstance','onVisibility'], function(v:String):Void {
			if(Reflect.hasField(o, v)){
				signals.add(v, Reflect.field(o, v));
			}
		});
	}
	
	static public function toString():String {
		var ids:Array<String> = [];
		Dice.Values(_engines, function(v:Dynamic){
			if(v.id != id()){
				ids.push(v.id);
			}
		});
		return "[Singularity{id=" + id() + ",main=" + isMain() + ",connections=" + count() + ",channel=" + _channel + ",instances=[" + ids.join(',') + "]}]";
	}
	
}