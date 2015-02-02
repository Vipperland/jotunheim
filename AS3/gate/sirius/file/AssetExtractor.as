package gate.sirius.file {
	
	import flash.display.LoaderInfo;
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class AssetExtractor {
		
		static public function getClass(loaderInfo:LoaderInfo, className:String):Class {
			
			return loaderInfo.applicationDomain.getDefinition(className) as Class;
			
		}
		
		static public function getClassInstance(loaderInfo:LoaderInfo, className:String):* {
			
			var C:Class =  getClass(loaderInfo, className);
			return new C;
			
		}
		
	}

}