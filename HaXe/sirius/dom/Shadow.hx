package sirius.dom;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Shadow")
class Shadow extends Display{
	
	public static function get(q:String, ?h:IDisplay->Void):Shadow {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Dynamic, ?d:String = null) {
		if (q == null) q = Browser.document.createShadowElement();
		super(q,null,d);
	}
	
}