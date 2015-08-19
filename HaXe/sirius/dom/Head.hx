package sirius.dom;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Head")
class Head extends Display{
	
	public static function get(q:String, ?h:IDisplay->Void):Head {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Dynamic, ?d:String = null) {
		if (q == null) q = Browser.document.createHeadElement();
		super(q,null,d);
	}
	
}