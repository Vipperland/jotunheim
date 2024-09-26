package jotun.events;
import haxe.Log;
import jotun.dom.Displayable;
import jotun.events.EventGroup;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_Dispatcher")
class Dispatcher {
	
	/**
	 * Prevent default event behaviour
	 * @param	e
	 */
	static public function PREVENT_DEFAULT(e:Activation):Void {
		e.event.preventDefault();
	}
	
	/**
	 * Current event target
	 */
	public var target : Displayable;
	
	/** @private */
	private function _e():Dynamic {
		return target.data._events;
	}
	
	/**
	 * Creates a new DISP (custom event dispatcher) instance
	 * The DISP control all event dispatched by an object, all handlers return an EVT instance [handler(EVT)]
	 * @param	q
	 */
	public function new(q:Displayable){
		q.data._events = { };
		target = q;
	}
	
	/**
	 * Get an Event by Type, create a new one if not exists
	 * @param	name
	 * @param	capture
	 * @return
	 */
	public function event(name:String):EventGroup {
		var dis:EventGroup = null;
		if (!hasEvent(name)) {
			dis = new EventGroup(this, name);
			dis.prepare(target);
			Reflect.setField(_e(), name, dis);
		}else {
			dis = Reflect.field(_e(), name);
		}
		return dis;
	}
	
	/**
	 * Check if an event type exists
	 * @param	name
	 * @return
	 */
	public function hasEvent(name:String):Bool {
		return Reflect.hasField(_e(), name);
	}
	
	
	/**
	 * Start Element events
	 */
	public function apply():Void {
		Dice.Values(_e(), function(v:EventGroup){
			v.prepare(target);
		});
	}
	
	public function each(method:EventGroup->Bool):Void {
		Dice.Values(_e(), function(v:EventGroup):Bool {
			return method(v);
		});
	}
	
	/**
	 * Versatile Init and assign or remove events
	 * @param	type		Type of the event
	 * @param	handler		Handler of event
	 * @param	mode		1 | true | "capture" to Add (capture=true), 0 | false to Add (capture=false), -1 | 'remove' to remove event if exists
	 * @return
	 */
	public function on(type:String, ?handler:Dynamic, ?mode:Int, ?noDefault:Bool, ?capture:Bool):EventGroup {
		var ie:EventGroup = event(type);
		if (noDefault){
			ie.noDefault();
		}
		if (handler == true){
			ie.call();
		}else if (handler != null){
			if (mode < 0){
				ie.remove(handler);
			}else if(mode > 0){
				ie.addOnce(handler, capture);
			}else{
				ie.add(handler, capture);
			}
		}
		return ie;
	}
	
	/** Event */
	public function added(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("DOMNodeInserted", handler, mode, noDefault, capture);
	}

	/** Event */
	public function removed(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("DOMNodeRemoved", handler, mode, noDefault, capture);
	}

	/** Event */
	public function wheel(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("wheel", handler, mode, noDefault, capture);
	}


	/** Event */
	public function copy(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("copy", handler, mode, noDefault, capture);
	}


	/** Event */
	public function cut(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("cut", handler, mode, noDefault, capture);
	}


	/** Event */
	public function paste(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("paste", handler, mode, noDefault, capture);
	}


	/** Event */
	public function abort(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("abort", handler, mode, noDefault, capture);
	}


	/** Event */
	public function blur(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("blur", handler, mode, noDefault, capture);
	}


	/** Event */
	public function focusIn(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("focusin", handler, mode, noDefault, capture);
	}


	/** Event */
	public function focusOut(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("focusout", handler, mode, noDefault, capture);
	}


	/** Event */
	public function canPlay(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("canplay", handler, mode, noDefault, capture);
	}


	/** Event */
	public function canPlayThrough(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("canplaythrough", handler, mode, noDefault, capture);
	}


	/** Event */
	public function change(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("change", handler, mode, noDefault, capture);
	}


	/** Event */
	public function click(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("click", handler, mode, noDefault, capture);
	}


	/** Event */
	public function contextMenu(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("contextmenu", handler, mode, noDefault, capture);
	}


	/** Event */
	public function dblClick(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("dblclick", handler, mode, noDefault, capture);
	}


	/** Event */
	public function drag(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("drag", handler, mode, noDefault, capture);
	}


	/** Event */
	public function dragEnd(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("dragend", handler, mode, noDefault, capture);
	}


	/** Event */
	public function dragEnter(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("dragenter", handler, mode, noDefault, capture);
	}


	/** Event */
	public function dragLeave(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("dragleave", handler, mode, noDefault, capture);
	}


	/** Event */
	public function dragOver(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("dragover", handler, mode, noDefault, capture);
	}


	/** Event */
	public function dragStart(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("dragstart", handler, mode, noDefault, capture);
	}


	/** Event */
	public function drop(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("drop", handler, mode, noDefault, capture);
	}


	/** Event */
	public function durationChange(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("durationchange", handler, mode, noDefault, capture);
	}


	/** Event */
	public function emptied(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("emptied", handler, mode, noDefault, capture);
	}


	/** Event */
	public function ended(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("ended", handler, mode, noDefault, capture);
	}


	/** Event */
	public function input(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("input", handler, mode, noDefault, capture);
	}


	/** Event */
	public function invalid(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("invalid", handler, mode, noDefault, capture);
	}


	/** Event */
	public function keyDown(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("keydown", handler, mode, noDefault, capture);
	}


