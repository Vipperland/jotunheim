package sirius.data;
import data.IFormData;
import sirius.dom.IDisplay;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class FormData implements IFormData {
	
	private var _form:IDisplay;
	
	public var fields:Array<String>;
	
	public var invalid:Array<String>;
	
	public var values:Dynamic;
	
	public var required:Dynamic;
	
	public var valid:Dynamic;
	
	public var messages:Dynamic;
	
	
	public function new(?target:IDisplay) {
		if(target != null) scan(target);
	}
	
	public function reset():IFormData {
		fields = [];
		invalid = [];
		values = { };
		valid = { };
		messages = { };
		return this;
	}
	
	public function scan(?target:IDisplay):IFormData {
		reset();
		_form = target == null ? Sirius.document : target;
		target.all("[form-data]").each(function(el:IDisplay) {
			var n:String = el.attribute("form-data");
			var r:Bool = el.hasAttribute("form-required") && Dice.Match(["1","true","yes"],el.attribute("form-required")) > 0;
			var v:String = el.attribute("value");
			var m:String = el.attribute("form-message");
			if (n != null && n.length > 0) {
				if (Lambda.indexOf(fields, n) == -1) fields[fields.length] = n;
				Reflect.setField(values, n, v);
				Reflect.setField(messages, n, m);
				var i:Bool = !r || (v != null && v.length > 0);
				Reflect.setField(valid, n, i);
				if (!i) invalid[invalid.length] = n;
			}
		});
		return this;
	}
	
	public function valueOf(field:String):String {
		return Reflect.field(values, field);
	}
	
	public function isValid():Bool {
		return invalid != null && invalid.length == 0;
	}
	
	public function clear():IFormData {
		_form.all("[form-data]").each(function(el:IDisplay) {
			if (!el.hasAttribute("form-persistent")) {
				el.attribute("value", "");
			}
		});
		return this;
	}
	
}