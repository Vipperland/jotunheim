package jotun.dom;
import js.Browser;
import js.html.OptionElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("Jtn.Option")
class Option extends Display {
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createOptionElement();
		super(q, null);
	}
	
	override public function value(?q:Dynamic):Dynamic {
		return attribute('value', q);
	}
	
	public function label():String {
		return cast (element, OptionElement).innerText;
	}
	
	public function match(value:String):Bool {
		return this.value() == value;
	}
	
	public function select():Void {
		cast (element, OptionElement).selected = true;
	}
	
	override public function disable():Void {
		cast (element, OptionElement).disabled = true;
	}
	
}