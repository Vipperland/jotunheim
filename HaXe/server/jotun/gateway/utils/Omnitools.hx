package jotun.gateway.utils;
import jotun.math.JMath;
import jotun.serial.Packager;
import jotun.tools.Key;
import jotun.gateway.domain.Output;

/**
 * ...
 * @author 
 */
class Omnitools {

	/**
	 * Servertime
	 * @return
	 */
	static public function timeNow():Float {
		return Date.now().getTime();
	}
	
	/**
	 * Servertime + hours offset
	 * @param	hours
	 * @return
	 */
	static public function timeFromNow(hours:Float):Float {
		return timeNow() + (hours * 360000);
	}
	
	/**
	 * Create a unique random 32 length string
	 * @return
	 */
	static public function genRandomIDx65():String {
		return Packager.md5Encode(Key.GEN(32)) + "." + Packager.md5Encode(timeNow());
	}
	
	/**
	 * Create a unique random 32 length string
	 * @return
	 */
	static public function genRandomIDx32():String {
		return Packager.md5Encode(Key.GEN(16) + "." + timeNow());
	}
	
	/**
	 * If elapsed date is greater or equal to 18 years
	 * @param	time
	 * @return
	 */
	static public function testBirthdate(time:Float):Bool {
		return JMath.calcAge(time) >= 18;
	}
	
	/**
	 * Conver a DD/MM/AAAA date format to unixtime
	 * @param	date
	 * @return
	 */
	static public function dmYToUnixtime(date:String):Float {
		if (date != null && date.length == 10){
			var darr:Array<String> = date.split("/").join("-").split("-");
			if (darr[0].length != 4){
				darr.reverse();
			}
			date = darr.join("-");
			return Date.fromString(date).getTime();
		}else {
			return 0;
		}
	}
	
}