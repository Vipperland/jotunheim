package sirius.events;
import haxe.Log;
import sirius.dom.IDisplay;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.events.Dispatcher")
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
	public function on(type:String, ?handler:IEvent->Void, ?mode:Int):IEventGroup {
		var ie:IEventGroup = event(type);
		if (handler == null){
			ie.call();
			return ie;
		}else{
			return switch(mode) {
				case 2, 3 : ie.add(handler, mode == 3).noDefault();
				case 1 : ie.add(handler, true);
				case null, 0 : ie.add(handler, false);
				case -1 : ie.remove(handler);
				default : ie;
			}
		}
	}
	
	public function focusOverall(handler:IEvent->Void, ?mode:Dynamic):Dynamic {
		return {
			"over":mouseOver(handler, mode),
			"out":mouseOut(handler, mode),
			"click":click(handler, mode),
		}
	}
	
	/** Event */
	public function added(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("DOMNodeInserted", handler, mode);
	}

	/** Event */
	public function removed(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("DOMNodeRemoved", handler, mode);
	}

	/** Event */
	public function wheel(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("wheel", handler, mode);
	}


	/** Event */
	public function copy(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("copy", handler, mode);
	}


	/** Event */
	public function cut(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("cut", handler, mode);
	}


	/** Event */
	public function paste(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("paste", handler, mode);
	}


	/** Event */
	public function abort(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("abort", handler, mode);
	}


	/** Event */
	public function blur(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("blur", handler, mode);
	}


	/** Event */
	public function focusIn(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("focusin", handler, mode);
	}


	/** Event */
	public function focusOut(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("focusout", handler, mode);
	}


	/** Event */
	public function canPlay(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("canplay", handler, mode);
	}


	/** Event */
	public function canPlayThrough(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("canplaythrough", handler, mode);
	}


	/** Event */
	public function change(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("change", handler, mode);
	}


	/** Event */
	public function click(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("click", handler, mode);
	}


	/** Event */
	public function contextMenu(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("contextmenu", handler, mode);
	}


	/** Event */
	public function dblClick(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("dblclick", handler, mode);
	}


	/** Event */
	public function drag(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("drag", handler, mode);
	}


	/** Event */
	public function dragEnd(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("dragend", handler, mode);
	}


	/** Event */
	public function dragEnter(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("dragenter", handler, mode);
	}


	/** Event */
	public function dragLeave(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("dragleave", handler, mode);
	}


	/** Event */
	public function dragOver(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("dragover", handler, mode);
	}


	/** Event */
	public function dragStart(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("dragstart", handler, mode);
	}


	/** Event */
	public function drop(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("drop", handler, mode);
	}


	/** Event */
	public function durationChange(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("durationchange", handler, mode);
	}


	/** Event */
	public function emptied(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("emptied", handler, mode);
	}


	/** Event */
	public function ended(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("ended", handler, mode);
	}


	/** Event */
	public function input(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("input", handler, mode);
	}


	/** Event */
	public function invalid(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("invalid", handler, mode);
	}


	/** Event */
	public function keyDown(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("keydown", handler, mode);
	}


	/** Event */
	public function keyPress(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("keypress", handler, mode);
	}


	/** Event */
	public function keyUp(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("keyup", handler, mode);
	}


	/** Event */
	public function load(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("load", handler, mode);
	}


	/** Event */
	public function loadedData(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("loadeddata", handler, mode);
	}


	/** Event */
	public function loadedMetadata(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("loadedmetadata", handler, mode);
	}


	/** Event */
	public function loadStart(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("loadstart", handler, mode);
	}


	/** Event */
	public function mouseDown(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("mousedown", handler, mode);
	}


	/** Event */
	public function mouseEnter(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("mouseenter", handler, mode);
	}


	/** Event */
	public function mouseLeave(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("mouseleave", handler, mode);
	}


	/** Event */
	public function mouseMove(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("mousemove", handler, mode);
	}


	/** Event */
	public function mouseOut(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("mouseout", handler, mode);
	}


	/** Event */
	public function mouseOver(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("mouseover", handler, mode);
	}


	/** Event */
	public function mouseUp(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("mouseup", handler, mode);
	}


	/** Event */
	public function pause(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("pause", handler, mode);
	}


	/** Event */
	public function play(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("play", handler, mode);
	}


	/** Event */
	public function playing(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("playing", handler, mode);
	}


	/** Event */
	public function progress(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("progress", handler, mode);
	}


	/** Event */
	public function rateChange(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("ratechange", handler, mode);
	}


	/** Event */
	public function reset(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("reset", handler, mode);
	}


	/** Event */
	public function scroll(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("scroll", handler, mode);
	}


	/** Event */
	public function seeked(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("seeked", handler, mode);
	}


	/** Event */
	public function seeking(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("seeking", handler, mode);
	}


	/** Event */
	public function select(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("select", handler, mode);
	}


	/** Event */
	public function show(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("show", handler, mode);
	}


	/** Event */
	public function stalled(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("stalled", handler, mode);
	}


	/** Event */
	public function submit(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("submit", handler, mode);
	}


	/** Event */
	public function suspEnd(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("suspend", handler, mode);
	}


	/** Event */
	public function timeUpdate(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("timeupdate", handler, mode);
	}


	/** Event */
	public function volumeChange(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("volumechange", handler, mode);
	}


	/** Event */
	public function waiting(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("waiting", handler, mode);
	}


	/** Event */
	public function pointerCancel(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("pointercancel", handler, mode);
	}


	/** Event */
	public function pointerDown(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("pointerdown", handler, mode);
	}


	/** Event */
	public function pointerUp(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("pointerup", handler, mode);
	}


	/** Event */
	public function pointerMove(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("pointermove", handler, mode);
	}


	/** Event */
	public function pointerOut(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("pointerout", handler, mode);
	}


	/** Event */
	public function pointerOver(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("pointerover", handler, mode);
	}


	/** Event */
	public function pointerEnter(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("pointerenter", handler, mode);
	}


	/** Event */
	public function pointerLeave(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("pointerleave", handler, mode);
	}


	/** Event */
	public function gotPointerCapture(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("gotpointercapture", handler, mode);
	}


	/** Event */
	public function lostPointerCapture(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("lostpointercapture", handler, mode);
	}


	/** Event */
	public function pointerLockChange(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("pointerlockchange", handler, mode);
	}


	/** Event */
	public function pointerLockError(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("pointerlockerror", handler, mode);
	}


	/** Event */
	public function error(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("error", handler, mode);
	}


	/** Event */
	public function touchStart(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("touchstart", handler, mode);
	}


	/** Event */
	public function touchEnd(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("touchend", handler, mode);
	}


	/** Event */
	public function touchMove(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("touchmove", handler, mode);
	}


	/** Event */
	public function touchCancel(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("touchcancel", handler, mode);
	}
	
	
	/** Event */
	public function readyState(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("readystatechange", handler, mode);
	}
	
	
	/** Event */
	public function visibility(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("visibility", handler, mode);
	}
	
	
	/** Event */
	public function resize(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return on("resize", handler, mode);
	}
	
	/**	Remove all events */
	public function dispose():Void {
		Dice.Values(_e, function(v:IEventGroup) {
			v.dispose(target);
		});
	}
	
}