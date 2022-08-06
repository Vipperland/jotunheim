package jotun.gaming.dataform;
import jotun.gaming.dataform.PulsarLink;
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
	
	public function each(handler:Spark->Bool){
		Dice.Values(_inserts, function(v:Spark){
			return v != null && handler(v);
		});
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
	
}