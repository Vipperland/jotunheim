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
			ALL = _style();
			XS = _style();
			SM = _style();
			MD = _style();
			LG = _style();
			Browser.document.head.appendChild(cast container.element);
		}
	}
	
	public function hasSelector(id:String, ?mode:String):Bool {
		var k:String = mode != null ? mode : id.substr( -2, 2);
		if(k != null && k != ''){
			if (k == 'xs') return XS.innerHTML.indexOf(id+"{") != -1;
			if (k == 'sm') return SM.innerHTML.indexOf(id+"{") != -1;
			if (k == 'md') return MD.innerHTML.indexOf(id+"{") != -1;
			if (k == 'lg') return LG.innerHTML.indexOf(id + "{") != -1;
		}
		return ALL.innerHTML.indexOf(id) != -1;
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
	
	private static var MEDIA_XS:String = "/*SRU*/@media(min-width:1px) and @media(max-width:767px){ ";
	private static var MEDIA_SM:String = "/*SRU*/@media(min-width:768px) and (max-width:1000px){ ";
	private static var MEDIA_MD:String = "/*SRU*/@media(min-width:1001px) and (max-width:1169px){ ";
	private static var MEDIA_LG:String = "/*SRU*/@media(min-width:1170px){ ";
	
	public function build() {
		if (style.length > 0) {
			ALL.innerHTML += style;
			if (ALL.parentElement == null) {
				container.element.appendChild(cast ALL);
			}
		}
		if (styleXS.length > 0) {
			XS.innerHTML = (XS.innerHTML.length > 0 ? (MEDIA_XS + XS.innerHTML.split(MEDIA_XS).join("").split("}/*EOF*/").join("") + styleXS) : MEDIA_XS + styleXS) + "}/*EOF*/";
			if (XS.parentElement == null) {
				container.element.appendChild(cast XS);
			}
		}
		if (styleSM.length > 0)	{
			SM.innerHTML = (SM.innerHTML.length > 0 ? (MEDIA_SM + SM.innerHTML.split(MEDIA_SM).join("").split("}/*EOF*/").join("") + styleSM) : MEDIA_SM + styleSM) + "}/*EOF*/";
			if (SM.parentElement == null) {
				container.element.appendChild(cast SM);
			}
		}
		if (styleMD.length > 0)	{
			MD.innerHTML = (MD.innerHTML.length > 0 ? (MEDIA_MD + MD.innerHTML.split(MEDIA_MD).join("").split("}/*EOF*/").join("") + styleMD) : MEDIA_MD + styleMD) + "}/*EOF*/";
			if (MD.parentElement == null) {
				container.element.appendChild(cast MD);
			}
		}
		if (styleLG.length > 0)	{
			LG.innerHTML = (LG.innerHTML.length > 0 ? (MEDIA_LG + LG.innerHTML.split(MEDIA_LG).join("").split("}/*EOF*/").join("") + styleLG) : MEDIA_LG + styleLG)+ "}/*EOF*/";
			if (LG.parentElement == null) {
				container.element.appendChild(cast LG);
			}
		}
		reset();
	}
	
	public function reset() {
		style = styleXS = styleSM = styleMD = styleLG = "";
	}
	
	
}