package samples.flow;
import sirius.flow.Push;
import sirius.tools.Key;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class TestPusher extends Push {

	public function new() {
		super();
	}
	
	public function foo(a:String, b:String):Dynamic {
		trace('TestPusher::foo(' + a + ',' + b + ')');
		var c:Array<Dynamic> = Dice.List(untyped __js__('arguments'), 2);
		if (c.length > 0){
			return 'bar	' + c.join(' ');
		}else{
			return a+' '+b;
		}
	}
	
	public function bar():Dynamic {
		trace('TestPusher::bar(' + Dice.List(untyped __js__('arguments')).join(' ') + ')');
		return {result:'test'}; // set this value in 'buffer' variable
	}
	
}