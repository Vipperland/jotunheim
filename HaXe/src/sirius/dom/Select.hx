package sirius.dom;
import js.Browser;
import js.html.BaseElement;
import js.html.OptionElement;
import js.html.SelectElement;
import sirius.utils.Dice;
import sirius.utils.ITable;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Select")
class Select extends Display {
	
	public static function get(q:String, ?h:IDisplay->Void):Select {
		return cast Sirius.one(q,null,h);
	}
	
	public var object:SelectElement;
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createSelectElement();
		super(q, null);
		object = cast element;
	}
	
	public function getAllSelected():ITable {
		return all("option:checked");
	}
	
	public function getSelected():Option {
		return cast one("option:checked");
	}
	
	public function setValue(i:Int):Void {
		object.selectedIndex = i;
		events.change().call(true,true);
	}
	
	public function value():String {
		var t:ITable = getAllSelected();
		var r:Array<String> = [];
		if (t != null && t.length() > 0) {
			t.each(function(v:IDisplay) {
				var o:Option = cast v;
				r[r.length] = o.value();
			});
		}
		return r.join(";");
	}
	
	public function hasValue():Bool {
		var i:UInt = 0;
		while (i < object.selectedOptions.length) {
			var o:OptionElement = cast object.selectedOptions.item(i++);
			if (!o.disabled) return true;
		}
		return false;
	}
	
}