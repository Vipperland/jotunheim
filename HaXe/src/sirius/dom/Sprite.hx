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
	
	public function new(?q:Dynamic) {
		super(q);
		if (q == null) {
			attribute('sru-dom', 'sprite');
		}
		content = cast one('div');
		if (content == null) {
			content = new Div();
			addChild(content);
		}
		css('w-100pc h-100pc disp-table txt-c');
		content.css('disp-table-cell vert-m');
	}
	
}