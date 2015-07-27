package sirius.dom;
import js.Browser;
import js.html.BaseElement;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("sru.dom.HR")
class HR extends Display{

	public function new(?q:Dynamic, ?d:String = null) {
		if (q == null) q = Browser.document.createHRElement();
		super(q,null,d);
	}
	
}