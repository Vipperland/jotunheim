package sirius.dom;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Span")
class Span extends Display{

	public function new(?q:Dynamic=null, ?d:String = null) {
		if (q == null) q = Browser.document.createSpanElement();
		super(q,null,d);
	}
	
}