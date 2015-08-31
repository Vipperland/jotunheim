package sirius.data;
import sirius.data.IDataSet;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class DataSet implements IDataSet {
	
	public function new() {
		
	}
	
	/* INTERFACE data.IDataSet */
	
	public function get(p:String):Dynamic {
		return Reflect.field(this, p);
	}
	
	public function set(p:String, v:Dynamic):IDataSet {
		Reflect.setField(this, p, v);
		return this;
	}
	
	public function exists(p:String):Bool {
		return Reflect.hasField(this, p);
	}
	
	public function clear():DataSet {
		Dice.Params(this, function(p:String) {
			Reflect.deleteField(this, p);
		});
		return this;
	}
	
	public function find(v:String):Array<String> {
		var r:Array<String> = [];
		Dice.All(this, function(p:String, x:String) {
			if (x != null && x.indexOf(v) != -1) r[r.length] = p;
		});
		return r;
	}
	
}