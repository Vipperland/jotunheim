package gate.sirius.signals {
	import gate.sirius.isometric.recycler.IRecyclable;
	import gate.sirius.isometric.recycler.Recycler;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class SignalTicket implements IRecyclable {
		
		internal var _signal:ISignal;
		
		internal var _arguments:Array;
		
		public function SignalTicket() {
		
		}
		
		public function get signal():ISignal {
			return _signal;
		}
		
		public function get arguments():Array {
			return _arguments;
		}
		
		public function dispose():void {
			_signal = null;
			_arguments = null;
			Recycler.GATE.dump(this);
		}
		
		/* INTERFACE gate.sirius.isometric.recycler.IRecyclable */
		
		public function recyclerDump():void {
		
		}
		
		public function recyclerCollect(... args:Array):void {
		
		}
	
	}

}