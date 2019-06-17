package jotun.gaming.dataform;
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
class DataObject implements Dynamic {
	
	/**
	   Properties to output
	**/
	private var _io_props:Array<String>;
	
	/**
	   Çommand line name
	**/
	private var _io_name:String;
	
	private var _inserts:Array<Dynamic>;
	
	public var id:Dynamic;
	
	public function new(io_name:String, props:Array<String>) {
		_io_name = io_name;
		_io_props = props;
	}
	
	public function getION():String {
		return _io_name;
	}
	
	/**
	   Convert this object to a string type
	   @return
	**/
	public function stringify():String {
		var r:String = DataIO.stringify(this, _io_name, _io_props);
		Dice.Values(_inserts, function(v:DataObject){
			r += '\r@' + v.stringify();
		});
		return r;
	}
	
	/**
	   Fill data to this object
	   @param	data
	   @return
	**/
	public function parse(data:String):Bool {
		var i:Array<String> = data.split(' ');
		if (i[0] == _io_name){
			if (i.length > 2){
				id = i[1];
				data = i[2];
			}else{
				id = null;
				data = i[1];
			}
			if (data != null){
				DataIO.parse(this, data, _io_props);
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
		DataIO.parse(this, data, _io_props);
	}
	
	/**
	   Insert ION sub data
	   @param	name
	   @param	o
	   @return
	**/
	public function insert(name:String, o:DataObject):Bool {
		if (_inserts == null){
			_inserts = [];
		}
		if (canInsert(name, o)){
			_inserts[_inserts.length] = o;
			onInsert(name, o);
		}
		return true;
	}
	
	public function onUpdate():Void {
		
	}
	
	public function canInsert(name:String, o:DataObject):Bool {
		return true;
	}
	
	public function onInsert(name:String, o:DataObject):Void {
		
	}
	
}