package sirius.dom;
import js.Browser;
import js.html.BaseElement;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("sru.dom.Select")
class Select extends Display{

	public function new(?q:Dynamic, ?d:String = null) {
		if (q == null) q = Browser.document.createSelectElement();
		super(q,null,d);
	}
	
}