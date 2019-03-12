package sirius.dom;
import js.Browser;
import js.html.Element;
import js.html.svg.SVGElement;
import sirius.draw.Paper;

/**
 * ...
 * @author Rim Project
 */
@:expose("sru.dom.Svg")
class Svg extends Display {
	
	public var _tmp_fill:String = '#FF0000';
	public var _tmp_stoke:String = '#CC0000';
	public var _tmp_width:Int = 1;
	
	static public function get(q:String):Svg {
		return cast Sirius.one(q);
	}
	
	public var object:SVGElement;
	
	public function new(?q:Element) {
		if (q == null) {
			q = Browser.document.createElementNS("http://www.w3.org/2000/svg", "svg");
		}
		super(q, null);
		object = cast element;
	}
	
	override public function hasAttribute(name:String):Bool {
		return element.hasAttributeNS(null, name) || Reflect.hasField(element, name);
	}
	
	override public function attribute(name:String, ?value:Dynamic):Dynamic {
		if (name != null) {
			var t:String = Reflect.field(element, name);
			if (t != null) {
				if (value != null)
					Reflect.setField(element, name, value);
				return Reflect.field(element, name);
			}
			if (value != null) {
				if (_setattr)
					element.setAttributeNS(null, name, value);
				return value;
			}
			if(_getattr)
				return element.getAttributeNS(null, name);
		}
		return null;
	}
	
	override public function clearAttribute(name:String):Dynamic {
		var value:Dynamic = null;
		if (hasAttribute(name)) {
			if (Reflect.hasField(element, name)) {
				Reflect.deleteField(element, name);
			}else{
				value = attribute(name);
				element.removeAttributeNS(null, name);
			}
		}
		return value;
	}

	public function draw(paper:Paper, ?stroke:String = "#000000", ?width:Int = 1, ?fill:String = "none"):Void {
		appendHtml('<path d="' + paper.val() + '" stroke="' + stroke + '" stroke-width="' + width + '" fill="' + fill + '"></path>');
	}
	
}