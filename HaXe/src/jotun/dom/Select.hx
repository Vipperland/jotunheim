package jotun.dom;
import jotun.Jotun;
import jotun.tools.Utils;
import jotun.utils.Filler;
import js.Browser;
import js.html.BaseElement;
import js.html.OptionElement;
import js.html.SelectElement;
import jotun.events.IEvent;
import jotun.utils.Dice;
import jotun.utils.ITable;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_dom_Select")
class Select extends Display {
	
	static public var layout:String = '<option value="{{value}}">{{label}}</option>';
	
	static private var _themes:Dynamic;
	
	static public function get(q:String):Select {
		return cast Jotun.one(q);
	}
	
	public var object:SelectElement;
	
	private var _ioHandler:IEvent->Void;
	
	private function _refreshIO(e:IEvent):Void {
		var c:String = '' + value();
		var p:String = attribute('current-value');
		if (c != p) {
			attribute('previous-value', p);
			attribute('current-value', c);
			if (_ioHandler != null){
				_ioHandler(e);
			}
		}
	}
	
	public function new(?q:Dynamic) {
		if (q == null) {
			q = Browser.document.createSelectElement();
		}
		super(q, null);
		object = cast element;
		events.change(_refreshIO);
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
		events.change().call(true, true);
	}
	
	@:overload(function():String{})
	@:overload(function():Array<String>{})
	override public function value(?q:Dynamic):Dynamic {
		if (q != null){
			selectValue(q);
		}
		var t:ITable = getAllSelected();
		var r:Array<String> = [];
		if (t != null && t.length() > 0) {
			t.each(function(v:IDisplay) {
				var o:Option = cast v;
				r[r.length] = o.value();
			});
		}
		return r.length <= 1 ? r[0] : r;
	}
	
	public function hasValue():Bool {
		var i:UInt = 0;
		if(object.selectedOptions != null){
			while (i < object.selectedOptions.length) {
				var o:OptionElement = cast object.selectedOptions.item(i++);
				if (!o.disabled){
					return true;
				}
			}
		}else{
			while (i < object.options.length) {
				var o:OptionElement = cast object.options[i++];
				if (o.selected && !o.disabled){
					return true;
				}
			}
		}
		return false;
	}
	
	@:overload(function(options:Array<Dynamic>):Array<Option>{})
	public function add(option:Dynamic):Dynamic {
		if (Std.is(option, Array)){
			var r:Array<Option> = [];
			Dice.All(option, function(p:Int, v:Dynamic){
				r[p] = cast mount(Filler.to(layout, v));
			});
			return r;
		} else{
			return mount(Filler.to(layout, option));
		}
	}
	
	public function saveTheme(name:String, ?content:String):Void {
		if (_themes == null){
			_themes = {};
		}
		Reflect.setField(_themes, name, Utils.getValidOne(content, element.innerHTML));
	}
	
	public function loadTheme(name:String):Void {
		element.innerHTML = Reflect.field(_themes, name);
		events.change().call();
	}
	
	public function control(handler:IEvent->Void):Void {
		_ioHandler = handler;
	}
	
}