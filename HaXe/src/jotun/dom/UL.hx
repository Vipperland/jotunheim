package jotun.dom;
import jotun.Jotun;
import jotun.utils.Dice;
import jotun.utils.Filler;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_dom_UL")
class UL extends Display{
	
	public static var LAYOUT:String = '<li class="{{class}}">{{label}}</li>';
	
	static public function get(q:String):UL {
		return cast Jotun.one(q);
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createUListElement();
		super(q, null);
	}
	
	@:overload(function(li:Array<Dynamic>):Array<LI>{})
	public function add(li:Dynamic):LI {
		if (Std.isOfType(li, Array)){
			var r:Array<LI> = [];
			Dice.All(li, function(p:Int, v:Dynamic):Void {
				r[p] = cast mount(Filler.to(LAYOUT, v));
			});
			return cast r;
		} else{
			return cast mount(Filler.to(LAYOUT, li));
		}
	}
	
}