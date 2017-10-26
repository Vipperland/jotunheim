package;

import samples.flow.TestPusher;
import sirius.flow.Push;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Test_JS{
	
	static public function main() {
		var o:Push = new TestPusher();
		var result:Dynamic = o.proc([
			'@buffer',
			'foo	Hello Word INNER callback',
			'bar	OUTTER callback',
			'@!',
		]);
		trace(o.log(), result.buffer);
	}
	
} 
