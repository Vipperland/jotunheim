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

	private static var SOF:String = "/*SOF*/@media";
	
	private static var EOF:String = "}/*EOF*/";
	
	public static var MEDIA_PR:String = "print";
	
	public static var MEDIA_XS:String = "(min-width:1px)";
	
	public static var MEDIA_SM:String = "(min-width:768px)";
	
	public static var MEDIA_MD:String = "(min-width:992px)";
	
	public static var MEDIA_LG:String = "(min-width:1200px)";
	
	public var CM:StyleElement;
	
	public var XS:StyleElement;
	
	public var SM:StyleElement;
	
	public var MD:StyleElement;
	
	public var LG:StyleElement;
	
	public var PR:StyleElement;
	
	public var style:String;
	
	public var styleXS:String;
	
	public var styleSM:String;
	
	public var styleMD:String;
	
	public var styleLG:String;
	
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
			if (e.parentElement == null) container.element.appendChild(cast e);
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
			PR = _style('pr');
			Browser.document.head.appendChild(cast container.element);
		}
	}
	
	public function exists(id:String, ?content:String, ?mode:String):Bool {
		var k:String = mode != null ? mode : id.substr( -2, 2);
		id = (id.substr(0,1) == "." ? "" : ".") + id + "{";
		if(k != null && k != ''){
			if (k == 'xs') return _checkSelector(id, XS.innerHTML + styleXS, content);
			if (k == 'sm') return _checkSelector(id, SM.innerHTML + styleSM, content);
			if (k == 'md') return _checkSelector(id, MD.innerHTML + styleMD, content);
			if (k == 'lg') return _checkSelector(id, LG.innerHTML + styleLG, content);
			if (k == 'pr') return _checkSelector(id, PR.innerHTML + stylePR, content);
		}
		return _checkSelector(id, CM.innerHTML + style, content);
	}
	
	public function getByMedia(mode:String):StyleElement {
		if (mode != null) {
			mode = mode.toLowerCase();
			if (mode == 'xs') return XS;
			if (mode == 'sm') return SM;
			if (mode == 'md') return MD;
			if (mode == 'lg') return LG;
			if (mode == 'pr') return PR;
		}
		return CM;
	}
	
	public function add(css:String, ?mode:String):Void {
		if (mode == 'xs') 		this.styleXS += css;
		else if (mode == 'sm') 	this.styleSM += css;
		else if (mode == 'md') 	this.styleMD += css;
		else if (mode == 'lg') 	this.styleLG += css;
		else if (mode == 'pr') 	this.stylePR += css;
		else 					this.style   += css;
	}
	
	public function set(id:String, style:String, ?mode:String):Void {
		if(!this.exists(id, style, mode)){
			if (mode == 'xs') 		this.styleXS += _add(id, style);
			else if (mode == 'sm') 	this.styleSM += _add(id, style);
			else if (mode == 'md') 	this.styleMD += _add(id, style);
			else if (mode == 'lg') 	this.styleLG += _add(id, style);
			else if (mode == 'pr') 	this.stylePR += _add(id, style);
			else 					this.style   += _add(id, style);
		}
	}
	
	public function distribute(id:String, style:String):Void {
		set(id + "-xs", style, 'xs');
		set(id + "-sm", style, 'sm');
		set(id + "-md", style, 'md');
		set(id + "-lg", style, 'lg');
		set(id + "-pr", style, 'pr');
		set(id, 		style,	null);
	}
	
	public function build() {
		_write(CM, style, '');
		_write(XS, styleXS, SOF + MEDIA_XS + "{");
		_write(SM, styleSM, SOF + MEDIA_SM + "{");
		_write(MD, styleMD, SOF + MEDIA_MD + "{");
		_write(LG, styleLG, SOF + MEDIA_LG + "{");
		_write(PR, stylePR, SOF + MEDIA_PR + "{");
		reset();
	}
	
	public function reset() {
		style = styleXS = styleSM = styleMD = styleLG = stylePR = "";
	}
	
	
}