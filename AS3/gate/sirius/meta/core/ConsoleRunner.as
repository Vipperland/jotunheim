package gate.sirius.meta.core {
	import gate.sirius.meta.Console;
	
	
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public class ConsoleRunner {
		
		private var _target:*;
		
		private var _displayList:Array;
		
		
		public function get root():Object {
			return _target;
		}
		
		public function get console():Console {
			return Console.getInstance();
		}
		
		
		public function ConsoleRunner(target:*) {
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