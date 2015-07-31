package sirius.css;
import haxe.Log;
import js.Browser;
import js.html.CSSStyleSheet;
import js.html.StyleElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.css.CSS")
class CSS implements ICSS {
	
	public static var ALL:StyleElement;
	
	public var style:String;
	
	public var countable:Bool = true;
	
	public function new(?countable:Bool = true) {
		style = "";
		if (ALL == null) {
			ALL = cast Browser.document.createStyleElement();
			ALL.type = "";
			ALL.innerText = "";
			Browser.document.head.appendChild(cast ALL);
		}
		this.countable = countable;
	}
	
	/* INTERFACE sirius.css.ICSS */
	
	public function add(a:Int,b:Int):Void { }
	
	public function hasSelector(id:String):Bool {
		return ALL.innerText.indexOf(id) != -1;
	}
	
	public function setSelector(id:String, style:String):Void {
		this.style += (id + "{" + style + "}");
	}
	
	public function apply():Void {
		ALL.innerText += style;
		style = "";
	}
	
}