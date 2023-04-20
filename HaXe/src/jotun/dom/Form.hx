package jotun.dom;
import jotun.Jotun;
import jotun.dom.IDisplay;
import jotun.dom.Select;
import jotun.tools.Utils;
import jotun.utils.Dice;
import js.Browser;
import js.html.FormElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_dom_Form")
class Form extends Display {
	
	static public function get(q:String):Form {
		return cast Jotun.one(q);
	}
	
	public var object:FormElement;
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createFormElement();
		super(q, null);
		object = cast element;
	}
	
	public function submit():Void {
		object.submit();
	}
	
	public function extract(?handler:String->Dynamic->IDisplay->Void):Dynamic {
		var result:Dynamic = {};
		all('[name]').each(function(o:IDisplay):Void {
			var name:String = o.attribute('name');
			if (Utils.isValid(name)){
				var data:Dynamic = {
					name: name,
					value: o.value(),
					object: o,
				};
				Reflect.setField(result, name, data);
				if (handler != null){
					handler(name, data.value, o);
				}
			}
		});
		return result;
	}
	
}