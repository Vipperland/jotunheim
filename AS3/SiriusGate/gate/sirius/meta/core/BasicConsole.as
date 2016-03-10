package gate.sirius.meta.core {
	import flash.display.Stage;
	import gate.sirius.meta.Console;
	
	
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public class BasicConsole {
		
		private var _target:*;
		
		private var _displayList:Array;
		
		private var _stage:Stage;
		
		
		public function get root():Object {
			return _target;
		}
		
		
		public function get console():Console {
			return Console.getInstance();
		}
		
		
		public function get stage():Stage {
			return _stage;
		}
		
		
		public function BasicConsole(stage:Stage, target:*) {
			_stage = stage;
			_target = target;
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
	
	}

}