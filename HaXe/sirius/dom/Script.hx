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
	
	public function new(?q:Dynamic, ?d:String = null) {
		if (q == null) q = Browser.document.createScriptElement();
		super(q, null, d);
		content = cast element;
	}
	
	public function load(url:String, ?handler:Dynamic):Void {
		content.src = url;
		if (handler != null) {
			if (Sirius.agent.ie < 12) {
				events.readyState(function(e:IEvent) {
					var st:String = e.target.attribute('readyState');
					if (st == 'loaded' || st == 'complete') {
						handler(e);
						events.readyState(handler, -1);
					}
				}, 1);
			}else {
				events.load(handler, 1);
			}
		}
	}
	
	public function async():Void {
		content.async = true;
	}
	
}