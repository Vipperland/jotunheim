package sirius.dom;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Label")
class Label extends Display{
	
	public static function get(q:String, ?h:IDisplay->Void):Label {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Dynamic, ?d:String = null) {
		if (q == null) q = Browser.document.createLabelElement();
		super(q,null,d);
	}
	
}