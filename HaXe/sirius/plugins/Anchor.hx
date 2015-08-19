package sirius.plugins;
import haxe.Log;
import sirius.dom.IDisplay;
import sirius.events.IEvent;
import sirius.transitions.Ease;
import sirius.utils.Dice;
import sirius.utils.ITable;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.plugins.Anchor")
class Anchor {
	
	static public function init():Anchor {
		return new Anchor();
	}
	
	public function new() {
		Sirius.all("[plugin~=anchor]").onClick(_scroll);
	}
	
	private function _scroll(e:IEvent):Void {
		var d:String = e.target.attribute("scroll-target");
		if (d != null) {
			var time:Float = Std.parseFloat(Dice.One(e.target.attribute("scroll-time"), 1).value);
			var obj:IDisplay = Sirius.one(d);
			var x:Int = Std.parseInt(Dice.One(e.target.attribute("scroll-offx"), 0).value);
			var y:Int = Std.parseInt(Dice.One(e.target.attribute("scroll-offy"), 100).value);
			if (obj != null) {
				var ease:Dynamic = Ease.fromString(Dice.One(e.target.attribute("scroll-ease"), "LINEAR.X").value);
				Sirius.document.scrollTo(obj, time, ease, x, y);
			}else {
				Sirius.log("Anchor: Missing scroll-target='id:?' for Anchor plugin.", 10, 3);
			}
		}
		
	}
	
}