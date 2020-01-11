package gate.sirius.meta.core {
	import flash.display.Stage;
	import flash.external.ExternalInterface;
	import gate.sirius.meta.Console;
	import gate.sirius.serializer.SruEncoder;
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public class EIDConsole {
		
		private var _target:*;
		
		private var _displayList:Array;
		
		private var _stage:Stage;
		
		
		public function EIDConsole(stage:Stage, target:Object = null) {
			_stage = stage;
			_target = target || {};
		}
		
		
		public function get root():Object {
			return _target;
		}
		
		
		public function get console():Console {
			return Console.getInstance();
		}
		
		
		public function get stage():Stage {
			return _stage;
		}
		
		
		public function expand():void {
			Console.expand();
		}
		
		
		public function hideMethods():void {
			Console.displayMethods = false;
		}
		
		
		public function showMethods():void {
			Console.displayMethods = true;
		}
		
		public function setLogMode():void {
			
		}
		
		public function setDevMode():void {
			
		}
		
		public function jscall(method:String = null, ...args:Array):Object {
			var r:Object;
			if (!method) {
				Console.pushErrorMsg("EIDIConsole.jscall method is required.");
			}else {
				Console.pushMedMsg("EIDIConsole[ExternalInterface:" + ExternalInterface.available + "] " + method + "(" + SruEncoder.encode(args) + ")");
				if (ExternalInterface.available) {
					args.unshift(method);
					r = ExternalInterface.call.apply(null, args);
				}else {
					if (_target != null) {
						if (_target.hasOwnProperty(method)) {
							try {
								r = _target[method].apply(this, args);
							}catch (e:Error) {
								Console.pushErrorMsg(e.getStackTrace());
							}
						}
					}else {
						Console.pushErrorMsg("EIDIConsole.jscall " + method + " not found.");
					}
				}
			}
			
			if (r != null){
				Console.pushObjMsg(Console.pushMedMsg, r);
			}
			return r;
		}
		
	}

}