package sirius.utils;

import haxe.Log;
import js.Browser;
import js.html.Element;
import js.html.NodeList;
import sirius.dom.Display;
import sirius.dom.IDisplay;
import sirius.tools.Utils;
import sirius.utils.ITable;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.utils.Table")
class Table implements ITable {
	
	static public function create(f:Dynamic):Table {
		return new Table(f);
	}
	
	public var content:Array<IDisplay>;
	
	public var elements:Array<Element>;
	
	public function new(?q:String, ?t:Element = null) {
		content = [];
		elements = [];
		if (q == "NULL_TABLE") {
			return;
		}
		if(q != null){
			if (t == null) t = cast Browser.document;
			var result:NodeList = t.querySelectorAll(q);
			var element:Element = null;
			if(result.length > 0){
				Dice.Count(0, result.length, function(i:Int) {
					element = cast result.item(i);
					content[content.length] = Utils.displayFrom(element);
					elements[elements.length] = element;
				});
			}else {
				Log.trace("[WARNING] TABLE(" + q + ") : NO RESULT");
			}
		}else {
			Log.trace("[ERROR] TABLE(QUERY,TARGET) : NULL QUERY_SELECTOR");
		}
	}
	
	public function flush(handler:Dynamic, ?complete:Dynamic):ITable {
		Dice.Values(content, handler, complete);
		return this;
	}
	
	public function first():IDisplay {
		return content[0];
	}
	
	public function last():IDisplay {
		return content[content.length-1];
	}
	
	public function obj(i:Int):IDisplay {
		return content[i];
	}
	
	public function css(styles:String):ITable {
		Dice.Call(content, "css", [styles]);
		return this;
	}
	
	public function length():Int {
		return content.length;
	}
	
	public function each(handler:Dynamic):ITable {
		Dice.Values(content, handler);
		return this;
	}
	
	public function call(method:String, ?args:Array<Dynamic>):ITable {
		Dice.Call(content, method, args);
		return this;
	}
	
	public function onEvent(name:String, handler:Dynamic, ?capture:Bool):ITable {
		call(name, [handler, capture]);
		return this;
	}
	
	public function merge(?tables:Array<Table>):Table {
		var t:Table = new Table("NULL_TABLE");
		if (tables == null) tables = [];
		tables[tables.length] = this;
		Dice.Values(tables, function(v:Table) {
			t.content = t.content.concat(v.content);
			t.elements = t.elements.concat(v.elements);
		});
		return t;
	}
	
}