package jotun.css;
import jotun.css.CSSGroup;
import haxe.Log;
import js.Browser;
import js.html.CSSStyleSheet;
import js.html.StyleElement;
import jotun.dom.Style;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("jtn.css.CSS")
class CSS implements ICSS {
	
	public static var ALL:CSSGroup;
	
	public function new() {
		if (ALL == null) ALL = new CSSGroup();
	}
	
	/* INTERFACE sirius.css.ICSS */
	
	public function add(a:Int,b:Int):Void { }
	
	public function setSelector(id:String, style:String, ?mode:String):Void {
		ALL.set(id, style, mode);
	}
	
	private function _add(id:String, style:String, important:Bool):String {
		return  (id + "{" + style + "}") + (important ? id + "-i {" + style.split(";").join(" !important;") + "}" : "");
	}
	
	public function build():Void {
		ALL.build();
	}
	
}