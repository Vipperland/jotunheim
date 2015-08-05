package sirius.dom;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Sprite")
class Sprite extends Div {

	public var content:Div;
	
	public function new(?q:Dynamic, ?d:String = "wh-100pc disp-tab abs") {
		super(null, d);
		content = new Div(q, "disp-tab-cell vert-m txt-c");
		addChild(content);
	}
	
}