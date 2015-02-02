package gate.sirius.serializer.data {
	
	
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public class SruComm {
		
		private var _queries:Object;
		
		private var _calls:Object;
		
		
		public function SruComm() {
			_queries = {};
			_calls = {};
		}
		
		
		public function query(name:String, ... properties:Array):void {
			_queries[name] = properties.join(" ");
		}
		
		
		public function call(name:String, ... properties:Array):void {
			_calls[name] = properties;
		}
		
		
		public function cancelQuery(name:String):void {
			delete _queries[name];
		}
		
		
		public function cancelCall(name:String):void {
			delete _calls[name];
		}
		
		
		public function getData(ident:uint = 0):String {
			return "";
		}
	
	}

}