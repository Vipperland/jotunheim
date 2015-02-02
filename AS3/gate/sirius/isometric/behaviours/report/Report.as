package gate.sirius.isometric.behaviours.report {
	import flash.utils.getTimer;
	import gate.sirius.isometric.behaviours.action.Actions;
	import gate.sirius.isometric.behaviours.action.BasicAction;
	import gate.sirius.isometric.behaviours.verifiers.BasicVerifier;
	import gate.sirius.isometric.data.BiomeEntry;
	import gate.sirius.isometric.matter.BiomeMatter;
	import gate.sirius.isometric.scenes.BiomeRoom;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class Report {
		
		private var _room:BiomeRoom;
		
		private var _matter:BiomeMatter;
		
		private var _location:BiomeEntry;
		
		private var _carryData:Object;
		
		private var _history:Array;
		
		private var _startTime:int;
		
		private var _lastEntryTime:int;
		
		private var _resolvedTime:int;
		
		private var _resolved:Boolean;
		
		private var _lastVerifier:ReportVerifierLog;
		
		private var _author:Object;
		
		private var _currentPoint:Actions;
		
		public function Report(author:Object, location:BiomeEntry, room:BiomeRoom, matter:BiomeMatter, carryData:Object) {
			_author = author;
			_location = location;
			_room = room;
			_matter = matter;
			_carryData = carryData;
			_history = [];
			_startTime = getTimer();
			_resolved = false;
		}
		
		public function registerActionEntry(action:BasicAction):void {
			_lastEntryTime = getTimer();
			_history[_history.length] = new ReportActionLog(action, _resolvedTime - _lastEntryTime);
			_resolvedTime = _lastEntryTime;
		}
		
		public function registerMissingAction(id:String):void {
			_history[_history.length] = new ReportMissingObject("action", id);
		}
		
		public function registerVerifierEntry(verifier:BasicVerifier):Boolean {
			_lastEntryTime = getTimer();
			_lastVerifier = new ReportVerifierLog(verifier, _resolvedTime - _lastEntryTime);
			_history[_history.length] = _lastVerifier;
			_resolvedTime = _lastEntryTime;
			return _lastVerifier.link(this);
		}
		
		public function registerMissingVerifier(id:String):void {
			_history[_history.length] = new ReportMissingObject("verifier", id);
		}
		
		public function resolve():void {
			_resolved = true;
			_resolvedTime = getTimer();
		}
		
		public function dispose():void {
			_room = null;
			_matter = null;
			_location = null;
			_history = null;
			_currentPoint = null;
		}
		
		public function setCurrentPoint(actions:Actions):void {
			_currentPoint = actions;
		}
		
		public function get lifeSpan():int {
			return _resolvedTime - _startTime;
		}
		
		public function get startTime():int {
			return _startTime;
		}
		
		public function get resolvedTime():int {
			return _resolvedTime;
		}
		
		public function get history():Array {
			return _history;
		}
		
		public function get lastVerifier():ReportVerifierLog {
			return _lastVerifier;
		}
		
		public function get carryData():Object {
			return _carryData;
		}
		
		public function get author():Object {
			return _author;
		}
		
		public function get matter():BiomeMatter {
			return _matter;
		}
	
	}

}