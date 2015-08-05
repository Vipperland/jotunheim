package sirius.css;
import haxe.Log;
import js.Browser;
import js.html.CSSStyleSheet;
import js.html.StyleElement;
import sirius.dom.Style;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.css.CSS")
class CSS implements ICSS {
	
	public static var ALL:StyleElement;
	
	public static var XS:StyleElement;
	
	public static var SM:StyleElement;
	
	public static var MD:StyleElement;
	
	public static var LG:StyleElement;
	
	public var style:String;
	
	public var styleXS:String;
	
	public var styleSM:String;
	
	public var styleMD:String;
	
	public var styleLG:String;
	
	public var countable:Bool = true;
	
	public var important:Bool;
	
	public static function createStyle():StyleElement {
		var e:StyleElement = new Style().object;
		e.type = "text/css";
		e.innerText = "";
		return e;
	}
	
	public function new(?countable:Bool = true, ?important:Bool = false) {
		this.important = important;
		reset();
		if (ALL == null) {
			ALL = createStyle();
			XS = createStyle();
			SM = createStyle();
			MD = createStyle();
			LG = createStyle();
		}
		this.countable = countable;
	}
	
	/* INTERFACE sirius.css.ICSS */
	
	public function add(a:Int,b:Int):Void { }
	
	public function hasSelector(id:String):Bool {
		return ALL.innerText.indexOf(id) != -1;
	}
	
	public function setSelector(id:String, style:String, ?important:Bool):Void {
		important = this.important || important;
		this.style += _add(id, style, important);
		this.styleXS += _add(id + "-xs", style, important);
		this.styleSM += _add(id + "-sm", style, important);
		this.styleMD += _add(id + "-md", style, important);
		this.styleLG += _add(id + "-lg", style, important);
	}
	
	private function _add(id:String, style:String, important:Bool):String {
		return  (id + "{" + style + "}");// + (important ? id + "-i {" + style.split(";").join(" !important;") + "}" : "");
	}
	
	public function apply():Void {
		ALL.innerText += style;
		XS.innerText += "@media (max-width: 767px) {" + styleXS + "}";
		SM.innerText += "@media (min-width: 768px) and (max-width: 1000px) {" + styleSM + "}";
		MD.innerText += "@media (min-width: 1001px) and (max-width: 1169px) {" + styleMD + "}";
		LG.innerText += "@media (min-width: 1170px) {" + styleLG + "}";
		reset();
		if (ALL.parentElement == null) {
			Browser.document.head.appendChild(cast ALL);
			Browser.document.head.appendChild(cast XS);
			Browser.document.head.appendChild(cast SM);
			Browser.document.head.appendChild(cast MD);
			Browser.document.head.appendChild(cast LG);
		}
	}
	
	public function reset() {
		style = styleXS = styleSM = styleMD = styleLG = "";
	}
	
}