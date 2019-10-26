package jotun.gaming.actions;
import jotun.objects.QueryGroup;
import js.html.Event;
import jotun.gaming.actions.RequirementQuery;
import jotun.tools.Utils;
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
@:expose("jtn.game.Requirement")
class Requirement extends Resolution {
	
	public static var commands:QueryGroup = new QueryGroup();
	
	public var cancelOnSuccess:Bool;
	public var cancelOnFail:Bool;
	public var reverse:Bool;
	public var target:Int;
	
	public function new(type:String, data:Dynamic) {
		super(type, data);
		cancelOnSuccess = data.cancelOnSuccess == true;
		cancelOnFail = data.cancelOnFail == true;
		reverse = data.reverse == true;
		target = Utils.isValid(data.target) ? Std.int(data.target) : (query != null ? query.length-1 : 0);
	}
	
	public function verify(context:IEventContext):Bool {
		var res:Bool = true;
		var score:UInt = 0;
		if (Utils.isValid(query)){
			var sec:Dynamic = commands.run(query).result;
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
			_log(this, context, res, score, reverse);
		}
		return res;
	}
	
	private static function _log(evt:Requirement, context:IEventContext, success:Bool, score:Int, reversed:Bool):Void {
		var s:String = "";
		while (s.length < context.ident){
			s += '	';
		}
		context.log.push(s + "↓ REQUIREMENT " + evt._type + " @" + (success ? "SUCCESS" : "FAIL") + (reversed ? " REVERSED" : "") + " score:" + score + "/" + evt.target + " queries:" + evt.length());
	}
	
	
}