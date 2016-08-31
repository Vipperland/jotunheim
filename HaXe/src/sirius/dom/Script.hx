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
	
	static public function get(q:String):Script {
		return cast Sirius.one(q);
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
				s.src(file, function(e:IEvent) {
					Script.require(url, handler);
				});
			}
		}else if(handler != null){
			handler(null);
		}
	}
	
	public var content:ScriptElement;
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createScriptElement();
		super(q, null);
		content = cast element;
	}
	
	public function src(url:String, ?handler:IEvent->Void):Void {
		content.src = url;
		if (handler != null) events.load(handler, 1);
	}
	
	public function async():Void {
		content.async = true;
	}
	
}