package sirius.dom;
import js.Browser;
import js.html.OptionElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Option")
class Option extends Display {
	
	public var object:OptionElement;
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createOptionElement();
		super(q, null);
		object = cast element;
	}
	
	override public function value(?q:String):String {
		return object.value;
	}
	
	public function label():String {
		return object.innerText;
	}
	
}