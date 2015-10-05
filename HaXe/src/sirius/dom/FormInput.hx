package sirius.dom;
import js.Browser;
import js.html.Element;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("sru.dom.FormInput")
class FormInput extends Div {
	
	public var name:Div;
	
	public var input:Input;
	
	public function new(?q:Element, ?d:String = null) {
		if (q == null) q = Browser.document.createDivElement();
		super(q, d);
		name = cast one('div');
		input = cast one('input');
		if (name == null) {
			name = new Div();
			addChild(name);
		}
		if (input == null) {
			input = new Input();
			addChild(input);
		}
	}
	
	public function label(?q:String):String {
		if(q != null){
			name.clear(true);
			name.build(q);
		}
		return name.element.innerHTML;
	}
	
}