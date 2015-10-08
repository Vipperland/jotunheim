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
	public function auto(type:String, ?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		var ie:IEventGroup = event(type);
		return switch(mode) {
			case 1, true , "capture" : ie.add(handler, true);
			case null, 0, false : ie.add(handler, false);
			case -1, "remove" : ie.remove(handler);
			default : ie;
		}
	}
	
	/** Event */
	public function wheel(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("wheel", handler, mode);
	}


	/** Event */
	public function copy(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("copy", handler, mode);
	}


	/** Event */
	public function cut(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("cut", handler, mode);
	}


	/** Event */
	public function paste(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("paste", handler, mode);
	}


	/** Event */
	public function abort(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("abort", handler, mode);
	}


	/** Event */
	public function blur(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("blur", handler, mode);
	}


	/** Event */
	public function focusIn(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("focusin", handler, mode);
	}


	/** Event */
	public function focusOut(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("focusout", handler, mode);
	}


	/** Event */
	public function canPlay(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("canplay", handler, mode);
	}


	/** Event */
	public function canPlayThrough(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("canplaythrough", handler, mode);
	}


	/** Event */
	public function change(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("change", handler, mode);
	}


	/** Event */
	public function click(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("click", handler, mode);
	}


	/** Event */
	public function contextMenu(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("contextmenu", handler, mode);
	}


	/** Event */
	public function dblClick(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("dblclick", handler, mode);
	}


	/** Event */
	public function drag(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("drag", handler, mode);
	}


	/** Event */
	public function dragEnd(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("dragend", handler, mode);
	}


	/** Event */
	public function dragEnter(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("dragenter", handler, mode);
	}


	/** Event */
	public function dragLeave(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("dragleave", handler, mode);
	}


	/** Event */
	public function dragOver(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("dragover", handler, mode);
	}


	/** Event */
	public function dragStart(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("dragstart", handler, mode);
	}


	/** Event */
	public function drop(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("drop", handler, mode);
	}


	/** Event */
	public function durationChange(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("durationchange", handler, mode);
	}


	/** Event */
	public function emptied(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("emptied", handler, mode);
	}


	/** Event */
	public function ended(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("ended", handler, mode);
	}


	/** Event */
	public function input(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("input", handler, mode);
	}


	/** Event */
	public function invalid(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("invalid", handler, mode);
	}


	/** Event */
	public function keyDown(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("keydown", handler, mode);
	}


	/** Event */
	public function keyPress(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("keypress", handler, mode);
	}


	/** Event */
	public function keyUp(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("keyup", handler, mode);
	}


	/** Event */
	public function load(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("load", handler, mode);
	}


	/** Event */
	public function loadedData(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("loadeddata", handler, mode);
	}


	/** Event */
	public function loadedMetadata(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("loadedmetadata", handler, mode);
	}


	/** Event */
	public function loadStart(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("loadstart", handler, mode);
	}


	/** Event */
	public function mouseDown(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("mousedown", handler, mode);
	}


	/** Event */
	public function mouseEnter(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("mouseenter", handler, mode);
	}


	/** Event */
	public function mouseLeave(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("mouseleave", handler, mode);
	}


	/** Event */
	public function mouseMove(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("mousemove", handler, mode);
	}


	/** Event */
	public function mouseOut(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("mouseout", handler, mode);
	}


	/** Event */
	public function mouseOver(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("mouseover", handler, mode);
	}


	/** Event */
	public function mouseUp(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("mouseup", handler, mode);
	}


	/** Event */
	public function pause(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("pause", handler, mode);
	}


	/** Event */
	public function play(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("play", handler, mode);
	}


	/** Event */
	public function playing(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("playing", handler, mode);
	}


	/** Event */
	public function progress(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("progress", handler, mode);
	}


	/** Event */
	public function rateChange(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("ratechange", handler, mode);
	}


	/** Event */
	public function reset(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("reset", handler, mode);
	}


	/** Event */
	public function scroll(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("scroll", handler, mode);
	}


	/** Event */
	public function seeked(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("seeked", handler, mode);
	}


	/** Event */
	public function seeking(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("seeking", handler, mode);
	}


	/** Event */
	public function select(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("select", handler, mode);
	}


	/** Event */
	public function show(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("show", handler, mode);
	}


	/** Event */
	public function stalled(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("stalled", handler, mode);
	}


	/** Event */
	public function submit(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("submit", handler, mode);
	}


	/** Event */
	public function suspEnd(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("suspend", handler, mode);
	}


	/** Event */
	public function timeUpdate(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("timeupdate", handler, mode);
	}


	/** Event */
	public function volumeChange(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("volumechange", handler, mode);
	}


	/** Event */
	public function waiting(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("waiting", handler, mode);
	}


	/** Event */
	public function pointerCancel(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("pointercancel", handler, mode);
	}


	/** Event */
	public function pointerDown(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("pointerdown", handler, mode);
	}


	/** Event */
	public function pointerUp(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("pointerup", handler, mode);
	}


	/** Event */
	public function pointerMove(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("pointermove", handler, mode);
	}


	/** Event */
	public function pointerOut(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("pointerout", handler, mode);
	}


	/** Event */
	public function pointerOver(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("pointerover", handler, mode);
	}


	/** Event */
	public function pointerEnter(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("pointerenter", handler, mode);
	}


	/** Event */
	public function pointerLeave(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("pointerleave", handler, mode);
	}


	/** Event */
	public function gotPointerCapture(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("gotpointercapture", handler, mode);
	}


	/** Event */
	public function lostPointerCapture(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("lostpointercapture", handler, mode);
	}


	/** Event */
	public function pointerLockChange(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("pointerlockchange", handler, mode);
	}


	/** Event */
	public function pointerLockError(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("pointerlockerror", handler, mode);
	}


	/** Event */
	public function error(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("error", handler, mode);
	}


	/** Event */
	public function touchStart(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("touchstart", handler, mode);
	}


	/** Event */
	public function touchEnd(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("touchend", handler, mode);
	}


	/** Event */
	public function touchMove(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("touchmove", handler, mode);
	}


	/** Event */
	public function touchCancel(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("touchcancel", handler, mode);
	}
	
	
	/** Event */
	public function readyState(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("readystatechange", handler, mode);
	}
	
	
	/** Event */
	public function visibility(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("visibility", handler, mode);
	}
	
	
	/** Event */
	public function resize(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup {
		return auto("resize", handler, mode);
	}
	
}