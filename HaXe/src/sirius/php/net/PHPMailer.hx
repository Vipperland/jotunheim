package sirius.php.net;

/**
 * ...
 * @author Rafael Moreira
 */
extern class PHPMailer{

	public function new() { }
	
	public var SMTPDebug:UInt;
	public var ErrorInfo:Dynamic;
	
	public var CharSet:String;
	
	public var Host:String;
	
	public var Username:String;
	public var Password:String;
	
	public var Subject:String;
	public var Body:String;
	public var AltBody:String;
	public var From:String;
	public var FromName:String;
	
	public var SMTPAuth:Bool;
	public var SMTPSecure:String;
	public var Port:UInt;
	
	public function isSMTP():Void;
	public function isHTML(value:Bool):Void;
	
	public function addAddress(email:String, ?name:String):Void;
	public function addReplyTo(email:String, ?name:String):Void;
	public function addCC(email:String, ?name:String):Void;
	public function addBBC(email:String, ?name:String):Void;
	public function addAttachment(name:String, path:String):Void;
	
	public function send():Bool;
	
}