package sirius.db.objects;

/**
 * @author Rim Project
 */
interface IExtQuery extends IQuery {
  
	public var data:Array<Dynamic>;
	
	public function each(handler:Dynamic->Bool):Void;
	
	public function one(i:Int):Dynamic;
	
	public function first():Dynamic;
	
	public function last():Dynamic;
	
	public function slice():Dynamic;
	
}