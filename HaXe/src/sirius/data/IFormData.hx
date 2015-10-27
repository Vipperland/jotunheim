package sirius.data;
import sirius.data.FormData;
import sirius.dom.IDisplay;
import sirius.modules.IRequest;

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

	public function getData(?append:Dynamic):Dynamic;
	
	public function clear () : IFormData;
	
	public function send(url:String, ?handler:IRequest->Void, method:String = 'post'):Void;
	
}