package sirius.dom;
import js.Browser;
import js.html.BaseElement;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("sru.dom.TD")
class TD extends Display{

	public function new(?q:Dynamic, ?d:String = null) {
		if (q == null) q = Browser.document.createTableCellElement();
		super(q,null,d);
	}
	
}