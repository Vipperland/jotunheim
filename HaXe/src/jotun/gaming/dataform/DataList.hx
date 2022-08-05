package jotun.gaming.dataform;
import jotun.gaming.dataform.DataList;
import jotun.utils.Dice;

/**
 * ...
 * @author 
 */
class DataList extends DataCore {

	public function new(name:String) {
		super(name);
		_deletions = [];
	}
	
	public function getData():Array<DataObject> {
		return _inserts;
	}
	
	public function each(handler:DataObject->Bool){
		Dice.Values(_inserts, function(v:DataObject){
			return v != null && handler(v);
		});
	}
	
	public function commit():Void {
		each(cast function(o:DataObject){
			o.commit();
		});
		_deletions = [];
	}
	
	override public function refresh():Void {
		super.refresh();
		each(cast function(o:DataObject){
			o.refresh();
		});
	}
	
	public function stringify(?changes:Bool):String {
		var r:String = '';
		var c:String = null;
		each(cast function(object:DataObject){
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