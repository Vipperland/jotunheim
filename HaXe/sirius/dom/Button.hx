package sirius.dom;

/**
 * ...
 * @author Rafael Moreira
 */
@:extern("sru.dom.Div")
class Button extends Div {

	public function new(?q:Dynamic, ?d:String = null){
		super(q,d);
		Self.style.textAlign = "center";
		cursor("pointer");
	}
	
}