package sirius.data;
import sirius.dom.IDisplay;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class FormData {
	
	private var _form:IDisplay;
	
	public var fields:Array<String>;
	
	public var invalid:Array<String>;
	
	public var values:Dynamic;
	
	public var required:Dynamic;
	
	public var valid:Dynamic;
	
	public var messages:Dynamic;
	
	
	public function new(?target:IDisplay) {
		if(target != null) from(target);
	}
	
	public function reset() {
		fields = [];
		invalid = [];
		values = { };
		valid = { };
		messages = { };
	}
	
	public function from(target:IDisplay) {
		reset();
		_form = target;
		target.select("[form-data]").each(function(el:IDisplay) {
			var n:String = el.attribute("form-data");
			var r:String = el.attribute("form-option").toLowerCase();
			var v:String = el.attribute("value");
			var m:String = el.attribute("form-message");
			if (n != null && n.length > 0) {
				if (Lambda.indexOf(fields, n) == -1) fields[fields.length] = n;
				var rq:Bool = r.indexOf("required") != -1;
				Reflect.setField(values, n, v);
				Reflect.setField(messages, n, m);
				var i:Bool = !rq || (v != null && v.length > 0);
				Reflect.setField(valid, n, i);
				if (!i) invalid[invalid.length] = n;
			}
		});
	}
	
	public function valueOf(field:String):String {
		return Reflect.field(values, field);
	}
	
	public function isValid():Bool {
		return invalid != null && invalid.length == 0;
	}
	
	public function clear():Void {
		_form.select("[form-data]").each(function(el:IDisplay) {
			el.attribute("value", "");
		});
	}
	
}