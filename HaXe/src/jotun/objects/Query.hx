package jotun.objects;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose('J_Query')
class Query extends Resolve implements IQuery {
	
	private var _buffer:QueryBuffer;
	
	public var editable:Bool;
	
	public function new(?editable:Bool){
		this.editable = editable == true;
		super();
	}
	
	public function log():Array<String> {
		return _buffer.log;
	}
	
	public function flush():Void {
		_buffer.flush();
	}
	
	/**
	 * methodName|property ...parameters|value
	 * parameters are separated by 'TAB'
	 * sample:
	 * 			myFunct		prop1	prop2
	 * 			myObj.myFunc	prop1	prop2
	 * @param	data
	 */
	public function proc(data:Dynamic, ?result:Dynamic):Dynamic {
		_buffer = new QueryBuffer(result);
		_batchExec(data);
		return _buffer.data;
	}
	
	private function _innerProc(data:Dynamic, buffer:QueryBuffer):Void {
		_buffer = buffer;
		_batchExec(data);
	}
	
	private function _batchExec(data:Dynamic):Void {
		Dice.Values(Std.isOfType(data, Array) ? data : data.split('\n'), _exec);
	}
	
	private function _strip(q:String):String {
		while (q.indexOf('\t\t') != -1){
			q = q.split('\t\t').join(' ');
		}
		// Clear double spaces
		while (q.indexOf('  ') != -1){
			q = q.split('  ').join(' ');
		}
		return q;
	}
	
	private function _changeContext(prop:String):Void {
		if (!Reflect.hasField(_buffer.data, prop)){
			_buffer.now = [];
			Reflect.setField(_buffer.data, prop, _buffer.now);
		}else{
			_buffer.now = Reflect.field(_buffer.data, prop);
		}
	}
	
	private function _exec(q:String):Void {
		// Clear double tabs
		q = _strip(q);
		switch(q.substr(0,1)){
			// Command definition
			case '@' : {
				switch(q.substr(1, 1)){
					case '!' : {
						_buffer.now = null;
					}
					default : {
						_changeContext(q.substr(1, q.length - 1));
					}
				}
			}
			// Common behaviour
			default: {
				var iofd:Int = q.indexOf(".");
				// Check if is object access
				if (iofd != -1){
					if(iofd < q.indexOf(" ")){
						var subq:Array<String> = q.split(".");
						var q:String = subq.shift();
						if(Reflect.hasField(this, q)){
							var obj:Query = Reflect.field(this, q);
							if (Std.isOfType(obj, Query)){
								obj._innerProc(subq.join("."), _buffer);
								return;
							}
						}
						_buffer.now.push(null);
						return;
					}
				}
				// Create parameter array
				var tk:Array<String> = q.split(' ');
				// First string is the method
				var method:String = tk.shift();
				var isMethod:Bool = true;
				var o:Dynamic = null;
				// Check if method or property exists
				#if js 
					o = Reflect.getProperty(this, method);
					isMethod = Reflect.isFunction(o);
				#elseif php
					if (php.Syntax.codeDeref("method_exists({0}, {1})", this, method)){
						o = Reflect.field(this, method);
						isMethod = true;
					}
				#end
				if (isMethod){
					_buffer.log.push(q);
					// Call method with the argument array, recursive call if result is a string and result the last one
					if (isMethod){
						o = Reflect.callMethod(this, o, tk);
						if (o != null && Std.isOfType(o, String) && o.substr(0, 1) == "~"){
							o = o.substring(1, o.length);
							_batchExec(o);
							o = null;
						}
						_buffer.add(o);
					}
				} else if(editable){
					o = tk[0];
					Reflect.setField(this, method, o);
				} else {
					_buffer.add(o);
				}
			}
		}
	}
	
}

class QueryBuffer {
	public var data:Dynamic;
	public var now:Array<Dynamic>;
	public var log:Array<String>;
	public function new(result:Dynamic) {
		data = result == null ? { } : result;
		flush();
	}
	public function flush():Void {
		now = [];
		log = [];
	}
	
	public function add(o:Dynamic):Void {
		if(now != null){
			now[now.length] = o;
		}
	}
}