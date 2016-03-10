package gate.sirius.signals {
	import gate.sirius.isometric.recycler.IRecyclable;
	import gate.sirius.isometric.recycler.Recycler;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class Signal implements ISignal, IRecyclable {
		
		/** @private */
		internal var _dispatcher:SignalDispatcher;
		
		/** @private */
		internal var _contructor:Function;
		
		/** @private */
		internal var _live:Boolean;
		
		/** @private */
		internal var _calls:uint;
		
		/** @private */
		protected final function _resolveHandler(... list:Array):Function {
			for each (var entry:*in list) {
				if (entry is Function) {
					return entry as Function;
				}
			}
			return function(... args:Array):void {
			};
		}
		
		/**
		 * Create a new default Signal
		 * @param	contructor
		 */
		public function Signal(constructor:Function = null) {
			_contructor = _resolveHandler(constructor);
		}
		
		/**
		 * The current dispatcher
		 */
		public final function get dispatcher():SignalDispatcher {
			return _dispatcher;
		}
		
		/**
		 * Current propagation count
		 */
		public final function get callCount():uint {
			return _calls;
		}
		
		/**
		 * Destroy or send instance to Recycler
		 * @param	recyclable
		 */
		public function dispose(recyclable:Boolean):void {
			if (recyclable) {
				Recycler.GATE.dump(this);
			}
		}
		
		/**
		 * Interrupts the signal propagation
		 */
		public final function stopPropagation():void {
			_live = false;
		}
		
		/* INTERFACE gate.sirius.isometric.recycler.IRecyclable */
		
		public function recyclerDump():void {
			_dispatcher = null;
		}
		
		public function recyclerCollect(... args:Array):void {
		
		}
	
	}

}