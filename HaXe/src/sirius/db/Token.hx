package sirius.db;

/**
 * ...
 * @author Rafael Moreira
 */
class Token {
	
	public static function to(host:String, port:UInt, user:String, pass:String, db:String, ?options:Array<UInt>):Token {
		return new Token(host, port, user, pass, db, options);
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