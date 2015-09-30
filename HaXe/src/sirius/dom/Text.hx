package sirius.dom;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Text extends Display {
	
	public var node:js.html.Text;
	
	public static function get(q:String, ?h:IDisplay->Void):Text {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Dynamic, ?d:String = null) {
		q = Browser.document.createTextNode(q);
		super(q, null, d);
		node = q;
	}
	
}