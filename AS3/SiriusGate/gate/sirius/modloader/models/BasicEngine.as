package gate.sirius.modloader.models {
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.Capabilities;
	import gate.sirius.isometric.Biome;
	import gate.sirius.log.ULog;
	import gate.sirius.log.signals.ULogSignal;
	import gate.sirius.meta.Console;
	import gate.sirius.modloader.ModLoader;
	import gate.sirius.modloader.models.BasicViewport;
	import gate.sirius.modloader.signals.ResourceSignal;
	/**
	 * ...
	 * @author Rim Project
	 */
	public class BasicEngine {
		
		private var _viewport:BasicViewport;
		
		private var _mods:ModLoader;
		
		private var _biome:Biome;
		
		private var _desktop:Boolean;
		
		private var _log:File;
		private var _log_io:FileStream;
		
		private function _on_allModsLoaded(ticket:ResourceSignal):void { }
		
		private function _on_singleModLoaded(ticket:ResourceSignal):void { }
		
		public function BasicEngine(viewport:Sprite, console:Boolean) {
			
			_desktop = Capabilities.os.toUpperCase().indexOf('WIN') != -1;
			
			_log = new File((_desktop ? File.applicationDirectory : File.applicationStorageDirectory).resolvePath('log.txt').nativePath);
			_log_io = new FileStream();
			if (_log.exists){
				_log.copyTo(_log.parent.resolvePath('log_old.txt'), true);
				_log_io.open(_log, FileMode.WRITE);
				_log_io.close();
			}
			
			_logSystem();
			
			ULog.GATE.ON_NEW_ENTRY.hold(function(ticket:ULogSignal):void{
				var l:Boolean = false;
				switch(ticket.level){
					case 0 : {
						l = true;
						Console.pushLowMsg(ticket.message);
						break;
					}
					case 1 : {
						l = true;
						Console.pushWarningMsg(ticket.message);
						break;
					}
					case 2 : {
						l = true;
						Console.pushErrorMsg(ticket.message);
						break;
					}
				}
				if (l){
					_writeLog(ticket.message.split('&lt;').join('<').split('&gt;').join('>'));
				}
				
			});
			
			_mods = new ModLoader(null);
			_mods.signals.ON_MOD_LOADED.hold(_on_singleModLoaded);
			_mods.signals.COMPLETE.hold(_on_allModsLoaded);
			
			_viewport = new BasicViewport(viewport);
			if (console){
				Console.init(viewport.stage, true, this);
				Console.expand();
				Console.show();
			}
			_mods.start([], _desktop, new SharedBridge(this, _viewport, Console));
			_biome = new Biome(0, 0, 0, 0, 0, 0, false, 60);
			
		}
		
		private function _logSystem():void {
			_writeLog('=== STARTED AT ' + [
				(new Date().toString()),
				Capabilities.os,
				Capabilities.screenResolutionX + 'x' + Capabilities.screenResolutionX + ' (' + Capabilities.screenDPI + 'dpi)',
				'VERSION ' + Capabilities.version,
			].join(' // '));
		}
		
		private function _writeLog(message:String):void {
			_log_io.open(_log, FileMode.APPEND);
			_log_io.writeUTFBytes(message + '\r');
			_log_io.close();
		}
		
		public function get biome():Biome {
			return _biome;
		}
		
		public function get mods():ModLoader {
			return _mods;
		}
		
		public function get viewport():BasicViewport {
			return _viewport;
		}
		
	}

}

class SharedBridge {
	
	private var _Engine:Object;
	public function get Engine():Object {
		return _Engine;
	}
	
	private var _Viewport:Object;
	public function get Viewport():Object {
		return _Viewport;
	}
	
	private var _Console:Object;
	public function get Console():Object {
		return _Console;
	}
	
	public function SharedBridge(engine:Object, viewport:Object, console:Object){
		_Engine = engine;
		_Viewport = viewport;
		_Console = console;
	}
}