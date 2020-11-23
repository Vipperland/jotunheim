package jotun.dom;
import jotun.Jotun;
import js.Browser;
import js.html.FormElement;
import jotun.data.FormData;
import jotun.data.IFormData;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_dom_Form")
class Form extends Display {
	
	static public function get(q:String):Form {
		return cast Jotun.one(q);
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
		checkSubmit().click();
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