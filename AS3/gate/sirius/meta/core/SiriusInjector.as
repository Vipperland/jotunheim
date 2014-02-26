package gate.sirius.meta.core {
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public dynamic class SiriusInjector extends SiriusObject {
		
		protected var _stage:Stage;
		protected var _refreshToken:Function;
		
		//public var siriusRules:SiriusEncoderRules;
		
		
		public function SiriusInjector(stage:Stage, refreshToken:Function) {
			_refreshToken = refreshToken;
			_stage = stage;
		}
		
		
		public function addchild(object:DisplayObject):void {
			_stage.addChild(object);
		}
		
		
		public function removechild(index:uint):void {
			_stage.removeChildAt(index);
		}
		
		
		public function refresh():void {
			_refreshToken();
		}
	
	}

}