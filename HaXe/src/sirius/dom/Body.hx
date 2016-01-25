package sirius.dom;

#if js
	import js.Browser;
	import js.html.BodyElement;
	import js.html.Element;
	import js.html.Event;
	import sirius.tools.Utils;
#elseif php
	import php.Lib;
#end

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

#if js
 
@:expose("sru.dom.Body")
class Body extends Display {
	
	private var _body:BodyElement;
	
	public static function get(q:String, ?h:IDisplay->Void):Body {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Element) {
		if (q == null) q = Browser.document.createBodyElement();
		super(q, null);
		_body = cast this.element;
		Browser.window.addEventListener('resize', _wResize);
	}
	
	private function _wResize(e:Event):Void {
		events.resize().call();
	}
	
	public function enlarge(?scroll:String = "over-hid"):Body {
		this.css("w-100pc h-100pc" + (scroll != null ? " " + scroll : "") + " padd-0 marg-0 pos-abs");
		return this;
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
	
	public static function write(text:String, ?nl:Bool = true):Void {
		content += text;
		if (nl) newline();
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
	
	public static function draw():Void {
		Lib.print("<html>");
		Lib.print("<head>");
		Lib.print("</head>");
		Lib.print("<body>");
		Lib.print(content);
		Lib.print("</body>");
		Lib.print("</html>");
	}
	
}

#end