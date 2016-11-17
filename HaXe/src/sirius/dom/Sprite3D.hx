package sirius.dom;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Sprite3D")
class Sprite3D extends Display3D {
	
	static public function get(q:String):Sprite3D {
		return cast Sirius.one(q);
	}
	
	public var content:IDisplay3D;
	
	public function new(?q:Dynamic) {
		super(null);
		setPerspective("1000px");
		content = new Display3D(q);
		content.preserve3d().update();
		//content.setPerspective(null, '50% 50% 50%');
		if (content.parent() == null) addChild(content);
		css('sprite');
		update();
	}
	
}