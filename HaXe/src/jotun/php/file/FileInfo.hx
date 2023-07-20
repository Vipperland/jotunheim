package jotun.php.file;
import jotun.utils.Dice;
import jotun.utils.IDiceRoll;

/**
 * ...
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */
class FileInfo {

	public var type:String;
	
	public var input:String;
	
	public var output:String;
	
	public var sizes:Array<IFileSizeInfo>;
	
	public var error:Dynamic;
	
	public function new(type:String, input:String, output:String) {
		this.type = type;
		this.output = output;
		this.input = input;
	}
	
	public function get(id:String):IFileSizeInfo {
		var roll:IDiceRoll = Dice.Values(sizes, function(v:IFileSizeInfo):Bool {
			return v.id == id;
		});
		return roll.completed ? null : roll.value;
	}
	
	public var image(get, null):Bool;
	private function get_image():Bool {
		switch(type.toLowerCase()){
			case 'jpg','png','wbmp','bmp','gif' : 
				return true;
			default :
				return false;
		}
	}
	
}