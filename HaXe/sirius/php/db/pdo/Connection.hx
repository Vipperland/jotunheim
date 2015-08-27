package sirius.php.db.pdo;
import php.NativeArray;
/**
 * ...
 * @author Rafael Moreira
 */
extern class Connection
{
	public function beginTransaction() : Bool;
	public function commit() : Bool;
	public function errorCode() : Dynamic;
	public function errorInfo() : NativeArray;
	public function exec(statement : String) : Int;
	public function getAttribute(attribute : Int) : Dynamic;
	public function getAvailableDrivers() : NativeArray;
	public function lastInsertId(?name : String) : String;
	public function prepare(statement : String, driver_options : NativeArray) : Statement;
	public function query(statement : String, mode : Int) : Statement;
	public function quote(String : String, ?parameter_type : Int = 2) : String;
	public function rollBack() : Bool;
	public function setAttribute(attribute : Int, value : Dynamic) : Bool;
}