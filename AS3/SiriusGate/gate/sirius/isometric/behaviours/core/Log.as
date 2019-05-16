package gate.sirius.isometric.behaviours.core {
	import gate.sirius.log.signals.ULogSignal;
	import gate.sirius.signals.ISignalDispatcher;
	import gate.sirius.signals.SignalDispatcher;
	
	
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public class Log {
		
		public static const MESSAGE:uint = 0;
		
		public static const WARNING:uint = 1;
		
		public static const ERROR:uint = 2;
		
		private var _messages:Vector.<String>;
		
		private var _names:Vector.<String>;
		
		private var _signals:ISignalDispatcher;
		
		private var _lastMessage:String;
		
		
		public function Log() {
			_signals = new SignalDispatcher(this);
			_messages = new Vector.<String>();
			_names = Vector.<String>(["MESSAGE", "WARNING", "ERROR"]);
		}
		
		
		public function get messages():Vector.<String> {
			return _messages;
		}
		
		
		public function get ON_NEW_ENTRY():ISignalDispatcher {
			return _signals;
		}
		
		
		public function add(level:uint, ... message:Array):void {
			if (level > 2){
				level = 2;
			}
			_lastMessage = "&lt;" + _names[level] + "&gt; " + message.join("\n");
			_signals.send(ULogSignal, true, level, _lastMessage);
			_messages[_messages.length] = _lastMessage;
			if (_messages.length > 100){
				_messages.splice(0, 1);
			}
		}
		
		
		public function toString():String {
			return _messages.join("\n");
		}
	
	}

}