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
				Sirius.log("TABLE(" + q + ") : NO RESULT", 10, 2);
			}
		}else {
			Sirius.log("TABLE(QUERY,TARGET) : NULL QUERY_SELECTOR", 10, 3);
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
	
	public function on(name:String, handler:Dynamic, ?mode:String):ITable {
		each(function(v:IDisplay) {
			v.dispatcher.auto(name, handler, mode);
		});
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
	
	/** Event */
	public function onWheel(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("wheel", handler, mode);
	}


	/** Event */
	public function onCopy(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("copy", handler, mode);
	}


	/** Event */
	public function onCut(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("cut", handler, mode);
	}


	/** Event */
	public function onPaste(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("paste", handler, mode);
	}


	/** Event */
	public function onAbort(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("abort", handler, mode);
	}


	/** Event */
	public function onBlur(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("blur", handler, mode);
	}


	/** Event */
	public function onFocusIn(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("focusin", handler, mode);
	}


	/** Event */
	public function onFocusOut(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("focusout", handler, mode);
	}


	/** Event */
	public function onCanPlay(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("canplay", handler, mode);
	}


	/** Event */
	public function onCanPlayThrough(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("canplaythrough", handler, mode);
	}


	/** Event */
	public function onChange(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("change", handler, mode);
	}


	/** Event */
	public function onClick(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("click", handler, mode);
	}


	/** Event */
	public function onContextMenu(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("contextmenu", handler, mode);
	}


	/** Event */
	public function onDblClick(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("dblclick", handler, mode);
	}


	/** Event */
	public function onDrag(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("drag", handler, mode);
	}


	/** Event */
	public function onDragEnd(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("dragend", handler, mode);
	}


	/** Event */
	public function onDragEnter(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("dragenter", handler, mode);
	}


	/** Event */
	public function onDragLeave(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("dragleave", handler, mode);
	}


	/** Event */
	public function onDragOver(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("dragover", handler, mode);
	}


	/** Event */
	public function onDragStart(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("dragstart", handler, mode);
	}


	/** Event */
	public function onDrop(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("drop", handler, mode);
	}


	/** Event */
	public function onDurationChange(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("durationchange", handler, mode);
	}


	/** Event */
	public function onEmptied(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("emptied", handler, mode);
	}


	/** Event */
	public function onEnded(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("ended", handler, mode);
	}


	/** Event */
	public function onInput(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("input", handler, mode);
	}


	/** Event */
	public function onInvalid(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("invalid", handler, mode);
	}


	/** Event */
	public function onKeyDown(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("keydown", handler, mode);
	}


	/** Event */
	public function onKeyPress(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("keypress", handler, mode);
	}


	/** Event */
	public function onKeyUp(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("keyup", handler, mode);
	}


	/** Event */
	public function onLoad(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("load", handler, mode);
	}


	/** Event */
	public function onLoadedData(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("loadeddata", handler, mode);
	}


	/** Event */
	public function onLoadedMetadata(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("loadedmetadata", handler, mode);
	}


	/** Event */
	public function onLoadStart(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("loadstart", handler, mode);
	}


	/** Event */
	public function onMouseDown(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("mousedown", handler, mode);
	}


	/** Event */
	public function onMouseEnter(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("mouseenter", handler, mode);
	}


	/** Event */
	public function onMouseLeave(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("mouseleave", handler, mode);
	}


	/** Event */
	public function onMouseMove(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("mousemove", handler, mode);
	}


	/** Event */
	public function onMouseOut(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("mouseout", handler, mode);
	}


	/** Event */
	public function onMouseOver(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("mouseover", handler, mode);
	}


	/** Event */
	public function onMouseUp(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("mouseup", handler, mode);
	}


	/** Event */
	public function onPause(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("pause", handler, mode);
	}


	/** Event */
	public function onPlay(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("play", handler, mode);
	}


	/** Event */
	public function onPlaying(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("playing", handler, mode);
	}


	/** Event */
	public function onProgress(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("progress", handler, mode);
	}


	/** Event */
	public function onRateChange(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("ratechange", handler, mode);
	}


	/** Event */
	public function onReset(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("reset", handler, mode);
	}


	/** Event */
	public function onScroll(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("scroll", handler, mode);
	}


	/** Event */
	public function onSeeked(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("seeked", handler, mode);
	}


	/** Event */
	public function onSeeking(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("seeking", handler, mode);
	}


	/** Event */
	public function onSelect(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("select", handler, mode);
	}


	/** Event */
	public function onShow(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("show", handler, mode);
	}


	/** Event */
	public function onStalled(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("stalled", handler, mode);
	}


	/** Event */
	public function onSubmit(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("submit", handler, mode);
	}


	/** Event */
	public function onSuspend(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("suspend", handler, mode);
	}


	/** Event */
	public function onTimeUpdate(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("timeupdate", handler, mode);
	}


	/** Event */
	public function onVolumeChange(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("volumechange", handler, mode);
	}


	/** Event */
	public function onWaiting(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("waiting", handler, mode);
	}


	/** Event */
	public function onPointerCancel(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("pointercancel", handler, mode);
	}


	/** Event */
	public function onPointerDown(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("pointerdown", handler, mode);
	}


	/** Event */
	public function onPointerUp(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("pointerup", handler, mode);
	}


	/** Event */
	public function onPointerMove(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("pointermove", handler, mode);
	}


	/** Event */
	public function onPointerOut(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("pointerout", handler, mode);
	}


	/** Event */
	public function onPointerOver(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("pointerover", handler, mode);
	}


	/** Event */
	public function onPointerEnter(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("pointerenter", handler, mode);
	}


	/** Event */
	public function onPointerLeave(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("pointerleave", handler, mode);
	}


	/** Event */
	public function onGotPointerCapture(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("gotpointercapture", handler, mode);
	}


	/** Event */
	public function onLostPointerCapture(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("lostpointercapture", handler, mode);
	}


	/** Event */
	public function onPointerLockChange(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("pointerlockchange", handler, mode);
	}


	/** Event */
	public function onPointerLockError(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("pointerlockerror", handler, mode);
	}


	/** Event */
	public function onError(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("error", handler, mode);
	}


	/** Event */
	public function onTouchStart(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("touchstart", handler, mode);
	}


	/** Event */
	public function onTouchEnd(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("touchend", handler, mode);
	}


	/** Event */
	public function onTouchMove(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("touchmove", handler, mode);
	}


	/** Event */
	public function onTouchCancel(?handler:Dynamic, ?mode:Dynamic):ITable {
		return on("touchcancel", handler, mode);
	}
	
}