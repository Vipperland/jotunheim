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
	
	//static public function em
	
	static public function empty():Table {
		return new Table("NULL_TABLE");
	}
	
	public var content:Array<IDisplay>;
	
	public var elements:Array<Element>;
	
	public function new(?q:String="*", ?t:Element = null) {
		content = [];
		elements = [];
		if (q != "NULL_TABLE") {
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
					Sirius.log("TABLE(" + q + ") : NO RESULT", 10, 2);
				}
			}else {
				Sirius.log("TABLE(QUERY,TARGET) : NULL QUERY_SELECTOR", 10, 3);
			}
		}
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
	
	public function on(name:String, handler:Dynamic, ?mode:String):ITable {
		each(function(v:IDisplay) {
			v.events.auto(name, handler, mode);
		});
		return this;
	}
	
	public function merge(?tables:Array<Table>):Table {
		var t:Table = Table.empty();
		if (tables == null) tables = [];
		tables[tables.length] = this;
		Dice.Values(tables, function(v:Table) {
			t.content = t.content.concat(v.content);
			t.elements = t.elements.concat(v.elements);
		});
		return t;
	}
	
	/* ============================== EVENT BATCH ============================================================================================== */
	
	public function onWheel(?handler:Dynamic, ?mode:Dynamic):ITable { return on("wheel", handler, mode); }

	public function onCopy(?handler:Dynamic, ?mode:Dynamic):ITable { return on("copy", handler, mode); }

	public function onCut(?handler:Dynamic, ?mode:Dynamic):ITable { return on("cut", handler, mode); }

	public function onPaste(?handler:Dynamic, ?mode:Dynamic):ITable { return on("paste", handler, mode); }

	public function onAbort(?handler:Dynamic, ?mode:Dynamic):ITable { return on("abort", handler, mode); }

	public function onBlur(?handler:Dynamic, ?mode:Dynamic):ITable { return on("blur", handler, mode); }

	public function onFocusIn(?handler:Dynamic, ?mode:Dynamic):ITable { return on("focusin", handler, mode); }

	public function onFocusOut(?handler:Dynamic, ?mode:Dynamic):ITable { return on("focusout", handler, mode); }

	public function onCanPlay(?handler:Dynamic, ?mode:Dynamic):ITable { return on("canplay", handler, mode); }

	public function onCanPlayThrough(?handler:Dynamic, ?mode:Dynamic):ITable { return on("canplaythrough", handler, mode); }

	public function onChange(?handler:Dynamic, ?mode:Dynamic):ITable { return on("change", handler, mode); }

	public function onClick(?handler:Dynamic, ?mode:Dynamic):ITable { return on("click", handler, mode); }

	public function onContextMenu(?handler:Dynamic, ?mode:Dynamic):ITable { return on("contextmenu", handler, mode); }

	public function onDblClick(?handler:Dynamic, ?mode:Dynamic):ITable { return on("dblclick", handler, mode); }

	public function onDrag(?handler:Dynamic, ?mode:Dynamic):ITable { return on("drag", handler, mode); }

	public function onDragEnd(?handler:Dynamic, ?mode:Dynamic):ITable { return on("dragend", handler, mode); }

	public function onDragEnter(?handler:Dynamic, ?mode:Dynamic):ITable { return on("dragenter", handler, mode); }

	public function onDragLeave(?handler:Dynamic, ?mode:Dynamic):ITable { return on("dragleave", handler, mode); }

	public function onDragOver(?handler:Dynamic, ?mode:Dynamic):ITable { return on("dragover", handler, mode); }

	public function onDragStart(?handler:Dynamic, ?mode:Dynamic):ITable { return on("dragstart", handler, mode); }

	public function onDrop(?handler:Dynamic, ?mode:Dynamic):ITable { return on("drop", handler, mode); }

	public function onDurationChange(?handler:Dynamic, ?mode:Dynamic):ITable { return on("durationchange", handler, mode); }

	public function onEmptied(?handler:Dynamic, ?mode:Dynamic):ITable { return on("emptied", handler, mode); }

	public function onEnded(?handler:Dynamic, ?mode:Dynamic):ITable { return on("ended", handler, mode); }

	public function onInput(?handler:Dynamic, ?mode:Dynamic):ITable { return on("input", handler, mode); }

	public function onInvalid(?handler:Dynamic, ?mode:Dynamic):ITable { return on("invalid", handler, mode); }

	public function onKeyDown(?handler:Dynamic, ?mode:Dynamic):ITable { return on("keydown", handler, mode); }

	public function onKeyPress(?handler:Dynamic, ?mode:Dynamic):ITable { return on("keypress", handler, mode); }

	public function onKeyUp(?handler:Dynamic, ?mode:Dynamic):ITable { return on("keyup", handler, mode); }

	public function onLoad(?handler:Dynamic, ?mode:Dynamic):ITable { return on("load", handler, mode); }

	public function onLoadedData(?handler:Dynamic, ?mode:Dynamic):ITable { return on("loadeddata", handler, mode); }

	public function onLoadedMetadata(?handler:Dynamic, ?mode:Dynamic):ITable { return on("loadedmetadata", handler, mode); }

	public function onLoadStart(?handler:Dynamic, ?mode:Dynamic):ITable { return on("loadstart", handler, mode); }

	public function onMouseDown(?handler:Dynamic, ?mode:Dynamic):ITable { return on("mousedown", handler, mode); }

	public function onMouseEnter(?handler:Dynamic, ?mode:Dynamic):ITable { return on("mouseenter", handler, mode); }

	public function onMouseLeave(?handler:Dynamic, ?mode:Dynamic):ITable { return on("mouseleave", handler, mode); }

	public function onMouseMove(?handler:Dynamic, ?mode:Dynamic):ITable { return on("mousemove", handler, mode); }

	public function onMouseOut(?handler:Dynamic, ?mode:Dynamic):ITable { return on("mouseout", handler, mode); }

	public function onMouseOver(?handler:Dynamic, ?mode:Dynamic):ITable { return on("mouseover", handler, mode); }

	public function onMouseUp(?handler:Dynamic, ?mode:Dynamic):ITable { return on("mouseup", handler, mode); }

	public function onPause(?handler:Dynamic, ?mode:Dynamic):ITable { return on("pause", handler, mode); }

	public function onPlay(?handler:Dynamic, ?mode:Dynamic):ITable { return on("play", handler, mode); }

	public function onPlaying(?handler:Dynamic, ?mode:Dynamic):ITable { return on("playing", handler, mode); }

	public function onProgress(?handler:Dynamic, ?mode:Dynamic):ITable { return on("progress", handler, mode); }

	public function onRateChange(?handler:Dynamic, ?mode:Dynamic):ITable { return on("ratechange", handler, mode); }

	public function onReset(?handler:Dynamic, ?mode:Dynamic):ITable { return on("reset", handler, mode); }

	public function onScroll(?handler:Dynamic, ?mode:Dynamic):ITable { return on("scroll", handler, mode); }

	public function onSeeked(?handler:Dynamic, ?mode:Dynamic):ITable { return on("seeked", handler, mode); }

	public function onSeeking(?handler:Dynamic, ?mode:Dynamic):ITable { return on("seeking", handler, mode); }

	public function onSelect(?handler:Dynamic, ?mode:Dynamic):ITable { return on("select", handler, mode); }

	public function onShow(?handler:Dynamic, ?mode:Dynamic):ITable { return on("show", handler, mode); }

	public function onStalled(?handler:Dynamic, ?mode:Dynamic):ITable { return on("stalled", handler, mode); }

	public function onSubmit(?handler:Dynamic, ?mode:Dynamic):ITable { return on("submit", handler, mode); }

	public function onSuspend(?handler:Dynamic, ?mode:Dynamic):ITable { return on("suspend", handler, mode); }

	public function onTimeUpdate(?handler:Dynamic, ?mode:Dynamic):ITable { return on("timeupdate", handler, mode); }

	public function onVolumeChange(?handler:Dynamic, ?mode:Dynamic):ITable { return on("volumechange", handler, mode); }

	public function onWaiting(?handler:Dynamic, ?mode:Dynamic):ITable { return on("waiting", handler, mode); }

	public function onPointerCancel(?handler:Dynamic, ?mode:Dynamic):ITable { return on("pointercancel", handler, mode); }

	public function onPointerDown(?handler:Dynamic, ?mode:Dynamic):ITable { return on("pointerdown", handler, mode); }

	public function onPointerUp(?handler:Dynamic, ?mode:Dynamic):ITable { return on("pointerup", handler, mode); }

	public function onPointerMove(?handler:Dynamic, ?mode:Dynamic):ITable { return on("pointermove", handler, mode); }

	public function onPointerOut(?handler:Dynamic, ?mode:Dynamic):ITable { return on("pointerout", handler, mode); }

	public function onPointerOver(?handler:Dynamic, ?mode:Dynamic):ITable { return on("pointerover", handler, mode); }

	public function onPointerEnter(?handler:Dynamic, ?mode:Dynamic):ITable { return on("pointerenter", handler, mode); }

	public function onPointerLeave(?handler:Dynamic, ?mode:Dynamic):ITable { return on("pointerleave", handler, mode); }

	public function onGotPointerCapture(?handler:Dynamic, ?mode:Dynamic):ITable { return on("gotpointercapture", handler, mode); }

	public function onLostPointerCapture(?handler:Dynamic, ?mode:Dynamic):ITable { return on("lostpointercapture", handler, mode); }

	public function onPointerLockChange(?handler:Dynamic, ?mode:Dynamic):ITable { return on("pointerlockchange", handler, mode); }

	public function onPointerLockError(?handler:Dynamic, ?mode:Dynamic):ITable { return on("pointerlockerror", handler, mode); }

	public function onError(?handler:Dynamic, ?mode:Dynamic):ITable { return on("error", handler, mode); }

	public function onTouchStart(?handler:Dynamic, ?mode:Dynamic):ITable { return on("touchstart", handler, mode); }

	public function onTouchEnd(?handler:Dynamic, ?mode:Dynamic):ITable { return on("touchend", handler, mode); }

	public function onTouchMove(?handler:Dynamic, ?mode:Dynamic):ITable { return on("touchmove", handler, mode); }

	public function onTouchCancel(?handler:Dynamic, ?mode:Dynamic):ITable { return on("touchcancel", handler, mode); }

}