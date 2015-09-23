package sirius.plugins;
import sirius.dom.IDisplay;
import sirius.events.IEvent;
import sirius.tools.Utils;
import sirius.transitions.Ease;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.plugins.Anchor")
class Anchor {
	
	private var _active:String;
	
	private var _inactive:String;
	
	static public function init(?active:String, ?inactive:String):Anchor {
		return new Anchor(active, inactive);
	}
	
	public function new(?active:String, ?inactive:String) {
		_inactive = inactive;
		_active = active;
		Sirius.all("[plugin~=anchor]").onClick(_scroll);
	}
	
	private function _scroll(e:IEvent):Void {
		var d:String = e.target.attribute("anchor-to");
		if (d != null) {
			var time:Float = Std.parseFloat(Dice.One(e.target.attribute("anchor-time"), 1).value);
			var obj:IDisplay = Sirius.one(d);
			var x:Int = Std.parseInt(Dice.One(e.target.attribute("anchor-x"), 0).value);
			var y:Int = Std.parseInt(Dice.One(e.target.attribute("anchor-y"), 100).value);
			if (obj != null) {
				var ease:Dynamic = Ease.fromString(Dice.One(e.target.attribute("anchor-ease"), "LINEAR.X").value);
				Sirius.document.scrollTo(obj, time, ease, x, y);
			}else {
				Sirius.log("Anchor: Missing anchor-to='id:?' for Anchor plugin.", 10, 3);
			}
			Sirius.all("[anchor-if]").each(function(e:IDisplay) {
				if (e.attribute("anchor-if") == d)	{
					if(_active != null)		e.css(_active);
					if (_inactive != null)	e.css('/' + _inactive);
				} else {
					if(_active != null)		e.css('/' + _active);
					if (_inactive != null)	e.css(_inactive);
				}
			});
		}
		
	}
	
}