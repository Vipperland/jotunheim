package gate.sirius.meta.core {
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class SiriusLink extends SiriusObject implements ISiriusLink {
		
		private var _commands:Array;
		
		private function _getIdent(count:int):String {
			var r:String = "";
			while (r.length < count) r += "	";
			return r;
		}
		
		public function SiriusLink() {
			_commands = new Array();
		}
		
		public function runCommand(name:String, ...params:Array):void {
			_commands[_commands.length] = new Array(name, params);
		}
		
		public function getCommands():Array {
			return _commands;
		}
		
		public function dumpCommands(identSize:int = 1):String {
			var ident:String = _getIdent(identSize);
			var r:String = "";
			for each(var command:Array in _commands) {
				var params:Array = command[1];
				r += ident;
				r += "~" + command[0] + "(";
				if (params) {
					r += "\r\n";
					for each(var param:* in params) {
						r += ident + '	';
						if(param is String || param is Number || param is Boolean || !param ) r += param.toString() + "\r\n";
						else r += SiriusEncoder.getValue(param, identSize + 1) + "\r\n";
					}
					r += ident;
				}
				r += ")\r\n";
			}
			return r;
		}
		
	}

}