package gate.sirius.meta {
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	import gate.sirius.serializer.SruDecoder;
	import gate.sirius.serializer.SruEncoder;
	import gate.sirius.serializer.data.SruRules;
	import gate.sirius.serializer.hosts.IRules;
	import gate.sirius.serializer.signals.SruDecoderSignal;
	import gate.sirius.serializer.signals.SruErrorSignal;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class Console extends Sprite {
		
		static protected var _stage:Stage;
		
		static protected var _aliases:Dictionary = new Dictionary(true);
		
		static protected var _maxConsoleWidth:int = 800;
		
		static private var _console:Console;
		
		static private var _TargetObject:*;
		
		public static var displayMethods:Boolean = true;
		
		static private var _listenners:Vector.<Function> = new Vector.<Function>();
		
		private var _validcmdchars:String = "abcdefghijklmnopqrstuvwxyz.ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_";
		
		private var _lines:Vector.<String>;
		
		private var _tf_output:TextField;
		
		private var _tf_input:TextField;
		
		private var _tf_alt:TextField;
		
		private var _tf_tooltip:TextField;
		
		private var _command:SruDecoder;
		
		
		static public function setMaxWidth(target:int = 0):void {
			_maxConsoleWidth = target > 500 ? target : 500;
		}
		
		
		static public function init(stage:Stage, allowCommands:Boolean, TargetObject:* = null, ... classes:Array):void {
			if (_stage) {
				return;
			}
			_stage = stage;
			_console = new Console(allowCommands);
			_TargetObject = TargetObject || _console;
			_stage.addEventListener(Event.RESIZE, _onResize);
			SruDecoder.allowClasses.apply(null, classes);
		}
		
		static public function get stage():Stage {
			return _stage;
		}
		
		
		static protected function _onResize(e:Event):void {
			if (_console._tf_output.parent){
				_console._updatePosition();
			}
		}
		
		
		protected function _onKeyDown(e:KeyboardEvent):void {
			
			if (e.keyCode == Keyboard.ESCAPE){
				if (isVisible()){
					hide();
					return;
				}
			}
			if (e.keyCode == Keyboard.BACKQUOTE) {
				if (isVisible()){
					if (!isDevMode()){
						hide();
						return;
					}
				}else{
					show();
					e.preventDefault();
					e.stopPropagation();
					e.stopImmediatePropagation();
					return;
				}
			}
			
			if (!stage) {
				return;
			}
			
			switch (e.keyCode) {
				case Keyboard.ENTER: {
					if (e.shiftKey){
						commit();
					}
					break;
				}
				case Keyboard.SPACE:  {
					_clearAlt(e);
					break;
				}
				case Keyboard.DOWN:  {
					if(_altValue){
						_altPoint(1);
						e.stopImmediatePropagation();
						e.preventDefault();
					}
					break;
				}
				case Keyboard.UP:  {
					if(_altValue){
						_altPoint(-1);
						e.stopImmediatePropagation();
						e.preventDefault();
					}
					break;
				}
			}
		}
		
		private function _addEntryInPoint(value:String, sS:int = 0, sE:int = 0):void {
			var c:String = _tf_input.text;
			var s:int =  _tf_input.selectionBeginIndex;
			_tf_input.text = c.substr(0, s) + value + c.substr(s + 1, c.length - s);
			++s;
			_tf_input.setSelection(s + sS, s + sE);
		}
		
		
		public static function listenEvents(handler:Function):void {
			if (_listenners.indexOf(handler) == -1){
				_listenners.push(handler);
			}
		}
		
		
		protected function _clearAlt(e:KeyboardEvent):void {
			if (!_altValue){
				return;
			}
			var values:Array = _altValue.split("\n");
			var value:String = values[_altValueTarget];
			if (_altValueTarget > 0 && value.indexOf("a href='event:") !== -1) {
				value = value.split("a href='event:")[1];
				value = value.split("'>")[0];
				if (_tf_input.text.substr(_altValueStart, value.length) !== value){
					_tf_input.text = _tf_input.text.substr(0, _altValueStart) + value + _tf_input.text.substr(_altValueCursor, _tf_input.length - _altValueCursor);
				}
				e.preventDefault();
				e.stopImmediatePropagation();
				_tf_input.setSelection(_altValueStart + value.length, _altValueStart + value.length);
				_onInputChange(null);
			} else {
				_altValueTarget = 0;
				_altValue = "";
				_altValueCursor = 0;
				_altValueStart = 0;
				_altPoint(0);
			}
		}
		
		
		protected function _altPoint(target:int):void {
			
			_altValueTarget += target;
			var values:Array = (_altValue || "").split("\n");
			if (_altValueTarget < 0){
				_altValueTarget = 0;
			} else if (_altValueTarget >= values.length){
				_altValueTarget = values.length - 1;
			}
			if (_altValue.length > 0) {
				var tvalue:String = values[_altValueTarget];
				if (tvalue) {
					values[_altValueTarget] = "[<u><b>" + tvalue + "</b></u>]";
					_tf_alt.htmlText = values.join("\n");
					_tf_alt.wordWrap = false;
				} else {
					_altValueTarget -= 1;
				}
			}
			_updateAlt();
		}
		
		
		static public function newLine():void {
			_console.pushMessage("");
			_console._updateConsole();
		}
		
		static public function clear():void {
			_console._tf_output.text = '';
			_console._tf_input.text = '';
		}
		
		
		static public function makeColorStr(color:int = -1, size:int = 10, ... values:Array):String {
			return "<font color='#" + color.toString(16) + (size == 10 ? "" : "' size='" + size) + "'>" + values.join(" ") + "</font>";
		}
		
		
		static public function pushColorMsg(color:int = -1, size:int = 10, ... values:Array):void {
			pushMessage(makeColorStr.apply(null, [color, size].concat(values)));
		}
		
		
		static internal function log(... values:Array):void {
			pushMessage("<i><font size='10'>" + values.join(", ") + "</font></i>");
		}
		
		
		static public function pushMessage(... values:Array):void {
			if (_console) {
				_console.pushMessage(values.join(" "));
				_console._updateConsole();
			}
		}
		
		
		static public function pushLowMsg(... values:Array):void {
			pushColorMsg.apply(null, [0x666666, 10].concat(values));
		}
		
		
		static public function pushMedMsg(... values:Array):void {
			pushColorMsg.apply(null, [0xAAAAAA, 10].concat(values));
		}
		
		
		static public function pushWarningMsg(... values:Array):void {
			pushColorMsg.apply(null, [0xCC9900, 10].concat(values));
		}
		
		
		static public function pushErrorMsg(... values:Array):void {
			pushColorMsg.apply(null, [0xFF0000, 10].concat(values));
		}
		
		
		static public function pushSuccessMsg(... values:Array):void {
			pushColorMsg.apply(null, [0x00FF00, 10].concat(values));
		}
		
		
		static public function pushHighMsg(... values:Array):void {
			pushColorMsg.apply(null, [0x0066CC, 10].concat(values));
		}
		
		
		static public function pushObjMsg(handler:Function = null, ... values:Array):void {
			if (handler == null){
				handler = pushLowMsg;
			}
			handler(SruEncoder.encode(values));
		}
		
		
		static public function pushQuery(value:String, execute:Boolean):void {
			_console.pushQuery(value);
			if (execute){
				_console.commit();
			}
		}
		
		
		static public function registerAliases(... values:Array):void {
			for each (var value:*in values) {
				if (value is Class){
					SruDecoder.allowClasses(value);
				} else {
					_aliases[getQualifiedClassName(value).split("::").pop()] = value;
				}
			}
		}
		
		
		static internal function getAlias(name:String):* {
			return _aliases[name];
		}
		
		
		protected function _updateConsole():void {
			_tf_output.htmlText = _lines.join("\n");
			_tf_output.scrollV = _tf_output.maxScrollV;
		}
		
		
		public function pushQuery(value:String):void {
			_tf_input.text = value;
		}
		
		
		static public function hide():void {
			_stage.removeChild(_console);
			_console._tf_input.text = "";
			_console.graphics.clear();
			_stage.focus = null;
		}
		
		
		private function _updatePosition():void {
			var w:int = _stage.stageWidth;
			var h:int = _stage.stageHeight;
			_tf_output.width = _maxConsoleWidth || w;
			_tf_input.width = _maxConsoleWidth || w;
			if(_tf_input.visible){
				_tf_output.height = h - 101;
				_tf_input.height = 100;
				_tf_input.y = h - 100;
				_tf_input.type = "input";
				graphics.clear();
				graphics.beginFill(0, .9);
				graphics.drawRect(0, 0, _maxConsoleWidth || w, h - 101);
				graphics.drawRect(0, h - 100, _maxConsoleWidth || w, 100);
				graphics.endFill();
			}else {
				_tf_output.height = h;
				graphics.clear();
			}
			
		}
		
		
		static public function show():void {
			_stage.addChild(_console);
			_console._updatePosition();
			_console.focus();
		}
		
		
		static public function setLogMode():void {
			_console.setLogMode();
		}
		
		
		static public function setDevMode():void {
			_console.setDevMode();
		}
		
		
		static public function expand():void {
			if (_console) {
				_console.expand();
			}
		}
		
		static public function getInstance():Console {
			return _console;
		}
		
		
		public function Console(dev:Boolean) {
			
			_lines = new Vector.<String>();
			
			_tf_output = new TextField();
			_tf_output.multiline = true;
			_tf_output.wordWrap = true;
			_tf_output.defaultTextFormat = new TextFormat("Lucida Console", 15, 0xFFFFFF);
			_tf_output.addEventListener(TextEvent.LINK, _runListenners);
			
			_tf_input = new TextField();
			_tf_input.multiline = true;
			_tf_input.defaultTextFormat = new TextFormat("Lucida Console", 15, 0xFFFFFF);
			_tf_input.addEventListener(Event.CHANGE, _onInputChange);
			
			_tf_alt = new TextField();
			_tf_alt.multiline = true;
			_tf_alt.autoSize = "left";
			_tf_alt.background = true;
			_tf_alt.backgroundColor = 0x0;
			_tf_alt.border = true;
			_tf_alt.borderColor = 0x111111;
			_tf_alt.defaultTextFormat = new TextFormat("Lucida Console", 12, 0xFFFFFF);
			_tf_alt.addEventListener(TextEvent.LINK, _pushCommand);
			
			_command = new SruDecoder();
			_command.signals.ERROR.hold(_onParseError);
			_command.signals.PARSED.hold(_onParseComplete);
			
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
			
			_tf_input.visible = dev;
			
			addChild(_tf_output);
			addChild(_tf_input);
			
		}
		
		
		private function _onParseComplete(signal:SruDecoderSignal):void {
			pushSuccessMsg("<font color='#446644'> &gt;");
		}
		
		
		private function _onParseError(error:SruErrorSignal):void {
			pushErrorMsg(error.message);
		}
		
		
		protected function _runListenners(e:TextEvent):void {
			for each (var callback:Function in _listenners){
				callback(e.text);
			}
		}
		
		
		protected function _pushCommand(e:TextEvent):void {
			
			var cmd:Array = e.text.split("^&");
			
			var alias:String = cmd[0];
			
			//_tf_input.text = _tf_input.text.split(cmd[3]).join(result);
			
		}
		
		protected var _runAliases:Object = {};
		
		protected var _altValue:String;
		
		protected var _altValueTarget:int;
		
		protected var _altValueCursor:int;
		
		protected var _altValueStart:int;
		
		
		protected function _onInputChange(e:Event):void {
			
			var valueOf:String = _tf_input.text;
			var codeEnd:int = _tf_input.selectionEndIndex;
			var codeStart:int = codeEnd - 1;
			
			var char:String = valueOf.substr(codeStart, 1);
			if (char == "`") {
				_tf_input.text = _tf_input.text.substr(0, codeStart) + _tf_input.text.substr(codeEnd, _tf_input.length - codeStart);
				return;
			}
			
			while (codeStart > 0) {
				var charAt:String = valueOf.substr(codeStart, 1);
				if (_validcmdchars.indexOf(charAt) == -1) {
					++codeStart;
					break;
				}
				--codeStart;
			}
			
			var code:String = valueOf.substr(codeStart, codeEnd - codeStart);
			code = code.split("@").join("");
			
			var command:Array = code.split(".");
			var endValue:String = "";
			
			var fsec:String = command.shift();
			var targetObject:*;
			
			var counter:int = 0;
			var alias:String;
			
			var path:String = "";
			var noSelection:Boolean;
			
			if (fsec) {
				if (command.length == 0) {
					noSelection = true;
					endValue += "<font color='#333333'>Available Classes</font>\n";
					for (alias in _aliases) {
						if (alias.indexOf(fsec) !== -1) {
							endValue += "<font color='#00CC66'><a href='event:" + alias + "'>" + alias + "</a></font>\n";
						}
						if (++counter == 30) {
							counter = 0;
							break;
						}
					}
					alias = null;
					for (var className:String in SruDecoder.CLASS_COLLECTION) {
						if (className.indexOf(".") == -1 && !_aliases[className] && className.indexOf(fsec) !== -1) {
							endValue += "<font color='#0066CC'><a href='event:" + className + "'>" + className + "</a></font>\n";
							if (++counter == 30) {
								counter = 0;
								break;
							}
						}
					}
				}
				targetObject = _aliases[fsec] || SruDecoder.CLASS_COLLECTION[fsec];
				if (targetObject) {
					fsec = fsec.toLowerCase();
					_runAliases[fsec] = targetObject;
					alias = fsec;
				} else {
					targetObject = _TargetObject;
					targetParams = targetObject;
					command.unshift(fsec.toLowerCase());
				}
			}
			
			var targetParams:*;
			
			var lastSection:String = "";
			
			for each (var section:String in command) {
				
				if (!section){
					continue;
				}
				
				if (targetObject) {
					if (targetObject.hasOwnProperty(section)) {
						targetObject = targetObject[section];
						targetParams = targetObject;
						path += (path ? "." : "") + section;
					} else {
						targetObject = null;
					}
					lastSection = section;
				} else {
					targetParams = null;
					endValue = "";
				}
				
			}
			
			if (targetParams && _tf_input.length) {
				endValue += "<font color='#333333'>" + getQualifiedClassName(targetParams) + "</font>\n";
				var eobject:Object = SruEncoder.getClassInfo(targetParams, {includeMethods: true, includeTypes: true});
				var params:Array = eobject.properties;
				var methods:Array = eobject.methods;
				var combined:String = "";
				for each (var subsect:String in params) {
					combined = "";
					if (subsect == "prototype"){
						continue;
					}
					if (section.length == 0 || subsect.indexOf(section) !== -1) {
						combined = subsect + ":<font color='#0066CC'>" + (eobject.types[subsect] || "*").split("::").pop() + "</font>";
						if (!(targetParams is Class)) {
							combined += "=" + _getValueOf(targetParams[subsect]);
						}
						if (++counter == 30) {
							counter = 0;
							break;
						}
						if (subsect == lastSection) {
							subsect = path;
						} else {
							subsect = (path ? path + "." : "") + subsect;
						}
						endValue += "<a href='event:" + subsect + "'>" + combined + "</a>\n";
					}
				}
				var srules:SruRules = targetParams is IRules ? (targetParams as IRules).rules : null;
				
				if (displayMethods) {
					for each (var subsecta:Array in methods) {
						if (srules && !srules.isVisible(subsecta[0])){
							continue;
						}
						var paramSet:Array = [];
						if (subsecta.length > 2) {
							paramSet = subsecta.splice(2, subsecta.length - 2);
							for (var i:String in paramSet){
								paramSet[i] = "<font color='#0066CC'>" + paramSet[i].split("::").pop() + "</font>";
							}
						}
						if (section.length == 0 || subsecta[0].indexOf(section) !== -1){
							endValue += " <a href='event:@" + subsecta[0] + "'>@" + subsecta[0] + "</a>(" + paramSet + "):<font color='#0066CC'>" + subsecta[1].split("::").pop() + "</font>\n";
						}
						if (++counter == 30) {
							counter = 0;
							break;
						}
					}
				}
			}
			
			_altValue = endValue;
			_altValueTarget = 0;
			_altValueStart = codeStart;
			_altValueCursor = codeEnd;
			_altPoint(0);
		
		}
		
		
		protected function _updateAlt():void {
			
			if (_tf_alt.x + _tf_alt.width + 5 > _stage.stageWidth) {
				_tf_alt.wordWrap = true;
				_tf_alt.width = _stage.stageWidth - _tf_alt.x - 5;
			}
			if (_tf_alt.y < 10) {
				_tf_alt.y = 10;
				if (_tf_alt.height > _stage.stageHeight - 20) {
					_tf_alt.height = _stage.stageHeight - 20;
				}
			}
			
			if (_altValue && _altValue.length > 0) {
				var bounds:Rectangle = _tf_input.getCharBoundaries(_altValueCursor - 1);
				if (bounds) {
					_tf_alt.x = _tf_input.x + bounds.x;
					_tf_alt.y = _tf_input.y + bounds.y - _tf_alt.height - 10;
					addChild(_tf_alt);
				}
			} else if ((!_altValue || _altValue.length == 0) && _tf_alt.parent) {
				removeChild(_tf_alt);
			}
			
		}
		
		
		protected function _getValueOf(object:*):String {
			var type:String = typeof(object);
			switch(type) {
				case 'string' : 
					return "<font color='#CCCC00'>\"" + object + "\"</font>";
				case 'number' : 
					return "<font color='#00FF00'>" + object + "</font>";
				case 'boolean': 
					return "<font color='#FF0000'>" + object + "</font>";
				default : {
					if (object === null) 
						return "<font color='#0066CC'>" + object + "</font>";
					else if (object is Function)	
						return "<font color='#0099CC'>" + object + "</font>";
					else if (object is Array)
						return "<font color='#00FF00'>array[" + object.length + "]</font>";
					else
						return "<font color='#999999'>" + _getClassName(object) + "()</font>"
				}
			}
			
		}
		
		
		private function _getClassName(object:*):String {
			return getQualifiedClassName(object).split("::").pop();
		}
		
		
		protected function commit():void {
			
			if (!_tf_input.length){
				return;
			}
			
			var tgo:* = _TargetObject;
			
			for (var alias:String in _runAliases) {
				if (tgo.hasOwnProperty(alias)) {
					tgo[alias] = _runAliases[alias];
				}else {
					tgo = _TargetObject;
				}
			}
			_runAliases = {};
			
			_command.parse(_tf_input.text, tgo);
			
			_TargetObject = tgo;
			
			_altValue = "";
			_altValueCursor = 0;
			_altValueStart = 0;
			_altValueTarget = 0;
			
			focus();
			_updateAlt();
			
		}
		
		
		public function expand():void {
			var ad:ApplicationDomain = _stage.loaderInfo.applicationDomain;
			for each (var c:String in ad.getQualifiedDefinitionNames()) {
				var def:String = c.split("::").join(".");
				if (ad.hasDefinition(def)){
					SruDecoder.allowClasses(ad.getDefinition(def) as Class);
				}
			}
		}
		
		
		public function pushMessage(value:String):void {
			_lines[_lines.length] = value;
			if (_lines.length > 100){
				_lines.shift();
			}
			_tf_output.htmlText = _lines.join("<br/>");
			_tf_output.scrollV = _tf_output.maxScrollV;
		}
		
		
		protected function focus():void {
			setTimeout(_setFocus, 10);
		}
		
		public function setLogMode():void {
			_tf_input.visible = false;
			mouseEnabled = false;
			mouseChildren = false;
			_updatePosition();
			pushHighMsg("!== CONSOLE :: LOG MODE ==");
			pushHighMsg("OS:", Capabilities.os, "/DPI:", Capabilities.screenDPI, "/LANG:", Capabilities.language, "/DEBUG:", Capabilities.isDebugger);
		}
		
		public function setDevMode():void {
			_tf_input.visible = true;
			mouseEnabled = true;
			mouseChildren = true;
			_updatePosition();
			pushHighMsg("!== CONSOLE :: DEV MODE ==");
			pushHighMsg("OS:", Capabilities.os, "/DPI:", Capabilities.screenDPI, "/LANG:", Capabilities.language, "/DEBUG:", Capabilities.isDebugger);
		}
		
		public function isDevMode():Boolean {
			return _tf_input.visible;
		}
		
		public function isVisible():Boolean {
			return _console.parent;
		}
		
		protected function _setFocus():void {
			_tf_input.text = "";
			if (_tf_input.visible) {
				_stage.focus = _tf_input;
				_tf_input.setSelection(_tf_input.length, _tf_input.length);
			}
		}
	
	}

}