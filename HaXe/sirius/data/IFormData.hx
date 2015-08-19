package data;
import sirius.dom.IDisplay;

/**
 * @author Rafael Moreira
 */

interface IFormData {
	public var fields : Array<String>;
	public var invalid : Array<String>;
	public var values : Dynamic;
	public var required : Dynamic;
	public var valid : Dynamic;
	public var messages : Dynamic;

	public function reset () : IFormData;

	public function scan (?target:IDisplay) : IFormData;

	public function valueOf (field:String) : String;

	public function isValid () : Bool;

	public function clear () : IFormData;
}