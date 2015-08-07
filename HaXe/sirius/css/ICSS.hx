package sirius.css;
import js.html.CSSStyleSheet;
import js.html.StyleElement;

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

interface ICSS {
	public function add(a:Int,b:Int):Void;
	public function setSelector(id:String, style:String, ?mode:String):Void;
	public function build():Void;
}