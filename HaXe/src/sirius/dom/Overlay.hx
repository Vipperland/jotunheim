package sirius.dom;
import haxe.Timer;
import sirius.css.Automator;

/**
 * ...
 * @author Rafael Moreira <vipperland[at]live.com>
 */
@:expose('Overlay')
class Overlay {
	
	static private var _queue:Array<IDisplay> = [];
	
	static private var _main:IDisplay;
	
	static private var _container:IDisplay;
	
	static private var _current:IDisplay;
	
	static private var _timer:Timer;
	
	static private var _started:Bool;
	
	static private var _busy:Bool;
	
	static public function push(content:Dynamic):Void {
		if (_main == null) _init();
		if (content != null){
			if (!Std.is(content, IDisplay)){
				content = Sirius.one(content);
				if (content == null)
					return;
			}
			content.css('ease-all-300ms-ease');
			_queue.push(content);
			content.remove();
		}
	}
	
	static private function _init() {
		_main = new Div();
		_main.css('sprite overlay ease-all-200ms-ease');
		_container = new Div();
		_main.addChild(_container);
		_main.hide();
		Automator.build('fix bg-x99000000 t-0 l-0 r-0 b-0 scroll-y z-9999999', '.overlay', true);
		Automator.build('h-100pc scroll', '.overlay > div', true);
		Automator.build('ease-all-200ms-ease ease-all-300ms-ease');
		Automator.enableSprites();
		Sirius.document.body.addChild(_main);
	}
	
	static private function _animateOut():Void {
		_busy = true;
		_current.element.style.marginTop = '100px';
		_current.alpha(0);
		_timer = Timer.delay(function(){
			_current.remove();
			_current = null;
			_clear();
			show();
		}, 500);
	}
	
	static private function _animateIn():Void {
		_busy = true;
		_current = _queue.shift();
		_current.element.style.marginTop = '-50px';
		_container.addChild(_current);
		_timer = Timer.delay(function(){
			_current.element.style.marginTop = '0px';
			_clear();
		}, 100);
	}
	
	static public function show(?content:Dynamic):Void {
		if (content != null) push(content);
		//Se existir algum saindo, esperar
		if (_busy) return;
		// Se existir alguem na fila, exibir
		_busy = true;
		if (_current != null){
			_animateOut();
			return;
		}
		if (_queue.length > 0){
			// Se não existir ninguem na view, animar a entrada e somente depois exibir o primeiro elemento
			if (!_started){
				Sirius.document.body.overflow('hidden');
				_startIn();
			}else{
				_animateIn();
			}
		}else if(_started) {
			_main.alpha(0);
			_timer = Timer.delay(function(){
				_main.hide();
				_started = false;
				_clear();
			}, 300);
			Sirius.document.body.overflow('');
		}
	}
	
	static private function _clear() {
		_timer.stop();
		_timer = null;
		_busy = false;
	}
	
	static private function _startIn() {
		_started = true;
		_main.alpha(0);
		_main.show();
		_timer = Timer.delay(function(){
			_main.alpha(1);
			_timer.stop();
			_animateIn();
		}, 100);
	}
	
	public static function dismiss(?all:Bool):Void {
		if(all)
			_queue = [];
		show();
	}
	
}