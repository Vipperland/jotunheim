package sirius.dom;
import haxe.Log;
import js.Browser;
import js.html.InputElement;
import js.RegExp;
import sirius.events.IEvent;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Input")
class Input extends Display {
	
	public var object:InputElement;
	
	private var _rtc:EReg;
	
	private function _update(e:IEvent) {
		if (_rtc.match(object.value)) {
			var s:Int = object.selectionStart-1;
			object.value = _rtc.replace(object.value, "");
			object.setSelectionRange(s, s);
		}
	}
	
	public function new(?q:Dynamic, ?d:String = null) {
		if (q == null) q = Browser.document.createInputElement();
		super(q, null, d);
		object = cast Self;
	}
	
	public function type(?q:String):String {
		if (q != null) object.type = q;
		return object.type;
	}
	
	public function required(?q:Bool):Bool {
		if (q != null) object.required = q;
		return object.required;
	}
	
	public function pattern(?q:String):String {
		if (q != null) object.pattern = q;
		return object.pattern;
	}
	
	public function placeholder(?q:String):String {
		if (q != null) object.placeholder = q;
		return object.placeholder;
	}
	
	public function validateDate():Void {
		pattern("\\d{1,2}/\\d{1,2}/\\d{4}");
	}
	
	public function validateURL():Void {
		pattern("https?://.+");
	}
	
	public function validateIPv4():Void {
		pattern("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}");
	}
	
	public function validateCurrency():Void {
		pattern("\\d+(\\.\\d{2})?");
	}
	
	public function validateEmail():Void {
		pattern("/^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\\.[a-zA-Z0-9-]+)*$/");
	}
	
	public function restrict(q:EReg):Void {
		if (_rtc == null && q != null) {
			dispatcher.keyDown(_update, 0);
			dispatcher.keyUp(_update, 0);
			dispatcher.focusOut(_update, 0);
		}else if (q == null) {
			dispatcher.keyDown(_update, -1);
			dispatcher.keyUp(_update, -1);
			dispatcher.focusOut(_update, -1);
		}
		_rtc = q;
	}
	
	public function restrictNumbers():Void {
		restrict(~/[^0-9]/gi);
	}
	
	public function restrictLetters():Void {
		restrict(~/[^A-Za-z]/giu);
	}
	
	public function value(?q:String):String {
		if (q != null) object.value = q;
		return object.value;
	}
	
	public function isValid():Bool {
		return object.value.length > 0;
	}
	
}