package sirius.dom;
import sirius.css.Automator;
import sirius.dom.IDisplay;
import sirius.utils.ITable;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Sprite")
class Sprite extends Div {
	
	public var content:Div;
	
	public function new(?q:Dynamic, ?d:String = "sprite") {
		super(q, d);
		if(q == null){
			Automator.build("w-100pc h-100pc disp-table pos-abs", ".sprite");
			Automator.build("disp-table-cell vert-m txt-c", ".sprite>div");
			attribute('sru-dom', 'sprite');
		}
		content = cast one('div');
		if (content == null) {
			content = new Div();
			addChild(content);
		}
	}
	
}