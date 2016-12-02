package gate.sirius.timer {
	
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	internal class ActiveObjectPool {
		
		public var queue:Vector.<Vector.<IActiveObject>>;
		
		public var size:int;
		
		public var current:int;
		
		public var nextPush:int;
		
		
		public function ActiveObjectPool(size:int) {
			this.size = size;
			queue = new Vector.<Vector.<IActiveObject>>();
			var i:int = 0;
			while (i < size) {
				queue[i] = new Vector.<IActiveObject>();
				++i;
			}
			current = 0;
			nextPush = -1;
		}
		
		
		public function add(object:IActiveObject):ActiveObjectData {
			return ActiveObjectData.recycle(object, getQueue());
		}
		
		
		private function getQueue():Vector.<IActiveObject> {
			if (++nextPush == this.size) {
				nextPush = 0;
			}
			return this.queue[nextPush];
		}
		
		
		public function tick(time:Number):void {
			
			var vec:Vector.<IActiveObject> = this.queue[current];
			
			var i:int = 0;
			var t:int = vec.length;
			
			for (i; i < t; ++i) {
				vec[i].tick(time);
			}
			
			if (++current >= size) {
				current = 0;
			}
		}
		
		public function dispose():void {
			queue = null;
		}
	
	}

}
