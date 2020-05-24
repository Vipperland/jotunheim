package jotun.objects;

/**
 * @author Rim Project
 */
interface IQuery extends IResolve {
	
	public function log():Array<String>;
	
	public function flush():Void;
	
	public function proc(data:Dynamic, ?result:Dynamic):Dynamic;
	
}