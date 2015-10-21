package sirius.dom;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Applet")
class Applet extends Display{
	
	public static function get(q:String, ?h:IDisplay->Void):Applet {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createAppletElement();
		super(q,null);
	}
	
}