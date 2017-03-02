package samples.flow;
import sirius.flow.Push;
import sirius.tools.Key;

/**
 * ...
 * @author Rafael Moreira
 */
class TestPusher extends Push {

	public function new() {
		super();
	}
	
	public function foo(a:String, b:String, c:String):Dynamic {
		trace('TestPusher::foo(' + a + ',' + b + ')');
		if (c != null){
			return 'bar	' + c;
		}else{
			return a+' '+b;
		}
	}
	
	public function bar(a:String):Dynamic {
		trace('TestPusher::bar(' + a + ')');
		return {result:'test'};
	}
	
}