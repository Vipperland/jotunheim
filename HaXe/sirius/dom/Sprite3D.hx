package sirius.dom;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("sru.dom.Sprite3D")
class Sprite3D extends Display3D {

	public var content:Display3D;
	
	public function new(?q:Dynamic, ?d:String = "wh-100p center abs") {
		super(null, d);
		setPerspective("1000px");
		content = new Display3D();
		content.preserve3d().update();
		addChild(content);
		update();
	}
	
}