package jotun.dom;

#if js
	import js.Browser;
	import js.html.BodyElement;
	import js.html.Element;
	import js.html.Event;
	import jotun.tools.Utils;
#elseif php
	import php.Lib;
#end

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

#if js
 
@:expose("jtn.dom.Body")
class Body extends Display {
	
	private var _body:BodyElement;
	
	public function new(?q:Element) {
		if (q == null) q = Browser.document.createBodyElement();
		super(q, null);
		_body = cast this.element;
		Browser.window.addEventListener('resize', _wResize);
	}
	
	private function _wResize(e:Event):Void {
		events.resize().call();
	}
	
	public function maxScrollX():Int {
		return _body.scrollWidth - Utils.viewportWidth();
	}
	
	public function maxScrollY():Int {
		return _body.scrollHeight - Utils.viewportHeight();
	}
	
}

#elseif php
	
class Body {
	
	public static var content:String = "";
	
	public static var headData:String = "";
	
	public static function write(text:String, ?nl:Bool = true):Void {
		content += text;
		if (nl) newline();
	}
	
	public static function head(text:String):Void {
		headData += text;
	}
	
	public static function newline():Void {
		content += "<br>";
	}
	
	public static function hr():Void {
		content += "<hr>";
	}
	
	public static function multiline():Void {
		newline();
		newline();
	}
	
	public static function clear():Void {
		content = "";
	}
	
	public static function draw(?base:String = ""):Void {
		Lib.print("<html>");
		Lib.print("<head>");
		Lib.print("	<meta charset=\"utf-8\">");
		Lib.print("	<base href=\"" + base + "\">");
		Lib.print(headData);
		Lib.print("</head>");
		Lib.print("<body>");
		Lib.print(content);
		Lib.print("</body>");
		Lib.print("</html>");
	}
	
}

#end