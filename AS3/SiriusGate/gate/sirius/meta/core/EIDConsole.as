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
		
		public function EIDConsole() {}
		
		public function jscall(method:String = null, ...args:Array):Object {
			var r:Object;
			if (!method) {
				Console.pushErrorMsg("EIDIConsole.jscall method is required.");
			}else {
				Console.pushMedMsg("EIDIConsole[" + ExternalInterface.available + "] " + method + "(" + SruEncoder.encode(args) + ")");
				if (ExternalInterface.available) {
					args.unshift(method);
					r = ExternalInterface.call.apply(null, args);
				}else {
					if (this.hasOwnProperty(method)) {
						try {
							r = _target[method].apply(this, args);
						}catch (e:Error) {
							Console.pushErrorMsg(e.getStackTrace());
						}
					} else {
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