package jotun.gaming.dataform;
import jotun.gaming.dataform.PulsarLink;
import jotun.gaming.dataform.Spark;
import jotun.utils.Dice;

/**
 * ...
 * @author 
 */
class PulsarLink extends SparkCore {
	
	public function new(name:String) {
		super(name);
		_deletions = [];
	}
	
	public function getData():Array<Spark> {
		return _inserts;
	}
	
	public function commit():Void {
		each(cast function(o:Spark){
			o.commit();
		});
		_deletions = [];
	}
	
	override public function refresh():Void {
		super.refresh();
		each(cast function(o:Spark){
			o.refresh();
		});
	}
	
	public function stringify(?changes:Bool):String {
		var r:String = '';
		var c:String = null;
		each(cast function(object:Spark){
			c = object.stringify(changes);
			if (c != null){
				r += (r.length > 0 ? '\n' : '') + c;
			}
		});
		c = _getDelString('-');
		if (c != null){
			r += (r.length > 0 ? '\n' : '') + c;
		}
		return r;
	}
	
	public function isSingle():Bool {
		return _inserts.length == 1 && _inserts[0].prop('*') != null;
	}
	
	public function getObject(?o:Array<Dynamic>):Dynamic {
		if (isSingle()){
			return _inserts[0].prop('*');
		}else{
			if (o == null) {
				o = [];
			}
			Dice.Values(_inserts, function(v:Spark){
				v.getObject(o);
			});
			return o;
		}
	}
	
	override public function filter(?name:String, ?handler:Spark->Bool, ?merge:Array<Spark>):Array<Spark> {
		if (merge == null){
			merge = [];
		}
		each(function(v:Spark):Bool{
			v.filter(name, handler, merge);
			return false;
		});
		return merge;
	}
	
}