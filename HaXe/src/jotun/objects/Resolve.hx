package jotun.objects;

/**
 * ...
 * @author Rafael Moreira
 */
class Resolve implements IResolve {

	public function new(){ };
	
	public function getProp(name:String):Dynamic {
		return Reflect.field(this, name);
	}

	public function setProp(name:String, value:Dynamic):Void {
		Reflect.setField(this, name, value);
	}
	
	public function delProp(name:String):Void {
		Reflect.deleteField(this, name);
	}

}