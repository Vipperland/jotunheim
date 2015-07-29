package sirius.transitions;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Tween {

	public static function stopAll():Dynamic {
		return untyped __js__("Tween.killAll()");
	}
	
	public static function stop(o:Dynamic):Dynamic {
		return untyped __js__("Tween.killTweensOf(o)");
	}
	
	public static function isActive():Bool {
		return untyped __js__("Tween.isTweening()");
	}
	
	public static function to(o:Dynamic, time:Float, transform:Dynamic):Dynamic {
		return untyped __js__("Tween.to(o,time,transform)");
	}
	
	public static function from(o:Dynamic, time:Float, transform:Dynamic):Dynamic {
		return untyped __js__("Tween.from(o,time,transform)");
	}
	
	public static function fromTo(o:Dynamic, time:Float, transformFrom:Dynamic, transformTo:Dynamic):Dynamic {
		return untyped __js__("Tween.from(o,time,transformFrom,transformTo)");
	}
	
	public static function stagTo(o:Array<Dynamic>, time:Float, transform:Dynamic, stagger:Float, ?complete:Dynamic, ?args:Array<Dynamic>, ?scope:Dynamic):Dynamic {
		return untyped __js__("Tween.staggerTo(o,time,transform,stagger,complete,args,scope)");
	}
	
	public static function stagFrom(o:Array<Dynamic>, time:Float, transform:Dynamic, stagger:Float, ?complete:Dynamic, ?args:Array<Dynamic>, ?scope:Dynamic):Dynamic {
		return untyped __js__("Tween.staggerFrom(o,time,transform,stagger,complete,args,scope)");
	}
	
	public static function stagFromTo(o:Dynamic, time:Float, transformFrom:Dynamic, transformTo:Dynamic, stagger:Float, ?complete:Dynamic, ?args:Array<Dynamic>, ?scope:Dynamic):Dynamic {
		return untyped __js__("Tween.from(o,time,transformFrom,transformTo,stagger,complete,args,scope)");
	}
	
}