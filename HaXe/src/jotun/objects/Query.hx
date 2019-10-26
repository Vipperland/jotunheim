package jotun.objects;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose('sru.objects.Query')
class Query implements IQuery implements Dynamic {
	
	private var _log:Array<String>;
	private var _buffer:Dynamic;
	private var _now:Dynamic;
	
	public function new(){
		_log = [];
	}
	
	public function log():Array<String> {
		return _log;
	}
	
	public function flush():Void {
		_log = [];
		_now = [];
	}
	
	/**
	 * methodName|property ...parameters|value
	 * parameters are separated by 'TAB'
	 * sample:
	 * 			myFunct	prop1	prop2
	 * @param	data
	 */
	public function proc(data:Dynamic, ?result:Dynamic):Dynamic {
		_buffer = result != null ? result : {};
		_now = null;
		_batchExec(data);
		return _buffer;
	}
	private function _batchExec(data:Dynamic):Void {
		Dice.Values(Std.is(data, Array) ? data : data.split('\r'), _exec);
	}
	private function _exec(q:String):Void {
		var o:Dynamic = null;
		switch(q.substr(0,1)){
			// Command definition
			case '@' : {
				switch(q.substr(1, 1)){
					case '!' : {
						_now = null;
					}
					default : {
						var prop:String = q.substr(1, q.length - 1);
						if (!Reflect.hasField(_buffer, prop)){
							_now = [];
							Reflect.setField(_buffer, prop, _now);
						}else{
							_now = Reflect.field(_buffer, prop);
						}
					}
				}
			}
			// Common behaviour
			default: {
				// Clear double tabs
				q = q.split('	').join(' ');
				while (q.indexOf('  ') != -1){
					q = q.split('  ').join(' ');
				}
				// Create parameter array
				var tk:Array<String> = q.split(' ');
				// First string is the method
				var method:String = tk.shift();
				var isMethod:Bool = true;
				// Check if method or property exists
				#if js 
					o = Reflect.getProperty(this, method);
					isMethod = Reflect.isFunction(o);
				#elseif php
					if (untyped __call__("method_exists", this, method)){
						o = method;
						isMethod = true;
					}
				#end
				if (o != null && isMethod){
					_log[_log.length] = q;
					// Call method, if is a function and use the argument array, recursive call if result is a string and result the last one
					if (isMethod){
						o = Reflect.callMethod(this, o, tk);
						if (o != null && Std.is(o, String)){
							_batchExec(o);
							o = null;
						}
					}
					// Set value of property if not a method
					else{
						o = tk[0];
						Reflect.setField(this, method, o);
					}
				}
				if (o != null && _now != null){
					_now[_now.length] = o;
				}
			}
		}
	}
	
}