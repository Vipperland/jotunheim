package jotun.math;

/**
 * ...
 * @author 
 */
@:expose("J_Math")
class JMath {
	
	public static function Sigmoid(x:Float):Float {
		return 1 / (1 + Math.exp( -x));
	}
	
	public static function calcAge(date:Dynamic):Int {
		var a:Float = Date.now().getTime();
		var b:Float = (Std.isOfType(date, String) ? Date.fromString(date.split('/').join('-')) : Date.fromTime(date)).getTime();
		return ~~(cast (a - b) / 31557600000);
		// ~~((DateTime.Now-DateTime.Parse("yyyy-mm-dd")) / 31557600000)
	}
	
	static public function isBetween(o:Dynamic, min:Int, max:Int):Bool {
		if(o != null){
			if (!Std.isOfType(o, Float)){
				if (Std.isOfType(o, Array) || Std.isOfType(o, String)){
					o = o.length;
				}else{
					return false;
				}
			}
		}else{
			return false;
		}
		if (max == null){
			return o >= min;
		}else if (min == null){
			return o <= max;
		}else{
			return o >= min && o <= max;
		}
	}
	
}