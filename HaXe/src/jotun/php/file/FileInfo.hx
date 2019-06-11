package jotun.php.file;

/**
 * ...
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */
class FileInfo {

	public var type:String;
	
	public var input:String;
	
	public var output:String;
	
	public var sizes:Array<String>;
	
	public var error:Dynamic;
	
	public function new(type:String, input:String, output:String) {
		this.type = type;
		this.output = output;
		this.input = input;
	}
	
}