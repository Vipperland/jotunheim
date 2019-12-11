package jotun.utils;

import haxe.ds.Either;
import haxe.Log;
import js.Browser;
import js.html.Element;
import js.html.HTMLCollection;
import js.html.NodeList;
import jotun.dom.Display;
import jotun.dom.Display3D;
import jotun.dom.IDisplay;
import jotun.dom.IDisplay3D;
import jotun.events.IEvent;
import jotun.tools.Utils;
import jotun.utils.ITable;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("jtn.utils.Table")
class Table implements ITable {
	
	static private var _trash:Array<ITable> = [];
	static public function recycle(q:String, ?t:Element):ITable {
		var r:ITable = null;
		if (_trash.length > 0)
			r = _trash.pop();
		else
			r = new Table();
		return r.scan(q, t);
	}
	
	//static public function em
	
	static public function empty():ITable {
		return new Table().reset();
	}
	
	public var content:Array<IDisplay>;
	
	public var elements:Array<Element>;
	
	public function new() {
	}
	
	public function reset():ITable {
		content = [];
		elements = [];
		return this;
	}
	
	public function scan(q:String, ?t:Element):ITable {
		reset();
		if (q == null)
			q = "*";
		if (t == null)
			t = cast Browser.document.body;
		var result:NodeList = q != "*" ? t.querySelectorAll(q) : t.childNodes;
		var element:Element = null;
		var obj:IDisplay = null;
		var len:UInt = result.length;
		
		if(len > 0){
			var ind:UInt = 0;
			while(ind < len){
				element = cast result.item(ind);
				if (element != null){
					obj = Utils.displayFrom(element);
					content[ind] = obj;
					elements[ind] = element;
				}
				++ind;
			}
		//}else {
			//Jotun.log("Table => " + (q != null ? q : (t != null ? t.className : "UNKNOW")) + " : EMPTY", 2);
		}
		return this;
	}
	
	public function contains(q:String):ITable {
		var t:ITable = empty();
		var i:Int = 0;
		each(function(v:IDisplay) {
			if (v.element.innerHTML.indexOf(q) != -1) {
				t.content[i] = v;
				t.elements[i] = v.element;
				++i;
			}
		});
		return t;
	}
	
	public function flush(handler:IDisplay->Void, ?complete:IDiceRoll->Void):ITable {
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
		each(function(v:IDisplay) { v.css(styles); } );
		return this;
	}
	
	public function attribute(name:String, value:String):ITable {
		each(function(v:IDisplay) {	v.attribute(name, value); } );
		return this;
	}
	
	public function attributes(values:Dynamic):ITable {
		each(function(v:IDisplay) {	v.attributes(values); });
		return this;
	}
	
	public function show():ITable {
		return each(function(v:IDisplay) { v.show(); } );
	}
	
	public function hide():ITable {
		return each(function(v:IDisplay) { v.hide(); } );
	}
	
	public function remove():ITable {
		return each(function(v:IDisplay) { v.remove(); } );
	}
	
	public function cursor(value:String):ITable {
		return each(function(v:IDisplay) { v.cursor(value); } );
	}
	
	public function clear(?fast:Bool):ITable {
		return each(function(v:IDisplay) { v.empty(fast); } );
	}
	
	public function addTo(?target:IDisplay):ITable {
		return each(function(v:IDisplay) { v.addTo(target); } );
	}
	
	public function addToBody():ITable {
		return each(function(v:IDisplay) { v.addToBody(); } );
	}
	
	public function length():Int {
		return content.length;
	}
	
	public function each(handler:IDisplay->Void):ITable {
		Dice.Values(content, handler);
		return this;
	}
	
	public function call(method:String, ?args:Array<Dynamic>):ITable {
		Dice.Call(content, method, args);
		return this;
	}
	
	public function on(name:String, handler:IEvent->Void, ?mode:Int):ITable {
		return each(function(v:IDisplay) { v.events.on(name, handler, mode); });
	}
	
	public function merge(?tables:Array<Table>):ITable {
		var t:ITable = Table.empty();
		if (tables == null) tables = [];
		tables[tables.length] = this;
		Dice.Values(tables, function(v:Table) {
			t.content = t.content.concat(v.content);
			t.elements = t.elements.concat(v.elements);
		});
		return t;
	}
	
	public function dispose():Void {
		each(function(o:IDisplay){ o.dispose(); });
		content = null;
		elements = null;
		_trash[_trash.length] = this;
	}
	
	/* ============================== EVENT BATCH ============================================================================================== */
	
	public function onWheel(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("wheel", handler, mode); }

	public function onCopy(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("copy", handler, mode); }

