package sirius.css;
import js.html.CSSStyleSheet;
import js.html.StyleElement;

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

interface ICSS {
	public var countable:Bool;
	public function add(a:Int,b:Int):Void;
	public function hasSelector(id:String):Bool;
	public function setSelector(id:String, style:String, ?important:Bool):Void;
	public function apply():Void;
}