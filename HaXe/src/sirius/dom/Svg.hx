package sirius.dom;
import js.Browser;
import js.html.Element;
import js.html.svg.SVGElement;
import sirius.tools.Utils;

/**
 * ...
 * @author Rim Project
 */
@:expose("sru.dom.Svg")
class Svg extends Display {
	
	private var _tmp_path:String;
	public var _tmp_fill:String = '#000000';
	public var _tmp_stoke:String = '#000000';
	public var _tmp_width:Int = 1;
	
	static public function get(q:String):Svg {
		return cast Sirius.one(q);
	}
	
	public var object:SVGElement;
	
	private function _getBasis(f:Bool, ?id:String):String {
		return  ' ' + (id != null ? 'id="' + id + '" ' : '') + 'stroke="' + stroke + '" stroke-width="' + lineWidth + '"' + (f ? ' fill="' + fill + '"' : '') + ' ';
	}
	
	public function new(?q:Element) {
		if (q == null) q = Browser.document.createElementNS("http://www.w3.org/2000/svg", "svg");
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
	
	public function drawCircle(x:Int, y:Int, r:Int, ?id:String):Void {
		appendHtml('<circle' + _getBasis(true, id) +  '"cx="' + x + '" cy="' + y + '" r="' + r + '" />');
	}
	
	public function openPath():Void {
		_tmp_path = '';
	}
	
	public function moveTo(x:Float, y:Float):Void {
		_tmp_path += 'M ' + x + ',' + y + ' ';
	}
	
	public function lineTo(x:Float, y:Float):Void {
		_tmp_path += 'L ' + x + ',' + y + ' ';
	}
	
	public function bezierTo(coord:Array<Array<Float>>):Void {
		_tmp_path += 'C ' + coord.join(' ') + ' ';
	}
	
	public function closePath():Void {
		if (Utils.isValid(_tmp_path)){
			appendHtml('<path d="' + _tmp_path + '" stroke="' + _tmp_stoke + '" stroke-width="' + _tmp_width + '" fill="none"></path>');
		}
	}
	
}