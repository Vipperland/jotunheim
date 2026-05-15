package jotun.gaming.actions;
import haxe.DynamicAccess;
import haxe.extern.EitherType;
import jotun.tools.Utils;

/**
 * ...
 * @author Rim Project
 */
class Resolution {

	public static inline var BREAK_ALWAYS:String = "always";

	public static inline var BREAK_NEVER:String = "never";

	public static inline var QUERY_PARAM_ACTION:String = "@";

	public static inline var QUERY_PARAM_REQUIREMENT:String = "*";

	public static inline var QUERY_RESULT_MARKER:String = "@result";

	private var _type:String;

	public var id:String;

	public var query:Array<String>;

	public var then:SpellGroup;

	public var fail:SpellGroup;

	public var breakon:EitherType<String,Bool>;

	public var _stopped:Bool;

	public var reverse:Bool;

	public function new(type:String, data:Dynamic, param:String) {
		_type = type;
		reverse = Utils.boolean(data.reverse);
		breakon = data.breakon;
		var d:DynamicAccess<Dynamic> = cast data;
		if(d.exists(param)){
			var qset:Dynamic = d.get(param);
			d.remove(param);
			if (Std.isOfType(qset, Array)){
				query = qset;
				query.unshift(QUERY_RESULT_MARKER);
			}else if (Utils.isValid(qset)){
				query = [QUERY_RESULT_MARKER, qset];
			}
		}
		if (data.then != null) {
			then = new SpellGroup(_type + ":then", data.then);
		}
		if (data.fail != null) {
			fail = new SpellGroup(_type + ":fail", data.fail);
		}
		id = data.id;
	}

	public function isInterrupted():Bool {
		return _stopped;
	}

	public function resolve(result:Bool, context:SpellCasting):Bool {
		if(!_stopped){
			++context.ident;
			if (result){
				if (then != null){
					then.execute(context);
				}
			}else{
				if (fail != null){
					fail.execute(context);
				}
			}
			--context.ident;
		}
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
	public function release(result:Bool, context:SpellCasting):Void {
		if(_stopped){
			_stopped = false;
			context.release(this, result);
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
