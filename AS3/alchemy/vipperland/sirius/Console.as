package alchemy.vipperland.sirius {
	
	import alchemy.vipperland.sirius.core.SiriusDecoder;
	import alchemy.vipperland.sirius.core.SiriusDecoderError;
	import alchemy.vipperland.sirius.core.SiriusEncoder;
	import alchemy.vipperland.sirius.core.SiriusEncoderRules;
	import alchemy.vipperland.sirius.core.SiriusObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class Console extends Sprite {
		
		static protected var _stage:Stage;
		
		static protected var _aliases:Dictionary = new Dictionary(true);
		
		static private var _console:Console;
		
		static private var _TargetObject:*;
		
		private var _validcmdchars:String = "abcdefghijklmnopqrstuvwxyz.ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		
		private var _lines:Vector.<String>;
		
		private var _tf_output:TextField;
		
		private var _tf_input:TextField;
		
		private var _tf_alt:TextField;
		
		
		static public function init(stage:Stage, TargetObject:*, ... classes:Array):void {
			_TargetObject = TargetObject;
			_stage = stage;
			_console = new Console();
			SiriusDecoder.registerClass.apply(null, classes);
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
		}
		
		
		static protected function _onKeyDown(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case Keyboard.ESCAPE:  {
					if (!_stage.focus) {
						show();
					} else if (_console.stage) {
						hide();
					}
					break;
				}
				case Keyboard.ENTER:  {
					if (e.shiftKey) {
						_console.commit();
					}
				}
			}
		}
		
		
		static public function pushMessage(value:String, color:int = -1):void {
			if (color !== -1) {
				value = "<font color='#" + color.toString(16) + "'>" + value + "</font>";
			}
			_console.pushMessage(value);
			_console._updateConsole();
		}
		
		
		static public function pushQuery(value:String):void {
			_console.pushQuery(value);
		}
		
		
		static public function registerAliases(... values:Array):void {
			for each (var value:*in values) {
				if (value is Class) {
					SiriusDecoder.registerClass(value);
				} else {
					_aliases[getQualifiedClassName(value).split("::").pop()] = value;
				}
			}
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
		
		
		static public function show():void {
			var w:int = _stage.stageWidth;
			var h:int = _stage.stageHeight;
			_console._tf_output.width = w;
			_console._tf_input.width = w;
			_console._tf_output.height = h - 101;
			_console._tf_input.height = 100;
			_console._tf_input.y = h - 100;
			_console._tf_input.type = "input";
			_console.graphics.beginFill(0, .9);
			_console.graphics.drawRect(0, 0, w, h - 101);
			_console.graphics.drawRect(0, h - 100, w, 100);
			_console.graphics.endFill();
			_stage.addChild(_console);
			_console.focus();
		
		}
		
		
		public function Console() {
			
			_lines = new Vector.<String>();
			
			_tf_output = new TextField();
			_tf_output.multiline = true;
			_tf_output.defaultTextFormat = new TextFormat("Lucida Console", 15, 0xFFFFFF);
			
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
			
			addChild(_tf_output);
			addChild(_tf_input);
		}
		
		
		protected function _pushCommand(e:TextEvent):void {
			
			var cmd:Array = e.text.split("^&");
			
			var alias:String = cmd[0];
		
			//_tf_input.text = _tf_input.text.split(cmd[3]).join(result);
		
		}
		
		protected var _runAliases:Object = {};
		
		
		protected function _onInputChange(e:Event):void {
			
			var valueOf:String = _tf_input.text;
			var codeEnd:int = _tf_input.selectionEndIndex;
			var codeStart:int = codeEnd - 1;
			
			while (codeStart > 0) {
				var charAt:String = valueOf.substr(codeStart, 1);
				if (_validcmdchars.indexOf(charAt) == -1) {
					++codeStart;
					break;
				}
				--codeStart;
			}
			
			var code:String = valueOf.substr(codeStart, codeEnd - codeStart);
			
			var command:Array = code.split(".");
			var endValue:String = "";
			
			var fsec:String = command.shift();
			var targetObject:*;
			
			var counter:int = 0;
			var alias:String;
			
			if (fsec) {
				if (command.length == 0) {
					endValue += "<font color='#333333'>Available Classes</font>\n";
					for (alias in _aliases) {
						if (alias.indexOf(fsec) !== -1) {
							endValue += "<font color='#00CC66'>" + alias + "</font>\n";
						}
						if (++counter == 30) {
							counter = 0;
							break;
						}
					}
					alias = null;
					for (var className:String in SiriusDecoder.getClassCollection()) {
						if (className.indexOf(".") == -1 && !_aliases[className] && className.indexOf(fsec) !== -1) {
							endValue += "<font color='#0066CC'>" + className + "</font>\n";
						}
						if (++counter == 30) {
							counter = 0;
							break;
						}
					}
				}
				targetObject = _aliases[fsec] || SiriusDecoder.getRegisteredClass(fsec);
				if (targetObject) {
					fsec = fsec.toLowerCase();
					_runAliases[fsec] = targetObject;
					alias = fsec;
				}else {
					targetObject = _TargetObject;
					command[command.length] = fsec.toLowerCase();
				}
			}
			
			var targetParams:*;
			
			var path:String = "";
			
			for each (var section:String in command) {
				if (targetObject) {
					targetParams = targetObject;
					if (targetObject.hasOwnProperty(section)) {
						targetObject = targetObject[section];
						path += section + ".";
					} else {
						targetObject = null;
					}
				} else {
					targetParams = null;
					endValue = "";
				}
			}
			
			if (targetParams) {
				endValue += "<font color='#333333'>" + getQualifiedClassName(targetParams) + "</font>\n";
				var eobject:Object = SiriusEncoder.getClassInfo(targetParams, {includeMethods: true, includeTypes: true});
				var params:Array = eobject.properties;
				var methods:Array = eobject.methods;
				var combined:String = "";
				for each (var subsect:String in params) {
					combined = "";
					if (subsect == "prototype")
						continue;
					if (section.length == 0 || subsect.indexOf(section) !== -1) {
						combined = subsect + ":<font color='#0066CC'>" + (eobject.types[subsect] || "").split("::").pop() + "</font>";
						if (!(targetParams is Class)) {
							combined += "=" + _getValueOf(targetParams[subsect]);
						}
						if (++counter == 30) {
							counter = 0;
							break;
						}
						endValue += "<a href='event:" + path + subsect + "^&" + subsect + "^&" + code + "'>" + combined + "</a>\n"
					}
				}
				var srules:SiriusEncoderRules = targetParams.hasOwnProperty("siriusRules") ? targetParams.siriusRules : null;
				
				for each (var subsecta:Array in methods) {
					if (srules && !srules.verify(subsecta[0])) {
						continue;
					}
					var paramSet:Array = [];
					if (subsecta.length > 2) {
						paramSet = subsecta.splice(2, subsecta.length - 2);
						for (var i:String in paramSet) {
							paramSet[i] = "<font color='#0066CC'>" + paramSet[i].split("::").pop() + "</font>";
						}
					}
					if (section.length == 0 || subsecta[0].indexOf(section) !== -1) {
						endValue += "~" + subsecta[0] + "(" + paramSet + "):<font color='#0066CC'>" + subsecta[1].split("::").pop() + "</font>\n";
					}
					if (++counter == 30) {
						counter = 0;
						break;
					}
				}
			}
			
			_tf_alt.htmlText = endValue || "";
			if (_tf_alt.x + _tf_alt.width + 5 > _stage.stageWidth) {
				_tf_alt.width = _stage.stageWidth - _tf_alt.x - 5;
			}
			
			if (code.length > 0) {
				var bounds:Rectangle = _tf_input.getCharBoundaries(codeEnd - 1);
				if (bounds) {
					_tf_alt.x = _tf_input.x + bounds.x;
					_tf_alt.y = _tf_input.y + bounds.y - _tf_alt.height - 10;
					addChild(_tf_alt);
				}
			} else if (code.length == 0 && _tf_alt.parent) {
				removeChild(_tf_alt);
			}
		
		}
		
		
		protected function _getValueOf(object:*):String {
			if (object is Function) {
				return "<font color='#0099CC'>" + object + "</font>";
			} else if (object is Number) {
				return "<font color='#00FF00'>" + object + "</font>";
			} else if (object is String) {
				return "<font color='#CCCC00'>\"" + object + "\"</font>";
			} else if (object is Boolean) {
				return "<font color='#FF0000'>" + object + "</font>";
			} else if (object === null) {
				return "<font color='#0066CC'>" + object + "</font>";
			} else if (object is Array) {
				return "<font color='#00FF00'>array[" + object.length + "]</font>";
			} else {
				return "<font color='#999999'>" + _getClassName(object) + "()</font>"
			}
		}
		
		
		private function _getClassName(object:*):String {
			return getQualifiedClassName(object).split("::").pop();
		}
		
		
		protected function commit():void {
			
			var tgo:* = _TargetObject;
			
			if (!tgo) {
				tgo = new SiriusObject();
			} else if (tgo is Class) {
				tgo = new tgo();
			}
			
			for (var alias:String in _runAliases) {
				tgo[alias] = _runAliases[alias];
			}
			_runAliases = {};
			
			var command:SiriusDecoder = SiriusDecoder.parse(_tf_input.text, null, tgo);
			for each (var error:SiriusDecoderError in command.errors) {
				pushMessage(error.message);
			}
			
			_TargetObject = tgo;
			
			var result:String = SiriusEncoder.getValue(command.content, null, 0);
			pushMessage(result);
			focus();
		}
		
		
		public function pushMessage(value:String):void {
			_lines[_lines.length] = value;
			if (_lines.length > 1000) {
				_lines.shift();
			}
			_tf_output.htmlText = _lines.join("\n");
		}
		
		
		protected function focus():void {
			setTimeout(_setFocus, 10);
		}
		
		
		protected function _setFocus():void {
			_tf_input.text = "";
			_stage.focus = _tf_input;
			_tf_input.setSelection(_tf_input.length, _tf_input.length);
		}
	
	}

}