package css;

import haxe.Log;
import js.Browser;
import js.html.StyleElement;
import sirius.dom.Style;

/**
 * ...
 * @author Rafael Moreira
 */
class CSSGroup{

	public var ALL:StyleElement;
	
	public var XS:StyleElement;
	
	public var SM:StyleElement;
	
	public var MD:StyleElement;
	
	public var LG:StyleElement;
	
	public var style:String;
	
	public var styleXS:String;
	
	public var styleSM:String;
	
	public var styleMD:String;
	
	public var styleLG:String;
	
	private static function _style():StyleElement {
		var e:StyleElement = new Style().object;
		e.type = "text/css";
		e.innerHTML = "";
		return e;
	}
	
	public function new() {
		reset();
		if (ALL == null) {
			ALL = _style();
			XS = _style();
			SM = _style();
			MD = _style();
			LG = _style();
		}
	}
	
	public function hasSelector(id:String, ?mode:String):Bool {
		var k:String = mode != null ? mode : id.substr( -2, 2);
		if (k == 'xs') return XS.innerHTML.indexOf(id) != -1;
		if (k == 'sm') return SM.innerHTML.indexOf(id) != -1;
		if (k == 'md') return MD.innerHTML.indexOf(id) != -1;
		if (k == 'lg') return LG.innerHTML.indexOf(id) != -1;
		return ALL.innerHTML.indexOf(id) != -1;
	}
	
	public function setSelector(id:String, style:String, mode:String):Void {
		if(!hasSelector(id, mode)){
			if (mode == 'xs') this.styleXS += _add(id + "-xs", style);
			else if (mode == 'sm') this.styleSM += _add(id + "-sm", style);
			else if (mode == 'md') this.styleMD += _add(id + "-md", style);
			else if (mode == 'lg') this.styleLG += _add(id + "-lg", style);
			else this.style += _add(id, style);
		}
	}
	
	public function distribute(id:String, style:String):Void {
		this.styleXS += _add(id + "-xs", style);
		this.styleSM += _add(id + "-sm", style);
		this.styleMD += _add(id + "-md", style);
		this.styleLG += _add(id + "-lg", style);
		this.style += _add(id, style);
	}
	
	private function _add(id:String, style:String):String {
		return (id + "{" + style + "}");
	}
	
	public function build() {
		if(style.length > 0) 	ALL.innerHTML += style;
		if(styleXS.length > 0)	XS.innerHTML += "@media (max-width: 767px) {" + styleXS + "}";
		if(styleSM.length > 0)	SM.innerHTML += "@media (min-width: 768px) and (max-width: 1000px) {" + styleSM + "}";
		if(styleMD.length > 0)	MD.innerHTML += "@media (min-width: 1001px) and (max-width: 1169px) {" + styleMD + "}";
		if(styleLG.length > 0)	LG.innerHTML += "@media (min-width: 1170px) {" + styleLG + "}";
		reset();
		if(ALL.parentElement == null) 	Browser.document.head.appendChild(cast ALL);
		if(XS.parentElement == null) 	Browser.document.head.appendChild(cast XS);
		if(SM.parentElement == null) 	Browser.document.head.appendChild(cast SM);
		if(MD.parentElement == null) 	Browser.document.head.appendChild(cast MD);
		if(LG.parentElement == null) 	Browser.document.head.appendChild(cast LG);
	}
	
	public function reset() {
		style = styleXS = styleSM = styleMD = styleLG = "";
	}
	
	
}