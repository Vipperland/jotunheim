package sirius.transitions;
import haxe.ds.StringMap;
import sirius.dom.IDisplay;
import sirius.tools.Utils;
import sirius.utils.Dice;
import sirius.transitions.ITween;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("Animator")
class Animator {
	
	/**
	 * Check if any default tween is available
	 */
	public static var available:Bool = untyped __js__("window.Tween != null || window.TweenMax != null || window.TweenLite != null");
	
	/**
	 * Default Tween engine
	 */
	public static var tweenObject:Dynamic = untyped __js__("window.Tween || window.TweenMax || window.TweenLite");
	
	/**
	 * Current ClassName of active animation engine
	 */
	public static function getName():String {
		return Utils.getClassName(tweenObject);
	}
	
	/** @private */
	private static function get(o:Dynamic):Dynamic {
		return o != null && Std.is(o, IDisplay) ? o.element : o;
	}
	
	/**
	 * Add a Delayed Call
	 * @param	time
	 * @param	handler
	 * @param	params
	 * @param	scope
	 * @param	frame
	 * @return
	 */
	public static function call(time:Float, handler:Dynamic, ?params:Array<Dynamic>, ?scope:Dynamic, ?frame:Bool):ITween {
		return available ? tweenObject.delayedCall(time, handler, params, scope, frame) : null;
	}
	
	/**
	 * Get all Tweens or an object tweens
	 * @param	o		true for all tweens or an target for object only tweens
	 * @param	act		get only activated tween
	 * @return
	 */
	public static function all(?o:Dynamic = true, ?act:Bool = false):Array<ITween> {
		o = get(o);
		return available ? (o == true ? tweenObject.getAllTweens(act) : o != null ? tweenObject.getTweensOf(o,act) : []) : [];
	}
	
	/**
	 * 
	 * Stop all the tweens of an object only tweens
	 * @param	o		true for all tweens or an target for object only tweens 
	 * @param	child
	 * @return
	 */
	public static function stop(o:Dynamic = true, ?child:Bool = false):ITween {
		o = get(o);
		return available ? (o == true ? tweenObject.killAll() : o != null ? (child ? tweenObject.killChildTweensOf(o) : tweenObject.killTweensOf(o)) : null) : null;
	}
	
	/**
	 * Pause all Tweens
	 * @return
	 */
	public static function pause():ITween {
		return available ? tweenObject.pauseAll() : null;
	}
	
	/**
	 * Resume all tweens
	 * @return
	 */
	public static function resume():ITween {
		return available ? tweenObject.resumeAll() : null;
	}
	
	/**
	 * Tells if an object as a active tween
	 * @param	o
	 * @return
	 */
	public static function isActive(o:Dynamic):Bool {
		o = get(o);
		return available ? tweenObject.isTweening(o) : false;
	}
	
	/**
	 * Animate object to target
	 * @param	o
	 * @param	time
	 * @param	transform
	 * @return
	 */
	public static function to(o:Dynamic, time:Float, transform:Dynamic):ITween {
		o = get(o);
		return available ? tweenObject.to(o,time,transform) : null;
	}
	
	/**
	 * Animate object from target to current object properties
	 * @param	o
	 * @param	time
	 * @param	transform
	 * @return
	 */
	public static function from(o:Dynamic, time:Float, transform:Dynamic):ITween {
		o = get(o);
		return available ? tweenObject.from(o,time,transform) : null;
	}
	
	/**
	 * Animate object from target to another target
	 * @param	o
	 * @param	time
	 * @param	transformFrom
	 * @param	transformTo
	 * @return
	 */
	public static function fromTo(o:Dynamic, time:Float, transformFrom:Dynamic, transformTo:Dynamic):ITween {
		o = get(o);
		return available ? tweenObject.from(o,time,transformFrom,transformTo) : null;
	}
	
	/**
	 * Animate a group of objects adding a delay from one to another
	 * @param	o
	 * @param	time
	 * @param	transform
	 * @param	stagger
	 * @param	complete
	 * @param	args
	 * @param	scope
	 * @return
	 */
	public static function stagTo(o:Array<Dynamic>, time:Float, transform:Dynamic, stagger:Float, ?complete:Dynamic, ?args:Array<Dynamic>, ?scope:Dynamic):ITween {
		Dice.All(o, function(p:Int, v:Dynamic) { o[p] = get(v); } );
		return available ? tweenObject.staggerTo(o,time,transform,stagger,complete,args,scope) : null;
	}
	
	/**
	 * Animate a group of objects adding a delay from one to another
	 * @param	o
	 * @param	time
	 * @param	transform
	 * @param	stagger
	 * @param	complete
	 * @param	args
	 * @param	scope
	 * @return
	 */
	public static function stagFrom(o:Array<Dynamic>, time:Float, transform:Dynamic, stagger:Float, ?complete:Dynamic, ?args:Array<Dynamic>, ?scope:Dynamic):ITween {
		Dice.All(o, function(p:Int, v:Dynamic) { o[p] = get(v); } );
		return available ? tweenObject.staggerFrom(o,time,transform,stagger,complete,args,scope) : null;
	}
	
	/**
	 * Animate a group of objects adding a delay from one to another
	 * @param	o
	 * @param	time
	 * @param	transformFrom
	 * @param	transformTo
	 * @param	stagger
	 * @param	complete
	 * @param	args
	 * @param	scope
	 * @return
	 */
	public static function stagFromTo(o:Dynamic, time:Float, transformFrom:Dynamic, transformTo:Dynamic, stagger:Float, ?complete:Dynamic, ?args:Array<Dynamic>, ?scope:Dynamic):ITween {
		Dice.All(o, function(p:Int, v:Dynamic) { o[p] = get(v); } );
		return available ? tweenObject.staggerFromTo(o,time,transformFrom,transformTo,stagger,complete,args,scope) : null;
	}
	
	/**
	 * Global Time Scale of running tweens and calls
	 * @param	o
	 * @return
	 */
	public static function timeScale(?o:Float):Float {
		return available ? tweenObject.globalTimeScale(o) : 0;
	}
	
	/**
	 * Apply transform in a object with 0 second duration
	 * @param	o
	 * @param	transform
	 * @return
	 */
	public static function set(o:Dynamic, transform:Dynamic):ITween {
		o = get(o);
		return available && o != null ? tweenObject.set(o, transform) : null;
	}
	
	
}