	public function onCut(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("cut", handler, mode); }

	public function onPaste(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("paste", handler, mode); }

	public function onAbort(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("abort", handler, mode); }

	public function onBlur(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("blur", handler, mode); }

	public function onFocusIn(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("focusin", handler, mode); }

	public function onFocusOut(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("focusout", handler, mode); }

	public function onCanPlay(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("canplay", handler, mode); }

	public function onCanPlayThrough(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("canplaythrough", handler, mode); }

	public function onChange(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("change", handler, mode); }

	public function onClick(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("click", handler, mode); }

	public function onContextMenu(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("contextmenu", handler, mode); }

	public function onDblClick(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("dblclick", handler, mode); }

	public function onDrag(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("drag", handler, mode); }

	public function onDragEnd(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("dragend", handler, mode); }

	public function onDragEnter(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("dragenter", handler, mode); }

	public function onDragLeave(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("dragleave", handler, mode); }

	public function onDragOver(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("dragover", handler, mode); }

	public function onDragStart(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("dragstart", handler, mode); }

	public function onDrop(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("drop", handler, mode); }

	public function onDurationChange(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("durationchange", handler, mode); }

	public function onEmptied(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("emptied", handler, mode); }

	public function onEnded(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("ended", handler, mode); }

	public function onInput(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("input", handler, mode); }

	public function onInvalid(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("invalid", handler, mode); }

	public function onKeyDown(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("keydown", handler, mode); }

	public function onKeyPress(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("keypress", handler, mode); }

	public function onKeyUp(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("keyup", handler, mode); }

	public function onLoad(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("load", handler, mode); }

	public function onLoadedData(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("loadeddata", handler, mode); }

	public function onLoadedMetadata(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("loadedmetadata", handler, mode); }

	public function onLoadStart(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("loadstart", handler, mode); }

	public function onMouseDown(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("mousedown", handler, mode); }

	public function onMouseEnter(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("mouseenter", handler, mode); }

	public function onMouseLeave(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("mouseleave", handler, mode); }

	public function onMouseMove(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("mousemove", handler, mode); }

	public function onMouseOut(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("mouseout", handler, mode); }

	public function onMouseOver(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("mouseover", handler, mode); }

	public function onMouseUp(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("mouseup", handler, mode); }

	public function onPause(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("pause", handler, mode); }

	public function onPlay(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("play", handler, mode); }

	public function onPlaying(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("playing", handler, mode); }

	public function onProgress(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("progress", handler, mode); }

	public function onRateChange(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("ratechange", handler, mode); }

	public function onReset(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("reset", handler, mode); }

	public function onScroll(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("scroll", handler, mode); }

	public function onSeeked(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("seeked", handler, mode); }

	public function onSeeking(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("seeking", handler, mode); }

	public function onSelect(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("select", handler, mode); }

	public function onShow(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("show", handler, mode); }

	public function onStalled(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("stalled", handler, mode); }

	public function onSubmit(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("submit", handler, mode); }

	public function onSuspend(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("suspend", handler, mode); }

	public function onTimeUpdate(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("timeupdate", handler, mode); }

	public function onVolumeChange(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("volumechange", handler, mode); }

	public function onWaiting(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("waiting", handler, mode); }

	public function onPointerCancel(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("pointercancel", handler, mode); }

	public function onPointerDown(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("pointerdown", handler, mode); }

	public function onPointerUp(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("pointerup", handler, mode); }

	public function onPointerMove(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("pointermove", handler, mode); }

	public function onPointerOut(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("pointerout", handler, mode); }

	public function onPointerOver(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("pointerover", handler, mode); }

	public function onPointerEnter(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("pointerenter", handler, mode); }

	public function onPointerLeave(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("pointerleave", handler, mode); }

	public function onGotPointerCapture(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("gotpointercapture", handler, mode); }

	public function onLostPointerCapture(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("lostpointercapture", handler, mode); }

	public function onPointerLockChange(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("pointerlockchange", handler, mode); }

	public function onPointerLockError(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("pointerlockerror", handler, mode); }

	public function onError(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("error", handler, mode); }

	public function onTouchStart(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("touchstart", handler, mode); }

	public function onTouchEnd(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("touchend", handler, mode); }

	public function onTouchMove(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("touchmove", handler, mode); }

	public function onTouchCancel(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("touchcancel", handler, mode); }
	
	public function onVisibility(?handler:IEvent->Void, ?mode:Dynamic):ITable { return on("visibility", handler, mode); }
	
	public function focusOverall(handler:IEvent->Void, ?mode:Dynamic):ITable { 
		return each(function(o:IDisplay) {	o.events.focusOverall(handler, mode); });
	}

}