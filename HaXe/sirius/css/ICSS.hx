package sirius.css;
import js.html.CSSStyleSheet;
import js.html.StyleElement;

/**
 * @author Rafael Moreira
 */

interface ICSS {
	public var countable:Bool;
	public function add(a:Int):Void;
	public function hasSelector(id:String):Bool;
	public function setSelector(id:String, style:String):Void;
	public function apply():Void;
}