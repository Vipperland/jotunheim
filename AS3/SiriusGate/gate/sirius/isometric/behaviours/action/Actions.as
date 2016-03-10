package gate.sirius.isometric.behaviours.action {
	
	import gate.sirius.isometric.behaviours.report.Report;
	import gate.sirius.isometric.data.BiomeEntry;
	import gate.sirius.isometric.matter.BiomeMatter;
	import gate.sirius.isometric.scenes.BiomeRoom;
	import gate.sirius.serializer.hosts.IList;
	
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public dynamic class Actions implements IList {
		
		private var _length:uint = 0;
		
		private var _canceled:Boolean;
		
		private var _target:Object;
		
		private var _entry:Object;
		
		
		public function Actions() {
		
		}
		
		
		/* INTERFACE gate.sirius.serializer.hosts.IList */
		
		public function get length():uint {
			return _length;
		}
		
		
		public function create(type:String, id:String, ... params:Array):void {
			var action:BasicAction = ActionList.create(id, type, params) as BasicAction;
			push(action);
		}
		
		
		public function push(value:*):uint {
			var action:BasicAction = value as BasicAction;
			if (action) {
				this[_length] = action;
				++_length;
			}
			return _length;
		}
		
		
		/* Class */
		
		public function remove(value:*):* {
			var i:uint = 0;
			var organize:int = 0;
			var found:Boolean;
			
			for (i = 0; i < _length; ++i) {
				if (organize) {
					this[i - organize] = this[i];
					continue;
				}
				if (value == this[i]) {
					++organize;
					found = true;
					delete this[i];
				}
			}
			
			if (found) {
				--_length;
			}
			
			return value;
		}
		
		
		public function execute(author:Object, location:BiomeEntry = null, room:BiomeRoom = null, matter:BiomeMatter = null, data:Object = null):void {
			
			if (!(author is Report)) {
				var report:Report = new Report(author, location, room, matter, data);
			}
			
			report.setCurrentPoint(this);
			
			var i:uint = 0;
			for each (var action:BasicAction in this) {
				if (action) {
					report.registerActionEntry(action);
					action.execute(report);
				}
				if (_canceled) {
					_canceled = false;
					break;
				}
			}
			_target = null;
			_entry = null;
		}
		
		
		public function stopPropagation():void {
			_canceled = true;
		}
		
		
		public function get from():Object {
			return _target;
		}
		
		public function toString():String {
			var s:String = "	Actions:\n";
			var i:uint = 0;
			for (i = 0; i < _length; ++i) {
				var a:BasicAction = this[i] as BasicAction;
				if (a) {
					s += "	" + a.toString() + "\n";
				}
			}
			return s;
		}
	
	}

}