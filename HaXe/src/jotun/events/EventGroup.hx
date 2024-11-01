package jotun.events;
import jotun.Jotun;
import jotun.events.EventGroup;
import js.Browser;
import js.Syntax;
import js.html.CustomEvent;
import js.html.CustomEventInit;
import jotun.dom.Display;
import jotun.dom.Html;
import jotun.dom.Displayable;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("Jtn.EventGroup")
class EventGroup {
	
	private var _pd:Bool;
	
	public var dispatcher:EventDispatcher;
	
	public var name:String;
	
	public var events:Array<Dynamic>;
	
	public var enabled:Bool;
	
	public var propagation:Bool;
	
	public var capture:Bool;
	
	public var data:Dynamic;

	public function new(dispatcher:EventDispatcher, name:String) {
		this.dispatcher = dispatcher;
		this.name = name;
		this.enabled = !dispatcher.target.isEnabled();
		this.propagation = true;
		this.events = [];
	}
	
	public function add(handler:Activation->Void, ?capture:Bool):EventGroup {
		if (capture != null){
			this.capture = capture;
		}
		if (handler != null){
			this.events.push(handler);
		}
		return this;
	}
	
	public function addOnce(handler:Activation->Void, ?capture:Bool):EventGroup {
		if (!exists(handler)) {
			add(handler, capture);
		}
		return this;
	}
	
	public function exists(handler:Activation->Void):Bool {
		return this.events.indexOf(handler) != -1;
	}
	
	public function remove(handler:Activation->Void):EventGroup {
		var iof:Int = Lambda.indexOf(this.events, handler);
		if (iof != -1){
			this.events.splice(iof, 1);
		}
		return this;
	}
	
	public function prepare(t:Displayable):EventGroup	{
		t.element.removeEventListener(name, _runner, capture);
		t.element.addEventListener(name, _runner, capture);
		return this;
	}
	
	public function dispose(t:Displayable):Void {
		t.element.removeEventListener(name, _runner, capture);
		dispatcher = null;
		events = null;
		data = null;
	}
	
	public function cancel():EventGroup {
		propagation = false;
		return this;
	}
	
	public function noDefault():EventGroup {
		_pd = true;
		return this;
	}
	
	public function reset():EventGroup {
		this.events = [];
		return this;
	}
	
	private function _runner(?e:js.html.Event):Void {
		if (!enabled) {
			return;
		}
		var evt:Activation = new Event(dispatcher, this, e);
		Dice.Values(events, function(v:Dynamic) {
			if (v != null){
				v(evt);
			}
			return !propagation;
		});
		if (_pd && e != null){
			evt.event.preventDefault();
			evt.event.stopPropagation();
		}
		propagation = true;
	}
	
	public function call(?bubbles:Bool = false, ?cancelable:Bool = true, ?data:Dynamic = null):EventGroup {
		this.data = data;
		if (Browser.document.createEvent != null) {
			var e:CustomEvent = new CustomEvent(name);
			e.initEvent(name, bubbles, cancelable);
			dispatcher.target.element.dispatchEvent(e);
		}else {
			_runner(null);
		}
		this.data = null;
		return this;
	}
	
	public function cloneFrom(group:EventGroup):EventGroup {
		_pd = (cast group)._pd;
		enabled = group.enabled;
		capture = group.capture;
		events = Syntax.code('[...{0}]', events);
		return this;
	}
	
}