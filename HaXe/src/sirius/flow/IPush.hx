package sirius.flow;

/**
 * @author Rim Project
 */
interface IPush implements Dynamic {
	
	public function log():Array<String>;
	
	public function flush():Void;
	
	public function proc(data:Dynamic):Dynamic;
	
}