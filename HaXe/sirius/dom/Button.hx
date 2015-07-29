package sirius.dom;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:extern("sru.dom.Div")
class Button extends Div {

	public function new(?q:Dynamic, ?d:String = null){
		super(q,d);
		Self.style.textAlign = "center";
		cursor("pointer");
	}
	
}