package sirius.db.objects;

/**
 * ...
 * @author Rafael Moreira
 */
class Column {
	
	public var column:String;
	
	public var nullable:Bool;
	
	public var value:String;
	
	public var dataType:String;
	
	public var columnType:String;
	
	public var charset:String;
	
	public var key:String;
	
	public var extra:String;
	
	public var comment:String;
	
	public var position:Int;
	
	public var length:Int;
	
	public var previleges:Array<String>;
	
	public function new(data:Dynamic) {
		column = data.COLUMN_NAME;
		nullable = data.IS_NULLABLE == "YES";
		position = Std.parseInt(data.ORDINAL_POSITION);
		value = data.COLUMN_DEFAULT;
		dataType = data.DATA_TYPE;
		columnType = data.COLUMN_TYPE;
		key = data.COLUMN_KEY;
		extra = data.EXTRA;
		charset = data.CHARACTER_SET_NAME;
		comment = data.COLUMN_COMMENT;
		length = Std.parseInt(data.CHARACTER_MAXIMUM_LENGTH);
		previleges = data.PRIVILEGES.split(",");
	}
	
}