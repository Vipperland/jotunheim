package css;

import haxe.Log;
import js.Browser;
import js.html.StyleElement;
import js.html.StyleSheet;
import sirius.dom.Style;

/**
 * ...
 * @author Rafael Moreira
 */
class CSSGroup{

	public var CM:StyleElement;
	
	public var XS:StyleElement;
	
	public var SM:StyleElement;
	
	public var MD:StyleElement;
	
	public var LG:StyleElement;
	
	public var style:String;
	
	public var styleXS:String;
	
	public var styleSM:String;
	
	public var styleMD:String;
	
	public var styleLG:String;
	
	public var container:Style;
	
	private static function _style():StyleElement {
		var e:StyleElement = new Style().object;
		e.type = "text/css";
		e.innerHTML = "";
		return e;
	}
	
	public function new() {
		reset();
		if (container == null) {
			container = new Style();
			CM = _style();
			XS = _style();
			SM = _style();
			MD = _style();
			LG = _style();
			Browser.document.head.appendChild(cast container.element);
		}
	}
	
	public function hasSelector(id:String, ?mode:String):Bool {
		var k:String = mode != null ? mode : id.substr( -2, 2);
		id = "." + id + "{";
		if(k != null && k != ''){
			if (k == 'xs') return XS.innerHTML.indexOf(id) != -1;
			if (k == 'sm') return SM.innerHTML.indexOf(id) != -1;
			if (k == 'md') return MD.innerHTML.indexOf(id) != -1;
			if (k == 'lg') return LG.innerHTML.indexOf(id) != -1;
		}
		return CM.innerHTML.indexOf(id) != -1;
	}
	
	public function setSelector(id:String, style:String, mode:String):Void {
		if(!hasSelector(id, mode)){
			if (mode == 'xs') this.styleXS += _add(id, style);
			else if (mode == 'sm') this.styleSM += _add(id, style);
			else if (mode == 'md') this.styleMD += _add(id, style);
			else if (mode == 'lg') this.styleLG += _add(id, style);
			else this.style += _add(id, style);
		}
	}
	
	public function distribute(id:String, style:String):Void {
		setSelector(id + "-xs", style, 'xs');
		setSelector(id + "-sm", style, 'sm');
		setSelector(id + "-md", style, 'md');
		setSelector(id + "-lg", style, 'lg');
		setSelector(id, style,null);
	}
	
	private function _add(id:String, style:String):String {
		return (id + "{" + style + "}");
	}
	
	private static var SOF:String = "/*SOF*/@media";
	private static var EOF:String = "}/*EOF*/";
	private static var MEDIA_XS:String = SOF+"(min-width:1px) and (max-width:767px){ ";
	private static var MEDIA_SM:String = SOF+"(min-width:768px) and (max-width:1000px){ ";
	private static var MEDIA_MD:String = SOF+"(min-width:1001px) and (max-width:1169px){ ";
	private static var MEDIA_LG:String = SOF+"(min-width:1170px){ ";
	
	private function _write(e:StyleElement, v:String, h:String):Void {
		if (v.length > 0) {
			e.innerHTML = h != '' ? ((e.innerHTML.length > 0 ? (h + e.innerHTML.split(h).join("").split(EOF).join("") + v) : h + v) + EOF) : e.innerHTML + v;
			if (e.parentElement == null) container.element.appendChild(cast e);
		}
	}
	
	public function build() {
		_write(CM, style, '');
		_write(XS, styleXS, MEDIA_XS);
		_write(SM, styleSM, MEDIA_SM);
		_write(MD, styleMD, MEDIA_MD);
		_write(LG, styleLG, MEDIA_LG);
		reset();
	}
	
	public function reset() {
		style = styleXS = styleSM = styleMD = styleLG = "";
	}
	
	
}