package iam.rim;

import haxe.Json;
import iam.rim.data.Input;
import iam.rim.data.Output;
import iam.rim.services.Posts;
import iam.rim.services.Users;
import sirius.data.DataCache;
import sirius.data.IDataCache;
import sirius.db.Token;
import sirius.Sirius;

/**
 * ...
 * @author Rafael Moreira
 */
class DevBlog {
	
	static public var data:IDataCache = new DataCache();
	
	static function main() {
		Sirius.gate.open(Token.to("localhost", 3306, "root", "", "iamrimblog"));
		switch(Input.head.toLowerCase()) {
			case "user" : {
				Users.init();
			}
			case "post" : {
				Posts.init();
			}
		}
		Output.write();
	}

}