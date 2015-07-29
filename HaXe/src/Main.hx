package;

import js.Lib;
import sirius.seo.SEOTool;
import sirius.Sirius;

/**
 * ...
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */
class Main {
	
	static function main() {
		Sirius.seo.init(SEOTool.LEVEL_2);
		Sirius.seo.publish();
	}
	
}