package sirius.dom;
import js.Browser;
import js.html.ScriptElement;
import sirius.events.IEvent;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Script")
class Script extends Display{
	
	public var content:ScriptElement;
	
	public static function get(q:String, ?h:IDisplay->Void):Script {
		return cast Sirius.one(q,null,h);
		
	}
	
	/**
	 * Load a list of Script elements and append its to document.head
	 * @param	url
	 * @param	handler
	 */
	static public function require(url:Array<String>, ?handler:Null<Void>->Void) {
		if (url.length > 0) {
			var file:String = url.shift();
			if (file != null) {
				var s:Script = new Script();
				Sirius.document.head.addChild(s);
				s.load(file, function(e:IEvent) {
					Script.require(url, handler);
				});
			}
		}else if(handler != null){
			handler(null);
		}
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createScriptElement();
		super(q, null);
		content = cast element;
	}
	
	public function load(url:String, ?handler:IEvent->Void):Void {
		content.src = url;
		if (handler != null) events.load(handler, 1);
	}
	
	public function async():Void {
		content.async = true;
	}
	
}