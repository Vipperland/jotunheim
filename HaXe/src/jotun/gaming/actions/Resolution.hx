package jotun.gaming.actions;
import haxe.extern.EitherType;
import jotun.tools.Utils;



/**
 * ...
 * @author Rim Project
 */
class Resolution {
	
	public static inline var BREAK_ALWAYS:String = "always";
	
	public static inline var BREAK_NEVER:String = "never";
	
	private var _type:String;
	
	public var id:String;
	
	public var query:Array<String>;
	
	public var then:Events;
	
	public var fail:Events;
	
	public var breakon:EitherType<String,Bool>;
	
	public var _stopped:Bool;
	
	public var reverse:Bool;
	
	public function new(type:String, data:Dynamic) {
		_type = type;
		reverse = Utils.boolean(data.reverse);
		breakon = data.breakon;
		if(Reflect.hasField(data, "*")){
			var qset:Dynamic = Reflect.field(data, "*");
			Reflect.deleteField(data, "*");
			if (Std.isOfType(qset, Array)){
				query = qset;
				query.unshift('@result');
			}else if (Utils.isValid(qset)){
				query = ['@result', qset];
			}
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
		if(_stopped || breakon == BREAK_ALWAYS){
			return true;
		}
		if(breakon == BREAK_NEVER){
			return false;
		}
		return breakon == result || (result && breakon == null);
	}
	
	/**
	 * Manual trigger to release the element to a new context
	 * @param	result
	 * @param	context
	 */
	public function release(result:Bool, context:EventContext):Void {
		if(_stopped){
			_stopped = false;
			resolve(result, context);
		}
	}
	
	/**
	 * Reset the state to connected
	 */
	public function connect():Void {
		_stopped = false;
	}
	
	/**
	 * A disconnected element will stop any propagation in the same context
	 * The user can create a proxy to stop and work with the current context flow and then connect() in any other context
	 */
	public function disconnect():Void {
		_stopped = true;
	}
	
	public function length():Int {
		return query != null ? query.length - 1 : 0;
	}
	
}