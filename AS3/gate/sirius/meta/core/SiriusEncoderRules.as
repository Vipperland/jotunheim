package gate.sirius.meta.core {
	
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class SiriusEncoderRules {
		
		private var _table:Object;
		
		private var _injections:Vector.<String>;
		
		private var _injectionsByProp:Dictionary;
		
		private var _isBuilt:Boolean;
		
		public var noSort:Boolean;
		
		public var weak:Boolean;
		
		public function SiriusEncoderRules(noSort:Boolean = false, weak:Boolean = false) {
			this.weak = weak;
			this.noSort = noSort;
			clear();
		}
		
		public function verify(propertyName:String):Boolean {
			if (weak)
				if (!_table.hasOwnProperty(propertyName))
					return true;
			return _table[propertyName] == true;
		}
		
		public function clear():void {
			_table = {siriusRules: false};
			_injections = new Vector.<String>();
			_injectionsByProp = new Dictionary(true);
		}
		
		public function setProperty(prop:String, visible:Boolean = true):void {
			_table[prop] = visible;
		}
		
		public function removeInjection(prop:String):String {
			var i:int = 0;
			var a:int = -1;
			while (i < _injections.length) {
				var str:String = _injections[i];
				str = str.split(" ").join("");
				str = str.split("	").join("");
				var c:int = str.indexOf("<") + 1;
				var e:int = str.indexOf("=");
				str = str.substr(c, e - c);
				if (str == prop) {
					a = i;
					break;
				}
				++i;
			}
			if (a == -1)
				return null;
			delete _injectionsByProp[str];
			return _injections.splice(a, 1)[0];
		
		}
		
		public function addInjection(prop:String, value:String):void {
			removeInjection(prop);
			_injections[_injections.length] = "[Inject < " + prop + " = " + value + "]";
			_injectionsByProp[prop] = value;
			setProperty(prop, false);
		}
		
		internal function addInjectionCommand(value:String):void {
			while (value.substr(0, 1) == "	")
				value = value.substr(1, value.length - 1);
			if (_parseInjection(value)) {
				_injections[_injections.length] = value;
			}
		}
		
		protected function _parseInjection(value:String):Boolean {
			if (value.substr(value.length - 1, 1) == "]")
				value = value.substr(0, value.length - 1);
			value = value.split("<")[1];
			var ps:Array = value.split("=");
			if (_injectionsByProp[ps[0]] == ps[1]) {
				return false;
			}
			_injectionsByProp[ps[0]] = ps[1];
			return true;
		}
		
		public function builtApply(object:*, ...toEnableProperties:Array):void {
			var prop:Object = SiriusEncoder.getClassInfo(object).properties;
			for each (var p:String in prop) {
				setProperty(p, toEnableProperties.indexOf(p) > -1);
			}
		}
		
		public function built(object:*):void {
			if (_isBuilt)
				return;
			_isBuilt = true;
			var prop:Object = SiriusEncoder.getClassInfo(object).properties;
			for each (var p:String in prop)
				setProperty(p, true);
		}
		
		public function get enabledProperties():Object {
			return _table;
		}
		
		public function hasInjections():Boolean {
			return _injections.length > 0;
		}
		
		public function getInjectionValue(name:String):String {
			return _injectionsByProp[name];
		}
		
		public function getInjections(ident:int = 0):String {
			++ident;
			var join:String = "\n";
			while (join.length < ident)
				join = join + "	";
			return _injections.join(join);
		}
		
		public function clone():SiriusEncoderRules {
			
			var copy:SiriusEncoderRules = new SiriusEncoderRules();
			copy._injections.concat(_injections);
			
			for (var rule:String in _table)
				copy._table[rule] = _table[rule];
			
			copy.noSort = noSort;
			copy.weak = weak;
			
			return copy;
		}
	
	}

}