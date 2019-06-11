package jotun.data;
import jotun.data.IDataSet;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("jtn.data.DataSet")
class DataSet implements IDataSet {
	
	private var _content:Dynamic;
	
	public function new(?q:Dynamic) {
		_content = q != null ? q : {};
	}
	
	/* INTERFACE data.IDataSet */
	
	public function get(p:Dynamic):Dynamic {
		return Reflect.field(_content, p);
	}
	
	public function set(p:Dynamic, v:Dynamic):IDataSet {
		Reflect.setField(_content, p, v);
		return this;
	}
	
	public function unset(p:Dynamic):IDataSet {
		Reflect.deleteField(_content, p);
		return this;
	}
	
	public function exists(p:Dynamic):Bool {
		return Reflect.hasField(_content, p);
	}
	
	public function clear():IDataSet {
		_content = { };
		return this;
	}
	
	public function find(v:Dynamic):Array<Dynamic> {
		var r:Array<String> = [];
		Dice.All(_content, function(p:Dynamic, x:Dynamic) {
			if (Std.is(x, String) && x.indexOf(v) != -1) r[r.length] = p;
			else if(x == v) r[r.length] = p;
		});
		return r;
	}
	
	public function index():Array<String> {
		var r:Array<String> = [];
		Dice.Params(_content, r.push);
		return r;
	}
	
	public function values():Array<Dynamic> {
		var r:Array<Dynamic> = [];
		Dice.Values(_content, r.push);
		return r;
	}
	
	public function filter(p:Dynamic, ?handler:Dynamic):IDataSet {
		var r:IDataSet = new DataSet();
		var h:Bool = handler != null;
		Dice.All(_content, function(p2:String, v:Dynamic) {
			if (Std.is(v, IDataSet)) {
				if (v.exists(p)) r.set(p2, h ? handler(v) : v.get(p));
			}else if (Reflect.hasField(v, p)) {
				r.set(p2, h ? handler(v) : Reflect.field(v, p));
			}
		});
		return r;
	}
	
	public function each(handler:Dynamic):Void {
		Dice.All(_content, handler);
	}
	
	public function data():Dynamic {
		return _content;
	}
	
}