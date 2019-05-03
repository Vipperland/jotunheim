package sirius.gaming.dataform;

/**
 * ...
 * @author Rim Project
 */
class DataObject {
	
	/**
	   Properties to output
	**/
	private var _io_props:Array<String>;
	
	/**
	   Çommand line name
	**/
	private var _io_name:String;
	
	public function new(io_name:String) {
		_io_props = io_name;
	}
	
	/**
	   Convert this object to a string type
	   @return
	**/
	public function stringify():String {
		return DataIO.stringify(this, _io_name, _io_props);
	}
	
	/**
	   Fill data to this object
	   @param	data
	   @return
	**/
	public function parse(data:Dynamic):DataObject {
		return DataIO.parse(this, data, _io_props);
	}
	
	public function onUpdate():Void {
		
	}
	
}