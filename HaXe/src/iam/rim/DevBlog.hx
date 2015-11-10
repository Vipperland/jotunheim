package iam.rim;

import php.Lib;
import sirius.db.Token;
import sirius.Sirius;

/**
 * ...
 * @author Rafael Moreira
 */
class DevBlog {
	
	static function main() {
		Sirius.gate.open(new Token("localhost"));
	}

}