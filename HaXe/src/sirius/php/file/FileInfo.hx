package sirius.php.file;

/**
 * ...
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */
class FileInfo {

	public var name:String;
	
	public var input:String;
	
	public var output:String;
	
	public function new(type:String, input:String, output:String) {
		this.type = type;
		this.output = output;
		this.input = input;
	}
	
}