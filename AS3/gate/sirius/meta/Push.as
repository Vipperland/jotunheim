package gate.sirius.meta {
	
	import alchemy.vipperland.hydra.display.HydraTextHighlight;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import gate.sirius.meta.core.SiriusEncoder;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class Push extends Sprite {
		static protected var _maxNotifications:int;
		
		static private var _backgroundColor:int;
		
		static private var _textFormat:TextFormat;
		
		private static var _instance:Push = new Push();
		
		
		static public function notify(... values:Array):void {
			values.unshift("<font size='9'>&gt;&gt; " + new Date().toString().split(" ")[3] + "</font>\n");
			var text:String = values.join(" ");
			_instance._createNotification(text);
		}
		
		
		static public function _getString(color:int = -1, size:int = 10, ... values:Array):String {
			return "<font color='#" + color.toString(16) + (size == 10 ? "" : "' size='" + size) + "'>" + values.join(", ") + "</font>";
		}
		
		
		static public function colorString(color:int = -1, size:int = 10, ... values:Array):void {
			notify(_getString.apply(null, [color, size].concat(values)));
		}
		
		
		static internal function log(... values:Array):void {
			notify("<i><font size='10'>" + values.join(", ") + "</font></i>");
		}
		
		
		static public function defaultNotify(... values:Array):void {
			colorString.apply(null, [0xFFFFFF, 10].concat(values));
		}
		
		
		static public function lowPriorityNotify(... values:Array):void {
			colorString.apply(null, [0x666666, 10].concat(values));
		}
		
		
		static public function mediumPriorityNotify(... values:Array):void {
			colorString.apply(null, [0xAAAAAA, 10].concat(values));
		}
		
		
		static public function warningNotify(... values:Array):void {
			colorString.apply(null, [0xFFFF00, 10].concat(values));
		}
		
		
		static public function errorNotify(... values:Array):void {
			colorString.apply(null, [0xFF0000, 10].concat(values));
		}
		
		
		static public function successNotify(... values:Array):void {
			colorString.apply(null, [0x00CC00, 10].concat(values));
		}
		
		
		static public function highPriorityNotify(... values:Array):void {
			colorString.apply(null, [0x0066CC, 10].concat(values));
		}
		
		
		static public function detailedObjectNotify(handler:Function = null, ... values:Array):void {
			if (handler == null) {
				handler = lowPriorityNotify;
			}
			handler(SiriusEncoder.getValue(values));
		}
		
		
		static public function init(stage:Stage, backgroundColor:int = 0x000000, textFormat:TextFormat = null, maxNotifications:int = 5):void {
			_maxNotifications = maxNotifications;
			_textFormat = textFormat || new TextFormat("Arial", 12, 0xFFFFFF);
			_backgroundColor = backgroundColor;
			stage.addChild(_instance);
		}
		
		private var _interval:uint;
		
		private var _highlights:Vector.<HydraTextHighlight>;
		
		
		private function _createNotification(text:String):void {
			var textField:TextField = new TextField();
			textField.defaultTextFormat = _textFormat;
			textField.autoSize = "left";
			textField.htmlText = text;
			var highlight:HydraTextHighlight = new HydraTextHighlight(textField, _backgroundColor, .5);
			highlight.mouseChildren = false;
			highlight.x = 20;
			highlight.update();
			highlight.y = height + 10;
			if (_highlights.length > 0) {
				_highlights[_highlights.length -1].x = 10;
			}
			addChild(highlight);
			_highlights[_highlights.length] = highlight;
			_tick();
			if (_highlights.length > _maxNotifications) {
				_shiftStack();
			}
		}
		
		
		private function _shiftStack():void {
			if (_highlights.length > 0) {
				var target:HydraTextHighlight = _highlights.shift();
				removeChild(target);
				for each(var obj:HydraTextHighlight in _highlights) {
					obj.y -= target.height;
					obj.x = 10;
				}
				if (obj) {
					obj.x = 20;
				}
				_tick();
			}
		}
		
		private function _tick():void {
			clearTimeout(_interval);
			_interval = setTimeout(_shiftStack, 10000);
		}
		
		public function Push() {
			_highlights = new Vector.<HydraTextHighlight>();
			addEventListener(MouseEvent.MOUSE_OVER, _checkInteractionState, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, _checkInteractionState, false, 0, true);
			mouseChildren = false;
		}
		
		protected function _checkInteractionState(e:MouseEvent):void {
			if (e.type == MouseEvent.MOUSE_OVER) {
				clearTimeout(_interval);
			}else {
				_tick();
			}
		}
	
	}

}