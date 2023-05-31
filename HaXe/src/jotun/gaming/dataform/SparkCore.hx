package jotun.gaming.dataform;
import jotun.utils.Dice;

/**
 * ...
 * @author 
 */
class SparkCore {

	private var _name:String;
	
	private var _inserts:Array<Spark>;
	
	private var _deletions:Array<String>;
	
	private var _indexed:Dynamic;
	
	private function _getDelString(pre:String):String {
		var r:String = null;
		if (_deletions != null && _deletions.length > 0){
			r = '';
			Dice.All(_deletions, function(p:Int, v:String){
				r += (p == 0 ? '' : '\n') + pre + v;
			});
		}
		return  r;
	}
	
	private function _delete(id:Dynamic):Spark {
		var index:Int = Std.isOfType(id, String) ? Reflect.field(_indexed, id) : id;
		if (index != null){
			var object:Spark = _inserts[index];
			if (object != null){
				_inserts[index] = null;
				Reflect.deleteField(_indexed, id);
				refresh();
				return object;
			}
		}
		return null;
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
	
	public function exists(id:String):Bool {
		return Reflect.hasField(_indexed, id);
	}
	
	public function get(id:Dynamic):Spark {
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
	public function insert(o:Spark):Bool {
		if (canInsert(o)){
			var index:Int = _inserts.length;
			_inserts[index] = o;
			if (o.isIndexable()){
				Reflect.setField(_indexed, o.id, index);
			}
			onInsert(o);
		}
		return true;
	}
	
	public function canInsert(o:Spark):Bool {
		// override
		return true;
	}
	
	public function onInsert(o:Spark):Void {
		// override
	}
	
	public function onParse():Void {
		// override
	}
	
	public function onDelete(o:Spark):Void {
		
	}
	
	public function refresh():Void {
		var max:Int = _inserts.length;
		if(max > 0){
			var index:Int = 0;
			var cursor:Int = 0;
			var object:Spark;
			while(cursor < max){
				if (_inserts[cursor] != null){
					if (cursor != index){
						object = _inserts[cursor];
						_inserts[index] = _inserts[cursor];
						_inserts[cursor] = null;
						if(object != null){
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
	
	public function delete(id:Dynamic, ?silent:Bool):Spark {
		var o:Spark = _delete(id);
		if (o != null){
			if(!silent){
				_deletions[_deletions.length] = o.getName() + ' ' + o.id;
			}
			onDelete(o);
			return o;
		}else{
			return null;
		}
	}
	
	public function each(handler:Spark->Bool){
		Dice.Values(_inserts, function(v:Spark){
			return v != null && handler(v);
		});
	}
	
	public function filter(?name:String, ?handler:Spark->Bool, ?merge:Array<Spark>):Array<Spark> {
		if (merge == null){
			merge = [];
		}
		Dice.Values(_inserts, function(v:Spark){
			if (name == null || v._name == name){
				merge[merge.length] = v;
				if (handler != null){
					return handler(v);
				}
			}
			return false;
		});
		return merge;
	}
	
}