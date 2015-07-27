package sirius.dom;
import haxe.Log;
import js.Browser;
import js.html.Element;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("sru.dom.Div")
class Div extends Display implements IDiv {
	
	public function new(?q:Element, ?d:String = null) {
		if (q == null) q = Browser.document.createDivElement();
		super(q, null, d);
	}
	
	public function alignCenter():Void {
		css("centered /float-l /float-r");
	}
	
	public function alignLeft():Void {
		css("float-l /centered /float-r");
	}
	
	public function alignRight():Void {
		css("float-r /centered /float-l");
	}
	
	public function background(?value:String, ?repeat:String, ?position:String, ?attachment:String):String {
		if(value != null){
			var c:String = (value.indexOf("#") == 0) ? value : "url(" + value + ")";
			var r:String = repeat != null && repeat.length > 0 ? repeat : "center center";
			var p:String = position != null && repeat.length > 0 ? position : "no-repeat";
			Self.style.background = c + " " + r + " " + p;
			Log.trace(c + " " + r + " " + p);
			if (attachment != null && attachment.length > 0) Self.style.backgroundAttachment = attachment;
		}
		return Self.style.background;
	}
	
}