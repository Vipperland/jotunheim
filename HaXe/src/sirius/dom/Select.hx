package sirius.dom;
import js.Browser;
import js.html.BaseElement;
import js.html.OptionElement;
import js.html.SelectElement;
import sirius.events.IEvent;
import sirius.utils.Dice;
import sirius.utils.ITable;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Select")
class Select extends Display {
	
	static public function get(q:String):Select {
		return cast Sirius.one(q);
	}
	
	public var object:SelectElement;
	
	private var _default:String;
	
	private var _ioHandler:IEvent->Void;
	
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
	
	public function clearSelected():Void {
		getAllSelected().each(cast function(o:Option) {
			o.object.selected = false;
		});
	}
	
	public function selectValue(value:Dynamic):Void {
		value = Std.string(value);
		all('option').each(cast function(o:Option) {
			o.object.selected = o.value() == value;
		});
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
			if (!o.disabled)
				return true;
		}
		return false;
	}
	
	public function hasChanged():Bool {
		if (!hasValue())
			return false;
		var v:String = value();
		if (attribute('tmp-data') == v)
			return false;
		attribute('tmp-data', v);
		return true;
	}
	
	public function addOption(label:String, value:Dynamic, ?selected:Bool, ?disabled:Bool):Select {
		write('<option value="' + value + '"' + (disabled == true ? ' disabled' : '') + (selected == true ? ' selected' : '') + '>' + label + '</options>', false);
		if (selected) {
			attribute('sru-option', this.value());
			selectValue(value);
		}
		return this;
	}
	
	public function makeDefault():Select {
		_default = element.innerHTML;
		return this;
	}
	
	public function resetToDefault():Select {
		element.innerHTML = _default;
		events.change().call();
		return this;
	}
	
	private function _refreshIO(e:IEvent):Void {
		var c:String = '' + value();
		if (c != attribute('sru-option')) {
			attribute('sru-option', c);
			_ioHandler(e);
		}
	}
	
	public function baseIO(handler:IEvent->Void):Void {
		_ioHandler = handler;
		attribute('sru-option', value());
		events.click(_refreshIO);
		events.keyPress(_refreshIO);
		events.change(_refreshIO);
	}
	
}