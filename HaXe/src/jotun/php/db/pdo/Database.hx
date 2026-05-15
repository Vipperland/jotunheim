package jotun.php.db.pdo;

import haxe.DynamicAccess;
import php.NativeArray;

class Database {

	static public function connect(dsn : String, ?user : String, ?password : String, ?options : Dynamic):Connection {
		var pdo:Connection = null;
		if (null == options) {
			pdo = php.Syntax.code("new \\PDO({0},{1},{2})", dsn, user, password);
		}else {
			var arr : NativeArray = php.Syntax.codeDeref("array()");
			var opts:DynamicAccess<Dynamic> = cast options;
			for (key in opts.keys()){
				arr[untyped key] = opts.get(key);
			}
			pdo = php.Syntax.code("new \\PDO({0},{1},{2},{3})", dsn, user, password, arr);
		}
		return pdo;
	}
}