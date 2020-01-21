package gate.sirius.modloader.data {
	
	import gate.sirius.log.ULog;
	import gate.sirius.modloader.ModLoader;
	
	
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public class LoadOrder {
		
		private var _mods:Vector.<Mod>;
		
		private var _ids:Vector.<String>;
		
		private var _resources:ModLoader;
		
		
		public function LoadOrder(resources:ModLoader) {
			_resources = resources;
			_mods = new Vector.<Mod>();
			_ids = new Vector.<String>();
		}
		
		
		public function add(id:String, enabled:String):void {
			var mod:Mod = _resources.getMod(id);
			if (!mod) {
				ULog.GATE.pushWarning("Can't resolve Mod [" + id + "]");
				return;
			}
			mod.setStatus(enabled == "1" || enabled == "true");
			_mods[_mods.length] = mod;
		}
		
		
		public function iterate(handler:Function):void {
			if (!_mods) {
				return;
			}
			for each (var mi:Mod in _mods) {
				_ids.splice(_ids.indexOf(mi.id), 1);
				handler(mi.id, mi.enabled);
			}
			_mods = null;
		}
		
		
		public function register(mod:Mod):void {
			if (_ids.indexOf(mod.id) == -1){
				_ids[_ids.length] = mod.id;
			}
		}
		
		
		public function get unlisted():Vector.<String> {
			return _ids;
		}
	}
}