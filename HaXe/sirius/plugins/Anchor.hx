package sirius.plugins;
import haxe.Log;
import sirius.dom.IDisplay;
import sirius.events.IEvent;
import sirius.transitions.Ease;
import sirius.utils.ITable;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("sru.plugins.Anchor")
class Anchor {
	
	public var elements:ITable;
	
	static public function init():Anchor {
		return new Anchor();
	}
	
	public function new() {
		elements = Sirius.all("[type=anchor]");
		elements.each(function(d:IDisplay) {
			d.dispatcher.click(_scroll);
			d.cursor("pointer");
			d.prepare();
		});
	}
	
	private function _scroll(e:IEvent):Void {
		var d:String = e.target.Self.getAttribute("data");
		if (d != null) {
			var k:IAnchorData = SruObject.fromString(d);
			if (k.id != null) {
				var ease:String = (k.ease != null ? k.ease : "circ_in_out").toUpperCase();
				Sirius.document.scrollTo(k.id, k.time != null ? Std.parseInt(k.time) : 1, Reflect.field(Ease, ease), 0, k.y != null ? Std.parseInt(k.y) : 100);
			}else {
				Log.trace("Anchor: Missing data='id:?' for element.");
			}
		}
		
	}
	
}