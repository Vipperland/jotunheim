package sirius.db;

/**
 * ...
 * @author Rafael Moreira
 */
class Token {
	
	public static function from(host:String, port:UInt, user:String, pass:String, db:String, ?options:Array<UInt>):Token {
		return new Token(host, port, user, pass, db, options);
	}
	
	public static function localhost(db:String, ?pass:String='', ?options:Array<UInt>):Token {
		return new Token('localhost', 3306, 'root', pass, db, options);
	}
	
	public var options:Array<UInt>;
	public var db:String;
	public var pass:String;
	public var user:String;
	public var host:String;

	public function new(host:String, port:UInt, user:String, pass:String, db:String, ?options:Array<UInt>) {
		this.db = db;
		this.options = options;
		this.pass = pass;
		this.user = user;
		this.host = "mysql:host=" + host + ";port=" + port + ";dbname=" + db + ";charset=UTF8";
	}
	
}