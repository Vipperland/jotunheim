package jotun.dom;
import haxe.DynamicAccess;
import jotun.Jotun;
import js.Browser;
import js.html.Element;
import js.html.svg.SVGElement;

/**
 * ...
 * @author Rim Project
 */
@:expose("Jtn.Svg")
class Svg extends Display {
	
	static public function get(q:String):Svg {
		return cast Jotun.one(q);
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
		return element.hasAttributeNS(null, name) || (cast element:DynamicAccess<Dynamic>).exists(name);
	}

	override public function attribute(name:String, ?value:Dynamic):Dynamic {
		if (name != null) {
			var el:DynamicAccess<Dynamic> = cast element;
			var t:Dynamic = el.get(name);
			if (t != null) {
				if (value != null)
					el.set(name, value);
				return el.get(name);
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
			var el:DynamicAccess<Dynamic> = cast element;
			if (el.exists(name)) {
				el.remove(name);
			}else{
				value = attribute(name);
				element.removeAttributeNS(null, name);
			}
		}
		return value;
	}

}