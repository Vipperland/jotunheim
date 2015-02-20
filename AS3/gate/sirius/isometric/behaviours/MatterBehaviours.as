package gate.sirius.isometric.behaviours {
	import gate.sirius.isometric.behaviours.action.Actions;
	import gate.sirius.isometric.matter.BiomeMatter;
	import gate.sirius.isometric.scenes.BiomeRoom;
	import gate.sirius.timer.IActiveController;
	
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class MatterBehaviours extends Behaviours {
		
		/** @private */
		private var _move:Actions;
		
		/** @private */
		private var _added:Actions;
		
		/** @private */
		private var _removed:Actions;
		
		/** @private */
		private var _aproach:Actions;
		
		/** @private */
		private var _deviate:Actions;
		
		/** @private */
		private var _interact:Actions;
		
		/** @private */
		private var _tick:Actions;
		
		
		public function MatterBehaviours(origin:Object) {
			super(origin);
			_move = new Actions();
			_added = new Actions();
			_removed = new Actions();
			_aproach = new Actions();
			_deviate = new Actions();
			_interact = new Actions();
			_tick = new Actions();
		}
		
		
		public function onMove(room:BiomeRoom, data:Object = null):void {
			_move.execute(matter, matter.tile, room, null, data);
		}
		
		
		public function get move():Actions {
			return _move;
		}
		
		
		public function onAdded(room:BiomeRoom, data:Object = null):void {
			_added.execute(matter, null, room, null, data);
		}
		
		
		public function get added():Actions {
			return _added;
		}
		
		
		public function onRemoved(room:BiomeRoom, data:Object = null):void {
			_removed.execute(matter, null, room, null, data);
		}
		
		
		public function get removed():Actions {
			return _removed;
		}
		
		
		public function onApproach(target:BiomeMatter, room:BiomeRoom, data:Object = null):void {
			_aproach.execute(matter, null, room, target, data);
		}
		
		
		public function get aproach():Actions {
			return _aproach;
		}
		
		
		public function onDeviate(target:BiomeMatter, room:BiomeRoom, data:Object = null):void {
			_deviate.execute(matter, null, room, target, data);
		}
		
		
		public function get deviate():Actions {
			return _deviate;
		}
		
		
		public function onInteract(target:BiomeMatter, room:BiomeRoom, data:Object = null):void {
			_deviate.execute(matter, null, room, target, data);
		}
		
		
		public function get interact():Actions {
			return _interact;
		}
		
		
		public function onTick(data:IActiveController):void {
			_tick.execute(matter, null, null, null, data);
		}
		
		
		public function get tick():Actions {
			return _tick;
		}
		
		
		public function get matter():BiomeMatter {
			return _targetOrigin as BiomeMatter;
		}
		
		
		override public function clone():Behaviours {
			var behaviour:MatterBehaviours = new MatterBehaviours(_targetOrigin);
			behaviour._move = _move;
			behaviour._added = _added;
			behaviour._removed = _removed;
			behaviour._aproach = _aproach;
			behaviour._deviate = _deviate;
			behaviour._interact = _interact;
			behaviour._tick = _tick;
			return behaviour;
		}
	
	}

}