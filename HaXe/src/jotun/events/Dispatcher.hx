package jotun.events;
import haxe.Log;
import jotun.dom.IDisplay;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("jtn.events.Dispatcher")
class Dispatcher implements IDispatcher {
	
	/**
	 * Prevent default event behaviour
	 * @param	e
	 */
	static public function PREVENT_DEFAULT(e:IEvent):Void {
		e.event.preventDefault();
	}
	
	/** @private */
	private var _b:Dynamic;
	
	/** @private */
	private var _e:Dynamic;
	
	/** @private */
	private var _i:Dynamic;
	
	/**
	 * Current event target
	 */
	public var target : IDisplay;
	
	/**
	 * Creates a new DISP (custom event dispatcher) instance
	 * The DISP control all event dispatched by an object, all handlers return an EVT instance [handler(EVT)]
	 * @param	q
	 */
	public function new(q:IDisplay){
		_b = { };
		_e = { };
		_i = { };
		target = q;
	}
	
	/**
	 * Get an Event by Type, create a new one if not exists
	 * @param	name
	 * @param	capture
	 * @return
	 */
	public function event(name:String):IEventGroup {
		var dis:IEventGroup = null;
		if (!hasEvent(name)) {
			dis = new EventGroup(this, name);
			dis.prepare(target);
			Reflect.setField(_e, name, dis);
		}else {
			dis = Reflect.field(_e, name);
		}
		return dis;
	}
	
	/**
	 * Check if an event type exists
	 * @param	name
	 * @return
	 */
	public function hasEvent(name:String):Bool {
		return Reflect.hasField(_e, name);
	}
	
	
	/**
	 * Start Element events
	 */
	public function apply():Void {
		Dice.Values(_e, function(v:IEventGroup){
			v.prepare(target);
		});
	}
	
