package jotun.gaming.dataform;
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
@:expose("DataObject")
class DataObject extends DataCore {
	
	private var _changes:Array<String>;
	
	public var id:Dynamic;
	
	private function _getProps():Array<String> {
		return DataCollection.properties(_name);
	}
	
	public function new(name:String) {
		super(name);
	}
	
	/**
	   Convert this object to a string type
	   @return
	**/
	public function toString(?changes:Bool):String {
		var r:String = null;
		var c:String = null;
		if (!changes || isChanged()){
			r = DataIO.stringify(this, _name, changes ? _changes : _getProps());
			Dice.Values(_inserts, function(v:DataObject){
				if(v != null){
					c = v.toString(changes);
					if (c != null){
						r += '\n@' + c;
					}
				}
			});
		}
		c = _getDelString('@-');
		if (c != null){
			if (r == null) {
				r = _name + ' ' + id;
			}
			r += (r.length > 0 ? '\n' : '') + c;
		}
		return r;
	}
	
	/**
	   Fill data to this object
	   @param	data
	   @return
	**/
	public function parse(data:String):Bool {
		var i:Array<String> = data.split(' ');
		if (i[0] == _name){
			if (i.length > 2){
				id = i[1];
				data = i[2];
			}else{
				id = null;
				data = i[1];
			}
			if (data != null){
				DataIO.parse(this, data, _getProps());
				return true;
			}
		}
		return false;
	}
	
	/**
	   Merge any ION data to this object
	   @param	data
	**/
	public function merge(data:String):Void {
		DataIO.parse(this, data, _getProps());
	}
	
	public function set(prop:String, value:Dynamic):Void {
		if (_changes != null && Reflect.field(this, prop) != value){
			if (_changes.indexOf(prop) == -1){
				_changes.push(prop);
			}
		}
		Reflect.setField(this, prop, value);
	}
	
	public function allowChanges() {
		if (_changes == null){
			commit();
		}
	}
	
	public function isChanged():Bool {
		return _changes != null && _changes.length > 0;
	}
	
	public function commit():Void {
		_changes = [];
		_deletions = [];
	}
	
	public function clone():DataObject {
		var o:DataObject = new DataObject(_name);
		o.parse(toString());
		return o;
	}
	
}