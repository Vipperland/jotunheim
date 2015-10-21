package sirius.dom;
import sirius.data.IFormData;
import haxe.Log;
import js.Browser;
import js.html.FormElement;
import sirius.data.FormData;
import sirius.events.Dispatcher;
import sirius.utils.ITable;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Form")
class Form extends Display {
	
	public static function get(q:String, ?h:IDisplay->Void):Form {
		return cast Sirius.one(q,null,h);
	}
	
	private var _submit:Input;
	
	public var object:FormElement;
	
	public var inputData:IFormData;
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createFormElement();
		super(q, null);
		object = cast element;
	}
	
	public function validate():Bool {
		checkSubmit().object.click();
		return object.checkValidity();
	}
	
	public function checkSubmit():Input {
		if(_submit == null) {
			var i:Input;
			if (!exists("input[type=submit]")) {
				i = new Input();
				i.type("submit");
				i.hide();
				this.addChild(i);
			}else {
				i = cast one("input[type=submit]");
			}
			_submit = i;
		}
		return _submit;
	}
	
	public function submit():Void {
		object.submit();
	}
	
	public function formData():IFormData {
		if (inputData == null) inputData = new FormData(this);
		else inputData.scan(this);
		return inputData;
	}
	
	public function getAsInput(i:Int, ?update:Bool):Input {
		if (_children == null || update == true) _children = children();
		return cast _children.obj(i);
	}
	
}