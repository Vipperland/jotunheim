package gate.sirius.isometric.recycler {
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class RecycledObject implements IRecycledObject {
		
		/** @private */
		private var _content:*;
		
		/** @private */
		internal final function put(content:IRecyclable):IRecycledObject {
			_content = content;
			return this;
		}
		
		public function RecycledObject() {
		
		}
		
		/**
		 * Merge properties into recycled object
		 * @param	... properties
		 * @return
		 */
		public final function flush(... properties:Array):* {
			for each (var o:Object in properties) {
				for (var p:String in o) {
					_content[p] = o[p];
				}
			}
			return content;
		}
		
		/**
		 * Call object function width custom arguments
		 * @param	method
		 * @param	... args
		 * @return
		 */
		public final function call(method:String, ... args:Array):IRecycledObject {
			_content[method].apply(_content, args);
			return this;
		}
		
		/**
		 * Call object function width custom arguments
		 * @param	method
		 * @param	args
		 * @return
		 */
		public final function call2(method:String, args:Array):IRecycledObject {
			_content[method].apply(_content, args);
			return this;
		}
		
		/**
		 * One time only access to recycled object
		 */
		public final function get content():* {
			var t:* = _content;
			_content = null;
			return t;
		}
	
	}

}