	/**
	 * Versatile Init and assign or remove events
	 * @param	type		Type of the event
	 * @param	handler		Handler of event
	 * @param	mode		1 | true | "capture" to Add (capture=true), 0 | false to Add (capture=false), -1 | 'remove' to remove event if exists
	 * @return
	 */
	public function on(type:String, ?handler:Dynamic, ?mode:Int, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		var ie:IEventGroup = event(type);
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
	
	public function focusOverall(handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):Dynamic {
		return {
			"over":mouseOver(handler, mode),
			"out":mouseOut(handler, mode),
			"click":click(handler, mode),
		}
	}
	
	/** Event */
	public function added(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("DOMNodeInserted", handler, mode, noDefault, capture);
	}

	/** Event */
	public function removed(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("DOMNodeRemoved", handler, mode, noDefault, capture);
	}

	/** Event */
	public function wheel(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("wheel", handler, mode, noDefault, capture);
	}


	/** Event */
	public function copy(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("copy", handler, mode, noDefault, capture);
	}


	/** Event */
	public function cut(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("cut", handler, mode, noDefault, capture);
	}


	/** Event */
	public function paste(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("paste", handler, mode, noDefault, capture);
	}


	/** Event */
	public function abort(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("abort", handler, mode, noDefault, capture);
	}


	/** Event */
	public function blur(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("blur", handler, mode, noDefault, capture);
	}


	/** Event */
	public function focusIn(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("focusin", handler, mode, noDefault, capture);
	}


	/** Event */
	public function focusOut(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("focusout", handler, mode, noDefault, capture);
	}


	/** Event */
	public function canPlay(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("canplay", handler, mode, noDefault, capture);
	}


	/** Event */
	public function canPlayThrough(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("canplaythrough", handler, mode, noDefault, capture);
	}


	/** Event */
	public function change(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("change", handler, mode, noDefault, capture);
	}


	/** Event */
	public function click(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("click", handler, mode, noDefault, capture);
	}


	/** Event */
	public function contextMenu(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("contextmenu", handler, mode, noDefault, capture);
	}


	/** Event */
	public function dblClick(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("dblclick", handler, mode, noDefault, capture);
	}


	/** Event */
	public function drag(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("drag", handler, mode, noDefault, capture);
	}


	/** Event */
	public function dragEnd(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("dragend", handler, mode, noDefault, capture);
	}


	/** Event */
	public function dragEnter(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("dragenter", handler, mode, noDefault, capture);
	}


	/** Event */
	public function dragLeave(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("dragleave", handler, mode, noDefault, capture);
	}


	/** Event */
	public function dragOver(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("dragover", handler, mode, noDefault, capture);
	}


	/** Event */
	public function dragStart(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("dragstart", handler, mode, noDefault, capture);
	}


	/** Event */
	public function drop(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("drop", handler, mode, noDefault, capture);
	}


	/** Event */
	public function durationChange(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("durationchange", handler, mode, noDefault, capture);
	}


	/** Event */
	public function emptied(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("emptied", handler, mode, noDefault, capture);
	}


	/** Event */
	public function ended(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("ended", handler, mode, noDefault, capture);
	}


	/** Event */
	public function input(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("input", handler, mode, noDefault, capture);
	}


	/** Event */
	public function invalid(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("invalid", handler, mode, noDefault, capture);
	}


	/** Event */
	public function keyDown(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("keydown", handler, mode, noDefault, capture);
	}


	/** Event */
	public function keyPress(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("keypress", handler, mode, noDefault, capture);
	}


	/** Event */
	public function keyUp(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("keyup", handler, mode, noDefault, capture);
	}


	/** Event */
	public function load(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("load", handler, mode, noDefault, capture);
	}


	/** Event */
	public function loadedData(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("loadeddata", handler, mode, noDefault, capture);
	}


	/** Event */
	public function loadedMetadata(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("loadedmetadata", handler, mode, noDefault, capture);
	}


	/** Event */
	public function loadStart(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("loadstart", handler, mode, noDefault, capture);
	}


	/** Event */
	public function mouseDown(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("mousedown", handler, mode, noDefault, capture);
	}


	/** Event */
	public function mouseEnter(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("mouseenter", handler, mode, noDefault, capture);
	}


	/** Event */
	public function mouseLeave(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("mouseleave", handler, mode, noDefault, capture);
	}


	/** Event */
	public function mouseMove(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("mousemove", handler, mode, noDefault, capture);
	}


	/** Event */
	public function mouseOut(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("mouseout", handler, mode, noDefault, capture);
	}


	/** Event */
	public function mouseOver(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("mouseover", handler, mode, noDefault, capture);
	}


	/** Event */
	public function mouseUp(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("mouseup", handler, mode, noDefault, capture);
	}


	/** Event */
	public function pause(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("pause", handler, mode, noDefault, capture);
	}


	/** Event */
	public function play(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("play", handler, mode, noDefault, capture);
	}


	/** Event */
	public function playing(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("playing", handler, mode, noDefault, capture);
	}


	/** Event */
	public function progress(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("progress", handler, mode, noDefault, capture);
	}


	/** Event */
	public function rateChange(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("ratechange", handler, mode, noDefault, capture);
	}


	/** Event */
	public function reset(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("reset", handler, mode, noDefault, capture);
	}


	/** Event */
	public function scroll(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("scroll", handler, mode, noDefault, capture);
	}


	/** Event */
	public function seeked(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("seeked", handler, mode, noDefault, capture);
	}


	/** Event */
	public function seeking(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("seeking", handler, mode, noDefault, capture);
	}


	/** Event */
	public function select(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("select", handler, mode, noDefault, capture);
	}


	/** Event */
	public function show(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("show", handler, mode, noDefault, capture);
	}


	/** Event */
	public function stalled(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("stalled", handler, mode, noDefault, capture);
	}


	/** Event */
	public function submit(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("submit", handler, mode, noDefault, capture);
	}


	/** Event */
	public function suspEnd(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("suspend", handler, mode, noDefault, capture);
	}


	/** Event */
	public function timeUpdate(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("timeupdate", handler, mode, noDefault, capture);
	}


	/** Event */
	public function volumeChange(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("volumechange", handler, mode, noDefault, capture);
	}


	/** Event */
	public function waiting(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("waiting", handler, mode, noDefault, capture);
	}


	/** Event */
	public function pointerCancel(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("pointercancel", handler, mode, noDefault, capture);
	}


	/** Event */
	public function pointerDown(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("pointerdown", handler, mode, noDefault, capture);
	}


	/** Event */
	public function pointerUp(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("pointerup", handler, mode, noDefault, capture);
	}


	/** Event */
	public function pointerMove(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("pointermove", handler, mode, noDefault, capture);
	}


	/** Event */
	public function pointerOut(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("pointerout", handler, mode, noDefault, capture);
	}


	/** Event */
	public function pointerOver(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("pointerover", handler, mode, noDefault, capture);
	}


	/** Event */
	public function pointerEnter(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("pointerenter", handler, mode, noDefault, capture);
	}


	/** Event */
	public function pointerLeave(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("pointerleave", handler, mode, noDefault, capture);
	}


	/** Event */
	public function gotPointerCapture(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("gotpointercapture", handler, mode, noDefault, capture);
	}


	/** Event */
	public function lostPointerCapture(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("lostpointercapture", handler, mode, noDefault, capture);
	}


	/** Event */
	public function pointerLockChange(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("pointerlockchange", handler, mode, noDefault, capture);
	}


	/** Event */
	public function pointerLockError(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("pointerlockerror", handler, mode, noDefault, capture);
	}


	/** Event */
	public function error(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("error", handler, mode, noDefault, capture);
	}


	/** Event */
	public function touchStart(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("touchstart", handler, mode, noDefault, capture);
	}


	/** Event */
	public function touchEnd(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("touchend", handler, mode, noDefault, capture);
	}


	/** Event */
	public function touchMove(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("touchmove", handler, mode, noDefault, capture);
	}


	/** Event */
	public function touchCancel(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("touchcancel", handler, mode, noDefault, capture);
	}
	
	
	/** Event */
	public function readyState(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("readystatechange", handler, mode, noDefault, capture);
	}
	
	
	/** Event */
	public function visibility(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("visibility", handler, mode, noDefault, capture);
	}
	
	
	/** Event */
	public function resize(?handler:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool):IEventGroup {
		return on("resize", handler, mode, noDefault, capture);
	}
	
	/**	Remove all events */
	public function dispose():Void {
		Dice.Values(_e, function(v:IEventGroup) {
			v.dispose(target);
		});
	}
	
}