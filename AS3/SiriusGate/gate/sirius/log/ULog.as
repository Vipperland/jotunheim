package gate.sirius.log {
	
	import gate.sirius.log.signals.ULogSignal;
	import gate.sirius.signals.ISignalDispatcher;
	import gate.sirius.signals.SignalDispatcher;
	
	
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public class ULog {
		
		public static const GATE:ULog = new ULog();
		
		public static const NONE:uint = 0;
		
		public static const WARNING:uint = 1;
		
		public static const ERROR:uint = 2;
		
		private var _messages:Vector.<String>;
		
		private var _names:Vector.<String>;
		
		private var _signals:ISignalDispatcher;
		
		private var _lastMessage:String;
		
		
		public function ULog() {
			_signals = new SignalDispatcher(this);
			_messages = new Vector.<String>();
			_names = Vector.<String>([" ", "!", "?"]);
		}
		
		
		public function get messages():Vector.<String> {
			return _messages;
		}
		
		
		public function get ON_NEW_ENTRY():ISignalDispatcher {
			return _signals;
		}
		
		
		public function add(level:uint, ... message:Array):void {
			if (level > 3){
				level = 3;
			}
			_lastMessage = ((_messages.length + 1) * 0.0001).toFixed(4).split(".").join("") + " &lt;" + _names[level] + "&gt; " + message.join("\n");
			_signals.send(ULogSignal, true, level, _lastMessage);
			_messages[_messages.length] = _lastMessage;
		}
		
		
		public function toString():String {
			return _messages.join("\n");
		}
		
		
		public function pushMessage(... message:Array):void {
			add.apply(null, [NONE].concat(message));
		}
		
		
		public function pushError(... message:Array):void {
			add.apply(null, [ERROR].concat(message));
		}
		
		
		public function pushWarning(... message:Array):void {
			add.apply(null, [WARNING].concat(message));
		}
	
	
	}

}