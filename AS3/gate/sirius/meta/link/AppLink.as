package gate.sirius.meta.link {
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	/**
	 * ...
	 * @author Rafael Moreira (GateOfSirius)
	 */
	public class AppLink {
		
		private var _loaderContext:LoaderContext;
		
		public function AppLink(loaderContext:LoaderContext) {
			_loaderContext = loaderContext;
			
		}
		
		public function addApplication(name:String, url:*):void {
			
		}
		
	}

}