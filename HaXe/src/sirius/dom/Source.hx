package sirius.dom;
import js.Browser;
import js.html.SourceElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Source")
class Source extends Display{

	static public function get(q:String):Source {
		return cast Sirius.one(q);
	}
	
	public var object:SourceElement;
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createSourceElement();
		super(q, null);
		object = cast element;
	}
	
}