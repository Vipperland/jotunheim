package sirius.php.db.pdo;

import php.NativeArray;

class Bridge {

	static public function open(dsn : String, ?user : String, ?password : String, ?options : Dynamic):Connection {
		var pdo:Connection = null;
		if (null == options) {
			pdo = untyped __call__("new PDO", dsn, user, password);
		}else {
			var arr : NativeArray = untyped __call__("array");
			for (key in Reflect.fields(options))
				arr[untyped key] = Reflect.field(options, key);
			pdo = untyped __call__("new PDO", dsn, user, password, arr);
		}
		return pdo;
	}
}