package gate.sirius.timer {
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	internal class ActiveObjectData {
		
		static private const junk:Vector.<ActiveObjectData> = new Vector.<ActiveObjectData>();
		
		static public function recycle(object:gate.sirius.timer.IActiveObject, queue:Vector.<gate.sirius.timer.IActiveObject>):ActiveObjectData {
			return (junk.length > 0 ? junk.pop() : new ActiveObjectData).setValues(object, queue);
		}
		
		public var object:gate.sirius.timer.IActiveObject;
		public var queue:Vector.<gate.sirius.timer.IActiveObject>;
		
		public function ActiveObjectData() {
		}
		
		public function setValues(object:gate.sirius.timer.IActiveObject, queue:Vector.<gate.sirius.timer.IActiveObject>):ActiveObjectData {
			this.object = object;
			this.queue = queue;
			return this;
		}
		
		public function discard():void {
			this.queue.splice(this.queue.indexOf(object), 1);
			this.object = null;
			this.queue = null;
			junk[junk.length] = this;
		}
	
	}

}