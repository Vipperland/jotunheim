package gate.sirius.modloader.models {
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.Capabilities;
	import gate.sirius.isometric.Biome;
	import gate.sirius.log.ULog;
	import gate.sirius.log.signals.ULogSignal;
	import gate.sirius.meta.Console;
	import gate.sirius.modloader.ModLoader;
	import gate.sirius.modloader.data.ContextBridge;
	import gate.sirius.modloader.models.BasicViewport;
	import gate.sirius.modloader.signals.ResourceSignal;
	import gate.sirius.signals.DynamicSignals;
	import gate.sirius.signals.Signal;
	import gate.sirius.signals.SignalDispatcher;
	/**
	 * ...
	 * @author Rim Project
	 */
	public class BasicEngine {
		
		private var _viewport:BasicViewport;
		
		private var _mods:ModLoader;
		
		private var _biome:Biome;
		
		private var _desktop:Boolean;
		
		private var _signals:DynamicSignals;
		
		private var _dev:Object;
		
		private var _log:File;
		
		private var _log_io:FileStream;
		
		protected function _on_allModsLoaded(ticket:ResourceSignal):void {
		}
		
		protected function _on_singleModLoaded(ticket:ResourceSignal):void { }
		
		protected function _on_configLoaded(ticket:ResourceSignal):void {
			if (_mods.config.properties.console){
				if (_mods.config.properties.devmode){
					Console.setDevMode();
					Console.show();
					Console.expand();
				}else{
					Console.setLogMode();
				}
			}
		}
		
		private function _logSystem(stage:Stage):void {
			_writeLog('=== STARTED AT ' + [
				(new Date().toString()),
				Capabilities.os,
				Capabilities.screenResolutionX + 'x' + Capabilities.screenResolutionY + ' (' + Capabilities.screenDPI + 'dpi)',
				stage.stageWidth + 'x' + stage.stageHeight,
				'FPS ' + (stage ? stage.frameRate : '--'),
				'VERSION ' + Capabilities.version,
				'DEBUG:' + Capabilities.isDebugger
			].join(' // '));
		}
		
		private function _writeLog(message:String):void {
			_log_io.open(_log, FileMode.APPEND);
			_log_io.writeUTFBytes(message + '\r');
			_log_io.close();
		}
		
		public function BasicEngine(viewport:Sprite) {
			
			_desktop = Capabilities.os.toUpperCase().indexOf('WIN') != -1;
			
			_log = new File((_desktop ? File.applicationDirectory : File.applicationStorageDirectory).resolvePath('log.txt').nativePath);
			_log_io = new FileStream();
			if (_log.exists){
				_log.copyTo(_log.parent.resolvePath('log_old.txt'), true);
				_log_io.open(_log, FileMode.WRITE);
				_log_io.close();
			}
			
			_logSystem(viewport.stage);
			
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
			_mods.signals.ON_CONFIG.hold(_on_configLoaded);
			_mods.signals.ON_MOD_LOADED.hold(_on_singleModLoaded);
			_mods.signals.COMPLETE.hold(_on_allModsLoaded);
			
			Console.init(viewport.stage, this);
			
			_viewport = new BasicViewport(viewport);
			_biome = new Biome(0, 0, 0, 0, 0, 0, false, 60);
			_signals = new DynamicSignals(this);
			
			_mods.start([], _desktop, new ContextBridge(this));
			
		}
		
		public function get biome():Biome {
			return _biome;
		}
		
		public function get mods():ModLoader {
			return _mods;
		}
		
		public function get signals():DynamicSignals {
			return _signals;
		}
		
		public function get viewport():BasicViewport {
			return _viewport;
		}
		
	}

}
