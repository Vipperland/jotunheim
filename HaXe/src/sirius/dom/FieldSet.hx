package sirius.dom;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.FieldSet")
class FieldSet extends Display{

	static public function get(q:String):FieldSet {
		return cast Sirius.one(q);
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createFieldSetElement();
		super(q,null);
	}
	
}