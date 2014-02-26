package gate.sirius.isometric.timer {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import gate.sirius.gate.GameHUB;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class TestActiveObject implements IActiveObject {
		
		protected var _prev:int;
		protected var _tf:TextField;
		protected var _bar:Shape;
		protected var _op:Shape;
		protected var _g:Sprite;
		protected var _fps:int;
		protected var _rate:int;
		
		
		public function TestActiveObject(fps:int) {
			_fps = fps;
			_rate = 1000 / _fps;
			_g = new Sprite();
			
			_g.graphics.beginFill(0, 1);
			_g.graphics.drawRect(0, 0, 1, 9);
			_g.graphics.drawRect(50, 0, 1, 9);
			_g.graphics.drawRect(100, 0, 1, 10);
			_g.graphics.drawRect(0, 9, 100, 1);
			
			_bar = new Shape();
			_bar.graphics.beginFill(0xFF0000, 1);
			_bar.graphics.drawRect(0, 1, 10, 4);
			
			_op = new Shape();
			_op.graphics.beginFill(0x0000FF, 1);
			_op.graphics.drawRect(0, 6, 10, 2);
			
			_g.addChild(_bar);
			_g.addChild(_op);
			_tf = new TextField();
			_tf.y = 12;
			_g.addChild(_tf);
			GameHUB.instance.timer.addObject(this, fps);
		}
		
		
		/* INTERFACE gate.sirius.render.IActiveObject */
		
		public function tick(shift:Number):void {
			var t:int = getTimer() - _prev;
			var f:Number = t / _rate;
			_tf.text = _fps + "fps /" + String(t) + " ms";
			_bar.width = f * 100;
			_op.width = (t * f * _fps) / 1000 * 100;
			_prev = getTimer();
		}
		
		
		public function inactivated():void {
			GameHUB.stage.removeChild(_g);
		}
		
		
		public function activated():void {
			GameHUB.stage.addChild(_g);
		}
	
	}

}