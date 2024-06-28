package jotun.gaming.actions;
import jotun.tools.Utils;

/**
 * ...
 * @author Rim Project
 */
class Resolution {
	
	private var _type:String;
	
	public var id:String;
	
	public var query:Array<String>;
	
	public var then:Events;
	
	public var fail:Events;
	
	public var breakon:String;
	
	public var _stopped:Bool;
	
	public var reverse:Bool;
	
	public function new(type:String, data:Dynamic) {
		_type = type;
		reverse = Utils.boolean(data.reverse);
		if(breakon != null){
			breakon = breakon.toLowerCase();
		}
		if (Std.isOfType(data.query, Array)){
			query = data.query;
			query.unshift('@result');
		}else if (Utils.isValid(data.query)){
			query = ['@result', data.query];
		}
		if (data.then != null) {
			then = new Events(_type + ":success", data.then);
		}
		if (data.fail != null) {
			fail = new Events(_type + ":fail", data.fail);
		}
		id = data.id;
	}
	
	public function resolve(result:Bool, context:EventContext):Bool {
		++context.ident;
		if (result){
			if (then != null){
				then.run(context);
			}
		}else{
			if (fail != null){
				fail.run(context);
			}
		}
		--context.ident;
		return reverse ? !result : result;
	}
	
	public function willBreakOn(result:Bool):Bool {
		return _stopped || breakon == '*' || (result ? breakon == 'success' : breakon == 'fail');
	}
	
	public function release(result:Bool, context:EventContext):Void {
		if(_stopped){
			_stopped = false;
			resolve(result, context);
		}
	}
	
	public function connect():Void {
		_stopped = false;
	}
	
	public function disconnect():Void {
		_stopped = true;
	}
	
	public function length():Int {
		return query != null ? query.length - 1 : 0;
	}
	
}