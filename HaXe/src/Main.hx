package;
import haxe.Log;
import sirius.css.Color;
import sirius.css.Common;
import sirius.css.Creator;
import sirius.css.Shadow;
import sirius.dom.Div;
import sirius.Sirius;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Main{

	static public function main() {
		Creator.init([Common, Color, Shadow]);
		Sirius.init(_init);
	}
	
	static private function _init() {
		var d:Div = new Div();
		Sirius.body.addChild(d);
		d.build(Creator.valueOf());
	}
	
}