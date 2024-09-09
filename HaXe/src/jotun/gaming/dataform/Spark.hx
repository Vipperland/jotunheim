package jotun.gaming.dataform;
import jotun.tools.Utils;
import jotun.utils.Dice;
#if js
	import js.Syntax;
#end

/**
 * ...
 * @author Rim Project
 */
@:expose("Spark")
class Spark extends SparkCore {
	
	private var _changes:Array<String>;
	
	public var id:String;
	
	private function getProps():Array<String> {
		return Pulsar.propertiesOf(_name);
	}
	
	public function new(name:String) {
		super(name);
	}
	
	/**
	   Convert this object to a string type
	   @return
	**/
	public function stringify(?changes:Bool):String {
		var r:String = null;
		var c:String = null;
		if (!changes || isChanged()){
			r = SparkWriter.stringify(this, _name, changes ? _changes : getProps());
		}
		Dice.Values(_inserts, function(v:Spark){
			if (v != null){
				c = v.stringify(changes);
				if (c != null){
					if (r == null){
						r = _name + ' ' + id;
					}
					r += '\n\t' + c;
				}
			}
		});
		c = _getDelString('/');
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
				SparkWriter.parse(this, data, getProps(), false);
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
		SparkWriter.parse(this, data, getProps(), true);
	}
	
	public function set(prop:String, value:Dynamic):Spark {
		if (_changes != null && Reflect.field(this, prop) != value){
			if (_changes.indexOf(prop) == -1){
				_changes.push(prop);
			}
		}
		Reflect.setField(this, prop, value);
		return this;
	}
	
	public function unset(prop:String):Spark {
		if (_changes != null && Reflect.field(this, prop) != null){
			if (_changes.indexOf(prop) == -1){
				_changes.push(prop);
			}
		}
		Reflect.deleteField(this, prop);
		return this;
	}
	
	public function prop(name:String):Dynamic {
		return Reflect.field(this, name);
	}
	
	public function allowChanges() {
		if (_changes == null){
			commit();
		}
	}
	
	public function isChanged():Bool {
		return (_changes != null && _changes.length > 0);
	}
	
	public function commit():Void {
		_changes = [];
		_deletions = [];
	}
	
	public function clone():Spark {
		var o:Spark = new Spark(_name);
		o.parse(stringify());
		return o;
	}
	
	public function isIndexable():Bool {
		return Pulsar.isIndexable(_name);
	}
	
	public function getObject(?o:Array<Dynamic>):Dynamic {
		if (_inserts.length > 0){
			if (o == null) {
				o = [];
			}
			Dice.Values(_inserts, function(v:Spark){
				o.push(v.getObject(o));
			});
			return o;
		}else if (prop('*') != null){
			return prop('*');
		}else{
			var r:Dynamic = {};
			Dice.Values(getProps(), function(v:String){
				if(v != '*'){
					Reflect.setField(r, v, Reflect.field(this, v));
				}
			});
			return r;
		}
	}
	
}