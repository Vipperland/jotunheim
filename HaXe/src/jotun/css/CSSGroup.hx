package jotun.css;

import haxe.Log;
import js.Browser;
import js.html.StyleElement;
import js.html.StyleSheet;
import jotun.dom.Style;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("J_CSSGroup")
class CSSGroup{

	private static var SOF:String = "/*SOF*/@media";
	
	private static var EOF:String = "}/*EOF*/";
	
	public static var MEDIA_PR:String = "print";
	
	public static var MEDIA_XS:String = "(min-width:1px)";
	
	public static var MEDIA_XS_MAX:String = "(max-width:767px)";
	
	public static var MEDIA_SM:String = "(min-width:768px)";
	
	public static var MEDIA_SM_MAX:String = "(max-width:991px)";
	
	public static var MEDIA_MD:String = "(min-width:992px)";
	
	public static var MEDIA_MD_MAX:String = "(max-width:1199px)";
	
	public static var MEDIA_LG:String = "(min-width:1200px)";
	
	public static var MEDIA_LG_MAX:String = "(max-width:1479px)";
	
	public static var MEDIA_XL:String = "(min-width:1480px)";
	
	public var CM:StyleElement;
	
	public var XS:StyleElement;
	
	public var SM:StyleElement;
	
	public var MD:StyleElement;
	
	public var LG:StyleElement;
	
	public var XL:StyleElement;
	
	public var PR:StyleElement;
	
	public var style:String;
	
	public var styleXS:String;
	
	public var styleSM:String;
	
	public var styleMD:String;
	
	public var styleLG:String;
	
	public var styleXL:String;
	
	public var stylePR:String;
	
	public var container:Style;
	
	
	private static function _style(media:String):StyleElement {
		var e:StyleElement = Browser.document.createStyleElement();
		e.setAttribute('media-type', media);
		e.type = "text/css";
		e.innerHTML = "";
		return e;
	}
	
	private function _checkSelector(value:String, content:String, current:String):Bool {
		var iof:Int = content.indexOf(value);
		var r:Bool = false;
		if (iof != -1) {
			r = true;
			if(current != null){
				var eof:Int = content.indexOf("}", iof);
				content = content.substring(iof, eof);
				r = current == content;
			}
		}
		return r;
	}
	
	
	private function _add(id:String, style:String):String {
		return (id + "{" + (style != null ? style : "/*<NULL>*/") + "}");
	}
	
	private function _write(e:StyleElement, v:String, h:String):Void {
		if (v.length > 0) {
			e.innerHTML = h != '' ? ((e.innerHTML.length > 0 ? (h + e.innerHTML.split(h).join("").split(EOF).join("") + v) : h + v) + EOF) : e.innerHTML + v;
			if (e.parentElement == null) {
				container.element.appendChild(cast e);
			}
		}
	}
	
	public function new() {
		reset();
		if (container == null) {
			container = new Style();
			CM = _style('**');
			XS = _style('xs');
			SM = _style('sm');
			MD = _style('md');
			LG = _style('lg');
			XL = _style('xl');
			PR = _style('pr');
			Browser.document.head.appendChild(cast container.element);
		}
	}
	
	public function getMode(id:String):String {
		var r:Array<String> = id.split('-');
		if (r.length > 1){
			id = r.pop();
			if (id.length == 2){
				return id.toUpperCase();
			}
		}
		return '';
	}
	
	public function exists(id:String, ?content:String, ?mode:String):Bool {
		var k:String = mode != null ? mode.toUpperCase() : getMode(id);
		id = (id.substr(0, 1) == "." ? "" : ".") + id + "{";
		var a:String = Reflect.hasField(this, k) ? Reflect.field(this, k).innerHTML : CM.innerHTML;
		var b:String = Reflect.field(this, 'style' + k);
		return _checkSelector(id, a + b, content);
	}
	
	public function add(css:String, ?mode:String):Void {
		var p:String = 'style' + (mode != null ? mode.toUpperCase() : '');
		Reflect.setField(this, p, Reflect.field(this, p) + css);
	}
	
	public function set(id:String, style:String, ?mode:String):Void {
		var p:String = 'style' + (mode != null ? mode.toUpperCase() : '');
		Reflect.setField(this, p, Reflect.field(this, p) + _add(id, style));
	}
	
	public function build() {
		_write(CM, style, '');
		_write(XS, styleXS, SOF + MEDIA_XS + "{");
		_write(SM, styleSM, SOF + MEDIA_SM + "{");
		_write(MD, styleMD, SOF + MEDIA_MD + "{");
		_write(LG, styleLG, SOF + MEDIA_LG + "{");
		_write(XL, styleXL, SOF + MEDIA_XL + "{");
		_write(PR, stylePR, SOF + MEDIA_PR + "{");
		reset();
	}
	
	public function reset() {
		style = styleXS = styleSM = styleMD = styleLG = styleXL = stylePR = "";
	}
	
	
}