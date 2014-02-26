package gate.sirius.meta {
	import alchemy.vipperland.sirius.core.SiriusDecoder;
	import alchemy.vipperland.sirius.core.SiriusEncoder;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class Sirius {
		
		public static function encode(value:Object, filters:Object = null):String {
			return SiriusEncoder.getValue(value, filters, 0);
		}
		
		
		public static function decode(data:String, onParseComplete:Function = null, fillTarget:* = null):SiriusDecoder {
			return SiriusDecoder.parse(data, onParseComplete, fillTarget);
		}
		
		
		public static function registerClass(... classList:Array):void {
			SiriusDecoder.registerClass.apply(null, classList);
		}
		
		
		public static function getRegisteredClass(className:String):Class {
			return SiriusDecoder.getRegisteredClass(className);
		}
		
		
		public static function getClassCollection():Dictionary {
			return SiriusDecoder.getClassCollection();
		}
		
		
		public static function getEnvironment(path:String):* {
			return SiriusDecoder.getEnvironment(path);
		}
	
	}

}