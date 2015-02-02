package gate.sirius.timer {
	
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	internal class DelayedCallToken {
		
		static private const junk:Vector.<DelayedCallToken> = new Vector.<DelayedCallToken>();
		
		static public function recycle(handler:Function, delay:int, count:int, parameters:Array):DelayedCallToken {
			return (junk.length > 0 ? junk.pop() : new DelayedCallToken).setValues(handler, delay, count, parameters);
		}
		
		internal var handler:Function;
		internal var delay:int;
		internal var count:int;
		internal var parameters:Array;
		internal var id:uint;
		
		public function DelayedCallToken() {
		}
		
		internal function setValues(handler:Function, delay:int, count:int, parameters:Array):DelayedCallToken {
			this.delay = delay;
			this.handler = handler;
			this.count = count;
			this.parameters = parameters;
			check();
			return this;
		}
		
		internal function check():void {
			if (count >= 0) {
				--count;
				id = setTimeout(call, delay);
			} else {
				discard();
			}
		}
		
		internal function call():void {
			this.handler.apply(null, parameters);
			check();
		}
		
		internal function cancel():void {
			clearInterval(id);
			discard();
		}
		
		internal function discard():void {
			this.handler = null;
			this.count = 0;
			this.parameters = null;
		}
	
	}

}