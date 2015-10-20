package sirius.data;
import sirius.dom.IDisplay;
import sirius.tools.Utils;
import sirius.utils.Dice;
import sirius.utils.Validator;

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
	
	public function validate():Bool {
		var hv:String = getValidator();
		return !Utils.isValid(hv) || Reflect.field(Validator, hv)(getValue());
	}
	
	public function isRequired():Bool {
		return _e.hasAttribute("form-required") && Dice.Match(["1", "true", "yes"], _e.attribute("form-required")) > 0;
	}
	
	public function getMessage():String {
		return _e.attribute("form-message");
	}
	
	public function getValue():String {
		return _e.attribute("value");
	}
	
	public function isValid():Bool {
		return !isRequired() || (Utils.isValid(getValue()) && validate());
	}
	
	public function clear():Void {
		if (Dice.Match(["1", "true", "yes"], _e.attribute("form-persistent")) == 0)	_e.attribute("value", "");
	}
	
}