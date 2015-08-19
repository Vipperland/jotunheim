package sirius.dom;
import haxe.Log;
import js.Browser;
import js.html.Element;
import sirius.css.Automator;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Div")
class Div extends Display implements IDiv {
	
	public static function get(q:String, ?h:IDisplay->Void):Div {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Element, ?d:String = null) {
		if (q == null) q = Browser.document.createDivElement();
		super(q, null, d);
	}
	
	public function alignCenter():Void {
		Automator.build('marg-a vert-m', ".centered");
		css("centered /float-l /float-r");
	}
	
	public function alignLeft():Void {
		css("/centered float-l /float-r");
	}
	
	public function alignRight():Void {
		css("/centered /float-l float-r");
	}
	
	public function background(?value:String, ?repeat:String, ?position:String, ?attachment:String):String {
		if(value != null){
			var c:String = (value.indexOf("#") == 0) ? value : "url(" + value + ")";
			var r:String = repeat != null && repeat.length > 0 ? repeat : "center center";
			var p:String = position != null && repeat.length > 0 ? position : "no-repeat";
			element.style.background = c + " " + r + " " + p;
			if (attachment != null && attachment.length > 0) element.style.backgroundAttachment = attachment;
		}
		return element.style.background;
	}
	
}