package sirius.dom;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Text extends Display {
	
	public var node:js.html.Text;
	
	public function new(?q:Dynamic, ?d:String = null) {
		q = Browser.document.createTextNode(q);
		super(q, null, d);
		node = q;
	}
	
}