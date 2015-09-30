package sirius.dom;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Track")
class Track extends Display{
	
	public static function get(q:String, ?h:IDisplay->Void):Track {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Dynamic, ?d:String = null) {
		if (q == null) q = Browser.document.createTrackElement();
		super(q,null,d);
	}
	
}