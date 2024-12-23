package jotun.utils;

import haxe.ds.Either;
import haxe.Log;
import js.Browser;
import js.html.Element;
import js.html.HTMLCollection;
import js.html.NodeList;
import jotun.dom.Display;
import jotun.dom.Displayable;
import jotun.events.Activation;
import jotun.tools.Utils;
import jotun.utils.ITable;
import js.html.Text;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("Jtn.Table")
class Table implements ITable {
	
	static private var _trash:Array<ITable> = [];
	static public function recycle(q:String, ?t:Element):ITable {
		var r:ITable = null;
		if (_trash.length > 0){
			r = _trash.pop();
		} else {
			r = new Table();
		}
		return r.scan(q, t);
	}
	
	static public function create():ITable {
		if (_trash.length > 0){
			return _trash.pop().reset();
		} else{
			return new Table();
		}
	}
	
	//static public function em
	
	static public function empty():ITable {
		return new Table().reset();
	}
	
	public var content:Array<Displayable>;
	
	public function new() {
	}
	
	public function reset():ITable {
		content = [];
		return this;
	}
	
	public function add(obj:Displayable):ITable {
		content[content.length] = obj;
		return this;
	}
	
	public function fill(result:NodeList){
		var element:Element = null;
		var obj:Displayable = null;
		var len:UInt = result.length;
		if(len > 0){
			var ind:UInt = 0;
			while(ind < len){
				element = cast result.item(ind);
				if (element != null && element.nodeName != '#text'){
					obj = Utils.displayFrom(element);
					content[ind] = obj;
				}
				++ind;
			}
		}
	}
	
	public function scan(q:String, ?t:Element):ITable {
		reset();
		if (q == null){
			q = "*";
		}
		if (t == null){
			t = cast Browser.document.body;
		}
		fill(q != "*" ? t.querySelectorAll(q) : t.childNodes);
		return this;
	}
	
	public function contains(q:String):ITable {
		var t:ITable = empty();
		var i:Int = 0;
		each(function(v:Displayable) {
			if (v.element.innerHTML.indexOf(q) != -1) {
				t.content[i] = v;
				++i;
			}
		});
		return t;
	}
	
	public function flush(handler:Displayable->Void):ITable {
		Dice.Values(content, handler);
		return this;
	}
	
	public function first():Displayable {
		return content[0];
	}
	
	public function last():Displayable {
		return content[content.length-1];
	}
	
	public function obj(i:Int):Displayable {
		return content[i];
	}
	
	public function not(target:Dynamic):ITable {
		if(Std.isOfType(target, Array)){
			Dice.Values(target, function(v:Displayable):Void {
				content.remove(v);
			});
		}else if(Std.isOfType(target, ITable)){
			Dice.Values(target.content, function(v:Displayable):Void {
				content.remove(v);
			});
		}else{
			content.remove(target);
		}
		return this;
	}
	
	public function css(styles:String):ITable {
		each(function(v:Displayable) { v.css(styles); } );
		return this;
	}
	
	public function react(data:Dynamic):ITable {
		each(function(v:Displayable) { v.react(data); } );
		return this;
	}
	
	public function style(p:Dynamic, v:Dynamic):ITable {
		each(function(v:Displayable) { v.style(p, v); } );
		return this;
	}
	
	public function attribute(name:String, value:String):ITable {
		each(function(v:Displayable) {	v.attribute(name, value); } );
		return this;
	}
	
	public function attributes(values:Dynamic):ITable {
		each(function(v:Displayable) {	v.attributes(values); });
		return this;
	}
	
	public function show():ITable {
		return each(function(v:Displayable) { v.show(); } );
	}
	
	public function hide():ITable {
		return each(function(v:Displayable) { v.hide(); } );
	}
	
	public function remove():ITable {
		return each(function(v:Displayable) { v.remove(); } );
	}
	
	public function clear(?fast:Bool):ITable {
		return each(function(v:Displayable) { v.empty(fast); } );
	}
	
	public function addTo(?target:Displayable):ITable {
		return each(function(v:Displayable) { v.addTo(target); } );
	}
	
	public function addToBody():ITable {
		return each(function(v:Displayable) { v.addToBody(); } );
	}
	
	public function length():Int {
		return content.length;
	}
	
	public function each(handler:Displayable->Void, ?onnull:Void->Void):ITable {
		if (content.length > 0){
			Dice.Values(content, handler);
		}else if(onnull != null){
			onnull();
		}
		return this;
	}
	
	public function call(method:String, ?args:Array<Dynamic>):ITable {
		Dice.Call(content, method, args);
		return this;
	}
	
	public function on(name:String, handler:Activation->Void, ?mode:Int):ITable {
		return each(function(v:Displayable) { v.events.on(name, handler, mode); });
	}
	
	public function merge(?tables:Array<Table>):ITable {
		var t:ITable = Table.empty();
		if (tables == null) tables = [];
		tables[tables.length] = this;
		Dice.Values(tables, function(v:Table) {
			t.content = t.content.concat(v.content);
		});
		return t;
	}
	
	public function dispose():Void {
		each(function(o:Displayable){ o.dispose(); });
		content = null;
		_trash[_trash.length] = this;
	}
	
	/* ============================== EVENT BATCH ============================================================================================== */
	
	public function onAbort(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("abort", handler, mode); }

	public function onBlur(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("blur", handler, mode); }

	public function onFocusIn(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("focusin", handler, mode); }

	public function onFocusOut(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("focusout", handler, mode); }

	public function onChange(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("change", handler, mode); }

	public function onClick(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("click", handler, mode); }

	public function onDblClick(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("dblclick", handler, mode); }

	public function onError(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("error", handler, mode); }

	public function onKeyDown(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("keydown", handler, mode); }

	public function onKeyPress(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("keypress", handler, mode); }

	public function onKeyUp(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("keyup", handler, mode); }

	public function onLoad(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("load", handler, mode); }

	public function onMouseDown(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("mousedown", handler, mode); }

	public function onMouseEnter(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("mouseenter", handler, mode); }

	public function onMouseLeave(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("mouseleave", handler, mode); }

	public function onMouseMove(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("mousemove", handler, mode); }

	public function onMouseOut(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("mouseout", handler, mode); }

	public function onMouseOver(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("mouseover", handler, mode); }

	public function onMouseUp(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("mouseup", handler, mode); }

	public function onScroll(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("scroll", handler, mode); }

	public function onTouchStart(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("touchstart", handler, mode); }

	public function onTouchEnd(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("touchend", handler, mode); }

	public function onTouchMove(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("touchmove", handler, mode); }

	public function onTouchCancel(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("touchcancel", handler, mode); }
	
	public function onWheel(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("wheel", handler, mode); }

	public function onVisibility(?handler:Activation->Void, ?mode:Dynamic):ITable { return on("visibility", handler, mode); }
	
}