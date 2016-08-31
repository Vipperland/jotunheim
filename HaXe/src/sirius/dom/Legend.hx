package sirius.dom;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Legend")
class Legend extends Display{
	
	static public function get(q:String):Legend {
		return cast Sirius.one(q);
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createLegendElement();
		super(q,null);
	}
	
}