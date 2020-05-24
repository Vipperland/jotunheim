package jotun.php.db.pdo;

import php.NativeArray;

class Database {

	static public function connect(dsn : String, ?user : String, ?password : String, ?options : Dynamic):Connection {
		var pdo:Connection = null;
		if (null == options) {
			pdo = php.Syntax.code("new \\PDO({0},{1},{2})", dsn, user, password);
		}else {
			var arr : NativeArray = php.Syntax.codeDeref("array()");
			for (key in Reflect.fields(options)){
				arr[untyped key] = Reflect.field(options, key);
			}
			pdo = php.Syntax.code("new \\PDO({0},{1},{2},{3})", dsn, user, password, arr);
		}
		return pdo;
	}
}