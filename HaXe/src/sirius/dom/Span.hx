package sirius.dom;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Span")
class Span extends Display{
	
	public static function get(q:String, ?h:IDisplay->Void):Span {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Dynamic=null, ?d:String = null) {
		if (q == null) q = Browser.document.createSpanElement();
		super(q,null,d);
	}
	
}