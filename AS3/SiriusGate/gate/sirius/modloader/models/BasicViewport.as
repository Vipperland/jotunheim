package gate.sirius.modloader.models {
	import flash.display.Sprite;
	import flash.display.Stage;
	/**
	 * ...
	 * @author Rim Project
	 */
	public class BasicViewport {
		
		private var _background:Sprite;
		
		private var _game:Sprite;
		
		private var _ui:Sprite;
		
		private var _container:Sprite;
		
		private var _root:Sprite;
		
		public function get root():Sprite {
			return _root;
		}
		
		public function get background():Sprite {
			return _background;
		}
		
		public function get game():Sprite {
			return _game;
		}
		
		public function get ui():Sprite {
			return _ui;
		}
		
		public function BasicViewport(main:Sprite) {
			_root = main;
			_background = new Sprite();
			_game = new Sprite();
			_ui = new Sprite();
			main.addChild(_background);
			main.addChild(_game);
			main.addChild(_ui);
		}
		
	}

}