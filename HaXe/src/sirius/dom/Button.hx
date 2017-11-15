package sirius.dom;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:extern("sru.dom.Div")
class Button extends Div {
	
	static public function get(q:String):Button {
		return cast Sirius.one(q);
	}
	
	public function new(?q:Dynamic){
		super(q);
		style('cursor', 'pointer');
	}
	
}