package jotun.gaming.actions;
import jotun.objects.QueryGroup;
import js.html.Event;
import jotun.tools.Utils;
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
@:expose("J_Requirement")
class Requirement extends Resolution {
	
	public static var cache:Dynamic = {};
	public static function get(id:String):Resolution {
		return cast Reflect.field(cache, id);
	}
	
	public static var commands:RequirementQueryGroup = new RequirementQueryGroup();
	
	public var cancelOnSuccess:Bool;
	public var cancelOnFail:Bool;
	public var reverse:Bool;
	public var target:Int;
	
	public function new(type:String, data:Dynamic) {
		super(type, data);
		cancelOnSuccess = Utils.boolean(data.cancelOnSuccess);
		cancelOnFail = Utils.boolean(data.cancelOnFail);
		reverse = Utils.boolean(data.reverse);
		target = Std.int(data.target);
		if (target == null){
			target = (query != null ? query.length - 1 : 0);
		}
		if (Utils.isValid(data.id)){
			Reflect.setField(cache, data.id, this);
		}
	}
	
	public function verify(context:IEventContext, position:Int):Bool {
		var res:Bool = true;
		var score:UInt = 0;
		if (Utils.isValid(query)){
			var sec:Dynamic = commands.eventRun(query, context).result;
			if(sec != null){
				Dice.Values(sec, function(v:Dynamic){
					if (Utils.boolean(v)){
						++score;
					}
				});
			}
			res = score >= target;
			if (reverse){
				res = !res;
			}
		}
		resolve(res, context);
		if (context.debug){
			_log(this, context, res, score, reverse, position);
		}
		return res;
	}
	
	private static function _log(evt:Requirement, context:IEventContext, success:Bool, score:Int, reversed:Bool, position:Int):Void {
		if (context.log != null){
			var s:String = "";
			while (s.length < context.ident){
				s += '	';
			}
			context.log.push(s + "↓ " + (success ? "SUCCESS" : "FAIL") + " REQUIREMENT " + (Utils.isValid(evt.id) ? '#{' + evt.id + '} ': ' ') + "[" + position + "]" + (reversed ? " REVERSED" : "") + " score:" + score + "/" + evt.target + " queries:" + evt.length());
		}
	}
	
	
}