package sirius.php.db.pdo;
import php.NativeArray;

/**
 * ...
 * @author Rafael Moreira
 */
extern class Statement
{
	public function bindColumn(column : Dynamic, param : Dynamic, ?type : Int, ?maxlen : Int, ?driverdata : Dynamic) : Bool;
	public function bindParam(parameter : Dynamic, variable : Dynamic, ?data_type : Int, ?length : Int, ?driver_options : Dynamic) : Bool;
	public function bindValue(parameter : Dynamic, value : Dynamic, ?data_type : Int) : Bool;
	public function closeCursor() : Bool;
	public function columnCount() : Int;
	public function debugDumpParams() : Bool;
	public function errorCode() : String;
	public function errorInfo() : NativeArray;
	public function execute(input_parameters : NativeArray) : Bool;
	public function fetch(?fetch_style : Int = 4, ?cursor_orientation : Int = 0, ?cursor_offset : Int = 0) : Dynamic;
	public function fetchAll(?fetch_style : Int) : NativeArray;
	public function fetchColumn(?column_number : Int = 0) : String;
	public function fetchObject(?class_name : String, ?ctor_args : NativeArray) : Dynamic;
	public function getAttribute(attribute : Int) : Dynamic;
	public function getColumnMeta(column : Int) : NativeArray;
	public function nextRowset() : Bool;
	public function rowCount() : Int;
	public function setAttribute(attribute : Int, value : Dynamic) : Bool;
	public function setFetchMode(mode : Int, ?fetch : Dynamic, ?ctorargs : NativeArray) : Bool;
}