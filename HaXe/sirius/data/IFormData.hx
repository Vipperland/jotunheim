package sirius.data;
import sirius.data.FormData;
import sirius.dom.IDisplay;

/**
 * @author Rafael Moreira
 */

interface IFormData {
	
	public var params:Array<FormParam>;
	
	public var errors:Array<FormParam>;

	public function reset () : IFormData;

	public function scan (?target:IDisplay) : IFormData;

	public function valueOf (p:String) : FormParam;

	public function isValid () : Bool;

	public function getParam (p:String) : FormParam;

	public function getData():Dynamic;
	
	public function clear () : IFormData;
	
}