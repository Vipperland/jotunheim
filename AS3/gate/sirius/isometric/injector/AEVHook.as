package gate.sirius.isometric.injector {
	import gate.sirius.isometric.injector.behaviours.Behaviour;
	import gate.sirius.isometric.injector.behaviours.IBehaviour;
	import alchemy.vipperland.sirius.Console;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class AEVHook {
		
		public static const ACTIONS:Dictionary = new Dictionary(true);
		public static const BEHAVIOURS:Dictionary = new Dictionary(true);
		public static const VERIFIERS:Dictionary = new Dictionary(true);
		
		
		public function AEVHook() {
		
		}
		
		
		public final function getAction(id:String, modId:String, allowOverride:Boolean = false):IAction {
			return new Action(id, modId, allowOverride);
		}
		
		
		/**
		 *
		 * @param	id
		 * @param	modId
		 * @param	allowOverride
		 * @return
		 */
		public final function getBehaviour(id:String, modId:String = "absolute", allowOverride:Boolean = false):IBehaviour {
			
			if (!id || id.length < 5) {
				Console.pushErrorMessage("AEVHook::getBehaviour, missing or invalid ID (must contain at last 5 chars)");
				return null;
			} else if (!modId || modId.length < 5) {
				Console.pushErrorMessage("AEVHook::getBehaviour, missing or invalid MODID (must contain at last 5 chars)");
				return null;
			}
			
			var curr:IBehaviour = ACTIONS[id];
			
			if (curr) {
				if (allowOverride) {
					Console.pushWarningMessage("Behaviour[" + id + "#" + curr.owner + "] overrided by " + modId);
					curr = null;
				} else {
					Console.pushWarningMessage("Behaviour[" + id + "#" + curr.owner + "] already exists and isn't marked to override");
				}
			}
			if (!curr) {
				Console.pushWarningMessage("Behaviour[" + id + "#" + curr.owner + "] registered");
				curr = new Behaviour(id, modId);
			}
			
			ACTIONS[curr.id] = curr;
		}
		
		
		public final function getVerifier(id:String, modId:String, allowOverride:Boolean = false):IVerifier {
			return new Verifier(id, modId, allowOverride);
		}
	
	}

}