package sirius.dom;
import sirius.css.Automator;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Sprite3D")
class Sprite3D extends Display3D {

	public var content:IDisplay3D;
	
	public function new(?q:Dynamic, ?d:String = "w-100pc h-100pc") {
		super(null, d);
		setPerspective("1000px");
		content = new Display3D(q);
		content.preserve3d().update();
		//content.setPerspective(null, '50% 50% 50%');
		if (content.parent() == null) addChild(content);
		content.css("disp-table-cell vert-m txt-c");
		update();
	}
	
}