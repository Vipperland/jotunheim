package sirius.css;

import haxe.Log;
import js.Browser;
import js.html.StyleElement;
import js.html.StyleSheet;
import sirius.dom.Style;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("sru.css.CSSGroup")
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
	
	private static function _style(media:String):StyleElement {
		var e:StyleElement = Browser.document.createStyleElement();
		e.setAttribute('media-type', media);
		e.type = "text/css";
		e.innerHTML = "";
		return e;
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
			Browser.document.head.appendChild(cast container.element);
		}
	}
	
	public function hasSelector(id:String, ?mode:String):Bool {
		var k:String = mode != null ? mode : id.substr( -2, 2);
		id = (id.substr(0,1) == "." ? "" : ".") + id + "{";
		if(k != null && k != ''){
			if (k == 'xs') return (XS.innerHTML + styleXS).indexOf(id) != -1;
			if (k == 'sm') return (SM.innerHTML + styleSM).indexOf(id) != -1;
			if (k == 'md') return (MD.innerHTML + styleMD).indexOf(id) != -1;
			if (k == 'lg') return (LG.innerHTML + styleLG).indexOf(id) != -1;
		}
		return (CM.innerHTML + style).indexOf(id) != -1;
	}
	
	public function getByMedia(mode:String):StyleElement {
		if (mode != null) {
			mode = mode.toLowerCase();
			if (mode == 'xs') return XS;
			if (mode == 'sm') return SM;
			if (mode == 'md') return MD;
			if (mode == 'lg') return LG;
		}
		return CM;
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
	
	public static var MEDIA_XS:String = "(min-width:1px) and (max-width:767px)";
	public static var MEDIA_SM:String = "(min-width:768px) and (max-width:1000px)";
	public static var MEDIA_MD:String = "(min-width:1001px) and (max-width:1169px)";
	public static var MEDIA_LG:String = "(min-width:1170px)";
	
	private function _write(e:StyleElement, v:String, h:String):Void {
		if (v.length > 0) {
			e.innerHTML = h != '' ? ((e.innerHTML.length > 0 ? (h + e.innerHTML.split(h).join("").split(EOF).join("") + v) : h + v) + EOF) : e.innerHTML + v;
			if (e.parentElement == null) container.element.appendChild(cast e);
		}
	}
	
	public function build() {
		_write(CM, style, '');
		_write(XS, styleXS, SOF + MEDIA_XS + "{");
		_write(SM, styleSM, SOF + MEDIA_SM + "{");
		_write(MD, styleMD, SOF + MEDIA_MD + "{");
		_write(LG, styleLG, SOF + MEDIA_LG + "{");
		reset();
	}
	
	public function reset() {
		style = styleXS = styleSM = styleMD = styleLG = "";
	}
	
	
}