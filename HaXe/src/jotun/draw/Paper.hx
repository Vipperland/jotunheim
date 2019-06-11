package jotun.draw;
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
@:expose("jtn.draw.Paper")
class Paper {
	
	private var _tmp_path:String;

	public function new() {
		erase();
	}
	
	public function erase():Void {
		_tmp_path = '';
	}
	
	public function m(x:Float, y:Float):Void {
		_tmp_path += 'M ' + x + ',' + y + ' ';
	}
	
	public function l(x:Float, y:Float):Void {
		_tmp_path += 'L ' + x + ',' + y + ' ';
	}
	
	public function c(coord:Array<Array<Dynamic>>):Void {
		Dice.Values(coord, function(v:Array<Dynamic>){
			_tmp_path += 'C ' + v.join(',') + ' ';
		});
	}
	
	public function q(a:Float, b:Float, x:Float, y:Float):Void {
		_tmp_path += 'Q ' + a + ',' + b + ' ' + x + ',' + y + ' ';
	}
	
	public function s(a:Float, b:Float, x:Float, y:Float):Void {
		_tmp_path += 'S ' + a + ',' + b + ' ' + x + ',' + y + ' ';
	}
	
	public function t(x:Float, y:Float):Void {
		_tmp_path += 'T ' + x + ',' + y + ' ';
	}
	
	public function z():Void {
		_tmp_path += 'Z ';
	}
	
	public function dVal():String {
		return 'd(' + _tmp_path + ')';
	}
	
	public function val():String {
		return _tmp_path;
	}
	
}