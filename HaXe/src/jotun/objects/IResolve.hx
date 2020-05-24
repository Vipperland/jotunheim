package jotun.objects;

/**
 * @author Rafael Moreira
 */
interface IResolve {
  
	public function getProp(name:String):Dynamic;

	public function setProp(name:String, value:Dynamic):Void;
	
}