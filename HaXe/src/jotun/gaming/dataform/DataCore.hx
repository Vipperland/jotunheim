package jotun.gaming.dataform;
import jotun.utils.Dice;

/**
 * ...
 * @author 
 */
class DataCore {

	private var _name:String;
	
	private var _inserts:Array<DataObject>;
	
	private var _deletions:Array<String>;
	
	private var _indexed:Dynamic;
	
	private function _getDelString(pre:String):String {
		var r:String = null;
		if (_deletions != null && _deletions.length > 0){
			r = '';
			Dice.All(_deletions, function(p:Int, v:String){
				r += (p == 0 ? '' : '\r') + pre + v;
			});
		}
		return  r;
	}
	
	public function _delete(id:String):Bool {
		var index:Int = Reflect.field(_indexed, id);
		if (index != null){
			var object:DataObject = _inserts[index];
			if (object != null){
				_inserts[index] = null;
				Reflect.deleteField(_indexed, id);
				if (_deletions != null){
					_deletions[_deletions.length] = object.getName() + ' ' + id;
				}
				return true;
			}
		}
		return false;
	}
	
	public function new(name:String) {
		_name = name;
		_inserts = [];
		_indexed = {};
	}
	
	public function getName():String {
		return _name;
	}
	
	public function is(name:String):Bool {
		return _name == name;
	}
	
	public function get(id:Dynamic):DataObject {
		var index:Int = Std.isOfType(id, String) ? Reflect.field(_indexed, id) : id;
		if (index != null){
			return _inserts[index];
		}else{
			return null;
		}
	}
	
	/**
	   Insert ION sub data
	   @param	name
	   @param	o
	   @return
	**/
	public function insert(o:DataObject):Bool {
		if (canInsert(o)){
			var index:Int = _inserts.length;
			_inserts[index] = o;
			Reflect.setField(_indexed, o.id, index);
			onInsert(o);
		}
		return true;
	}
	
	public function canInsert(o:DataObject):Bool {
		// override
		return true;
	}
	
	public function onInsert(o:DataObject):Void {
		// override
	}
	
	public function onParse():Void {
		// override
	}
	
	public function onRemove(o:DataObject):Void {
		
	}
	
	public function refresh():Void {
		var max:Int = _inserts.length;
		if(max > 0){
			var index:Int = 0;
			var cursor:Int = 0;
			var object:DataObject;
			while(cursor < max){
				if (_inserts[cursor] != null){
					if (cursor != index){
						object = _inserts[index];
						_inserts[index] = _inserts[cursor];
						_inserts[cursor] = null;
						if(object != null && object.id != null){
							Reflect.setField(_indexed, object.id, index);
						}
					}
					index += 1;
				}
				++cursor;
			}
			if (index < max){
				_inserts.splice(index, max - index);
			}
		}
	}
	
	public function delete(id:String):Bool {
		return _delete(id);
	}
	
	public function deleteIndex(index:Int):Bool {
		var obj:DataObject = get(index);
		if (obj != null){
			return _delete(obj.id);
		}else{
			return false;
		}
	}
	
}