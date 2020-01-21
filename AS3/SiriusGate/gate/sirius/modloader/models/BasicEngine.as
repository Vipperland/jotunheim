package gate.sirius.modloader.models {
	import flash.display.Sprite;
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
		
		private function _on_allModsLoaded(ticket:ResourceSignal):void {
		}
		
		
		private function _on_singleModLoaded(ticket:ResourceSignal):void {
		}
		
		public function BasicEngine(viewport:Sprite, console:Boolean) {
			
			ULog.GATE.ON_NEW_ENTRY.hold(function(ticket:ULogSignal):void{
				switch(ticket.level){
					case 0 : {
						Console.pushLowMsg(ticket.message);
						break;
					}
					case 1 : {
						Console.pushWarningMsg(ticket.message);
						break;
					}
					case 2 : {
						Console.pushErrorMsg(ticket.message);
						break;
					}
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
			_mods.start([], new SharedBridge(this, _viewport, Console));
			_biome = new Biome(0, 0, 0, 0, 0, 0, false, 60);
			
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