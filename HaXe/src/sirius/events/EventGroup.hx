package sirius.events;
import sirius.dom.Display;
import sirius.dom.IDisplay;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.events.EventGroup")
class EventGroup implements IEventGroup {
	
	private var _pd:Bool;
	
	public var dispatcher:IDispatcher;
	
	public var name:String;
	
	public var events:Array<Dynamic>;
	
	public var enabled:Bool;
	
	public var propagation:Bool;
	
	public var capture:Bool;

	public function new(dispatcher:IDispatcher, name:String) {
		this.dispatcher = dispatcher;
		this.name = name;
		this.enabled = true;
		this.events = [];
	}
	
	public function add(handler:IEvent->Void, ?capture:Bool):IEventGroup {
		if (capture != null)	this.capture = capture;
		if(handler != null)		this.events.push(handler);
		return this;
	}
	
	public function remove(handler:IEvent->Void):IEventGroup {
		var iof:Int = Lambda.indexOf(this.events, handler);
		if (iof != -1) this.events.splice(iof, 1);
		return this;
	}
	
	public function prepare(t:IDisplay):IEventGroup	{
		t.element.removeEventListener(name, _runner, capture);
		t.element.addEventListener(name, _runner, capture);
		return this;
	}
	
	public function dispose(t:IDisplay):Void {
		t.element.removeEventListener(name, _runner, capture);
	}
	
	public function cancel():IEventGroup {
		propagation = false;
		return this;
	}
	
	public function preventDefault():Void {
		_pd = true;
	}
	
	public function reset():IEventGroup {
		this.events = [];
		return this;
	}
	
	private function _runner(?e:Dynamic):Void {
		if (!enabled) return;
		var evt:IEvent = new Event(dispatcher, this, e);
		Dice.Values(events, function(v:Dynamic) {
			if (v != null) v(evt);
			return !propagation;
		});
		if (_pd && e != null) {
			evt.event.preventDefault();
		}
		propagation = true;
	}
	
	public function call():IEventGroup {
		_runner(null);
		return this;
	}
	
}