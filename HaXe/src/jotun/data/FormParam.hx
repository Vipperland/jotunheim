package jotun.data;
import jotun.dom.IDisplay;
import jotun.dom.Select;
import jotun.tools.Utils;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class FormParam {
	
	private var _e:IDisplay;
	
	public function new(e:IDisplay) {
		_e = e;
	}
	
	public function getName():String {
		return _e.attribute("form-data");
	}
	
	public function getValidator():String {
		return _e.attribute("form-validate");
	}
	
	public function isRequired():Bool {
		return _e.hasAttribute("form-required") && Dice.Match(["1", "true", "yes"], _e.attribute("form-required")) > 0;
	}
	
	public function getMessage():String {
		return _e.attribute("form-message");
	}
	
	public function getValue():String {
		if (Std.is(_e, Select)) {
			var e:Select = cast _e;
			if (!e.hasValue()) return null;
		}
		return _e.attribute("value");
	}
	
	public function isValid(?required:Bool):Bool {
		return (!required && !isRequired()) || Utils.isValid(getValue());
	}
	
	public function clear():Void {
		if (Dice.Match(["1", "true", "yes"], _e.attribute("form-persistent")) == 0)	_e.attribute("value", "");
	}
	
	public function getCell():IDisplay {
		return _e;
	}
	
}