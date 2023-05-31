package jotun.signals;

/**
 * ...
 * @author ...
 */
import jotun.dom.Display;
import jotun.tools.Ticker;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose('J_Observer')
class Observer {
	
	static private var _init:Bool;
	
	static private var _radar:Array<Display>;
	
	/**
	 * Check is a element if full OR partialy visible in DOM
	 * @param	target
	 * @param	handler
	 */
	static public function add(target:Display, handler:Display->Bool) {
		if (!_init){
			_init = true;
			_radar = [];
			Ticker.start();
			Ticker.addLower(_checkTargets);
		}
		if (target != null && _radar.indexOf(target) == -1){
			target.setProp('__onsigh', handler);
			_radar[_radar.length] = target;
		}
	}
	
	static private function _checkTargets():Void {
		Dice.Values(_radar, _singleCheck);
	}
	
	static function _singleCheck(d:Display):Void {
		if (d == null || d.element == null){
			remove(d);
		}else if (d.getVisibility() > 0){
			var h:Display->Bool = d.getProp('__onsigh');
			if (h == null || h(d)){
				remove(d);
			}
		}
	}
	
	/**
	 * Remove o objeto da verfificação
	 * @param	target
	 */
	static public function remove(target:Display):Void {
		if (_init){
			if(target != null){
				var i:Int = _radar.indexOf(target);
				if (i > -1){
					target.deleteProp("__onsigh");
					_radar.splice(i, 1);
				}
			}
		}
	}
	
	static public function removeBy(atrr:String, value:String):Void {
		Dice.Values(_radar, function(v:Display){
			if (v.attribute(atrr) == value){
				remove(v);
			}
		});
	}
	
	static public function clear():Void {
		_radar = [];
	}
	
}