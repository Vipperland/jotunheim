package sirius.dom;
import js.Browser;
import js.html.BaseElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Select")
class Select extends Display{
	
	public static function get(q:String, ?h:IDisplay->Void):Select {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Dynamic, ?d:String = null) {
		if (q == null) q = Browser.document.createSelectElement();
		super(q,null,d);
	}
	
}