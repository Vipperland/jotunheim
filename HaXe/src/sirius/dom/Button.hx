package sirius.dom;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:extern("sru.dom.Div")
class Button extends Div {
	
	public static function get(q:String, ?h:IDisplay->Void):Button {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Dynamic, ?d:String = null){
		super(q,d);
		cursor("pointer");
	}
	
}