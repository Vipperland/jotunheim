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
	
	public function new(?q:Dynamic, ?d:String = "w-100pc h-100pc disp-table") {
		super(q, d);
		if (q == null) {
			attribute('sru-dom', 'sprite');
		}
		content = cast one('div');
		if (content == null) {
			content = new Div();
			addChild(content);
		}
		content.css('txt-c disp-table-cell vert-m');
	}
	
}