	/** Event */
	public function keyPress(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("keypress", handler, mode, noDefault, capture);
	}


	/** Event */
	public function keyUp(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("keyup", handler, mode, noDefault, capture);
	}


	/** Event */
	public function load(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("load", handler, mode, noDefault, capture);
	}


	/** Event */
	public function loadedData(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("loadeddata", handler, mode, noDefault, capture);
	}


	/** Event */
	public function loadedMetadata(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("loadedmetadata", handler, mode, noDefault, capture);
	}


	/** Event */
	public function loadStart(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("loadstart", handler, mode, noDefault, capture);
	}


	/** Event */
	public function mouseDown(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("mousedown", handler, mode, noDefault, capture);
	}


	/** Event */
	public function mouseEnter(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("mouseenter", handler, mode, noDefault, capture);
	}


	/** Event */
	public function mouseLeave(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("mouseleave", handler, mode, noDefault, capture);
	}


	/** Event */
	public function mouseMove(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("mousemove", handler, mode, noDefault, capture);
	}


	/** Event */
	public function mouseOut(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("mouseout", handler, mode, noDefault, capture);
	}


	/** Event */
	public function mouseOver(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("mouseover", handler, mode, noDefault, capture);
	}


	/** Event */
	public function mouseUp(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("mouseup", handler, mode, noDefault, capture);
	}


	/** Event */
	public function pause(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("pause", handler, mode, noDefault, capture);
	}


	/** Event */
	public function play(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("play", handler, mode, noDefault, capture);
	}


	/** Event */
	public function playing(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("playing", handler, mode, noDefault, capture);
	}


	/** Event */
	public function progress(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("progress", handler, mode, noDefault, capture);
	}


	/** Event */
	public function rateChange(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("ratechange", handler, mode, noDefault, capture);
	}


	/** Event */
	public function reset(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("reset", handler, mode, noDefault, capture);
	}


	/** Event */
	public function scroll(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("scroll", handler, mode, noDefault, capture);
	}


	/** Event */
	public function seeked(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("seeked", handler, mode, noDefault, capture);
	}


	/** Event */
	public function seeking(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("seeking", handler, mode, noDefault, capture);
	}


	/** Event */
	public function select(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("select", handler, mode, noDefault, capture);
	}


	/** Event */
	public function show(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("show", handler, mode, noDefault, capture);
	}


	/** Event */
	public function stalled(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("stalled", handler, mode, noDefault, capture);
	}


	/** Event */
	public function submit(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("submit", handler, mode, noDefault, capture);
	}


	/** Event */
	public function suspEnd(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("suspend", handler, mode, noDefault, capture);
	}


	/** Event */
	public function timeUpdate(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("timeupdate", handler, mode, noDefault, capture);
	}


	/** Event */
	public function volumeChange(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("volumechange", handler, mode, noDefault, capture);
	}


	/** Event */
	public function waiting(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("waiting", handler, mode, noDefault, capture);
	}


	/** Event */
	public function pointerCancel(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("pointercancel", handler, mode, noDefault, capture);
	}


	/** Event */
	public function pointerDown(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("pointerdown", handler, mode, noDefault, capture);
	}


	/** Event */
	public function pointerUp(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("pointerup", handler, mode, noDefault, capture);
	}


	/** Event */
	public function pointerMove(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("pointermove", handler, mode, noDefault, capture);
	}


	/** Event */
	public function pointerOut(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("pointerout", handler, mode, noDefault, capture);
	}


	/** Event */
	public function pointerOver(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("pointerover", handler, mode, noDefault, capture);
	}


	/** Event */
	public function pointerEnter(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("pointerenter", handler, mode, noDefault, capture);
	}


	/** Event */
	public function pointerLeave(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("pointerleave", handler, mode, noDefault, capture);
	}


	/** Event */
	public function gotPointerCapture(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("gotpointercapture", handler, mode, noDefault, capture);
	}


	/** Event */
	public function lostPointerCapture(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("lostpointercapture", handler, mode, noDefault, capture);
	}


	/** Event */
	public function pointerLockChange(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("pointerlockchange", handler, mode, noDefault, capture);
	}


	/** Event */
	public function pointerLockError(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("pointerlockerror", handler, mode, noDefault, capture);
	}


	/** Event */
	public function error(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("error", handler, mode, noDefault, capture);
	}


	/** Event */
	public function touchStart(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("touchstart", handler, mode, noDefault, capture);
	}


	/** Event */
	public function touchEnd(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("touchend", handler, mode, noDefault, capture);
	}


	/** Event */
	public function touchMove(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("touchmove", handler, mode, noDefault, capture);
	}


	/** Event */
	public function touchCancel(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("touchcancel", handler, mode, noDefault, capture);
	}
	
	
	/** Event */
	public function readyState(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("readystatechange", handler, mode, noDefault, capture);
	}
	
	
	/** Event */
	public function visibility(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("visibility", handler, mode, noDefault, capture);
	}
	
	
	/** Event */
	public function resize(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):EventGroup {
		return on("resize", handler, mode, noDefault, capture);
	}
	
	/** Remove all events */
	public function dispose():Void {
		Dice.Values(_e(), function(v:EventGroup) {
			v.dispose(target);
		});
	}
	
	/** Clone all event methods */
	public function cloneFrom(origin:Dispatcher):Dispatcher {
		Dice.All((cast origin)._e(), function(p:String, v:EventGroup):Void {
			on(p).cloneFrom(v);
		});
		return this;
	}
	
}