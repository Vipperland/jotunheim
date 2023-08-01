package jotun.signals;

/**
 * ...
 * @author ...
 */
import jotun.dom.Display;
import jotun.dom.IDisplay;
import jotun.timer.FrameChannel;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Observer {
	
	private var _init:Bool;
	
	private var _channel:FrameChannel;
	
	private var _radar:Array<IDisplay>;
	
	private function _checkTargets():Void {
		Dice.Values(_radar, _singleCheck);
	}
	
	private function _singleCheck(d:IDisplay):Void {
		if (d == null || d.element == null){
			remove(d);
		}else if (d.getVisibility() > 0){
			var h:IDisplay->Bool = d.getProp('__onsigh');
			if (h == null || h(d)){
				remove(d);
			}
		}
	}
	
	public function new() {
	}
	
	/**
	 * Check is a element if full OR partialy visible in DOM
	 * @param	target
	 * @param	handler
	 */
	public function add(target:IDisplay, handler:Display->Bool) {
		if (!_init){
			_init = true;
			_radar = [];
			if(_channel == null){
				_channel = Jotun.timer.channel(1000);
				Jotun.timer.resume();
			}
			_channel.add(_checkTargets);
		}
		if (target != null && _radar.indexOf(target) == -1){
			target.setProp('__onsigh', handler);
			_radar[_radar.length] = target;
		}
	}
	
	/**
	 * Remove o objeto da verfificação
	 * @param	target
	 */
	public function remove(target:IDisplay):Void {
		if (_init){
			if(target != null){
				var i:Int = _radar.indexOf(target);
				if (i > -1){
					target.delProp("__onsigh");
					_radar.splice(i, 1);
				}
			}
		}
	}
	
	public function removeBy(atrr:String, value:String):Void {
		Dice.Values(_radar, function(v:IDisplay){
			if (v.attribute(atrr) == value){
				remove(v);
			}
		});
	}
	
	public function clear():Void {
		_radar = [];
	}
	
}