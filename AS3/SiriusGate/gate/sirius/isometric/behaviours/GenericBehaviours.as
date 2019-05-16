package gate.sirius.isometric.behaviours {
	import flash.utils.Dictionary;
	import gate.sirius.isometric.behaviours.action.Actions;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class GenericBehaviours extends Behaviours {
		
		private var _collection:Dictionary;
		
		public function GenericBehaviours(origin:Object = null) {
			_collection = new Dictionary(true);
			super(origin);
		}
		
		public function register(id:uint, actions:Actions):Actions {
			_collection[id] = actions;
			return actions;
		}
		
		public function unregister(id:uint):void {
			delete _collection[id];
		}
		
		public function run(id:uint, entryPoint:Object):void {
			var actions:Actions = _collection[id] as Actions;
			if (actions) {
				actions.execute(_targetOrigin, entryPoint);
			} else {
				// TODO: Actions behaviour not found signal
			}
		}
	
	}

}