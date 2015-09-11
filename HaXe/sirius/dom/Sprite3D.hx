package sirius.dom;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Sprite3D")
class Sprite3D extends Display3D {

	public var content:Display3D;
	
	public function new(?q:Dynamic, ?d:String = "w-100pc h-100pc center pos-abs") {
		super(null, d);
		setPerspective("1000px");
		content = new Display3D(q);
		content.preserve3d().update();
		if (content.parent() == null) {
			addChild(content);
		}
		update();
	}
	
}