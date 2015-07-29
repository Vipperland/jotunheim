package sirius.dom;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Sprite")
class Sprite extends Div {

	public var content:Div;
	
	public function new(?q:Dynamic, ?d:String = "wh-100p center abs") {
		super(null, d);
		content = new Div(q);
		addChild(content);
	}
	
}