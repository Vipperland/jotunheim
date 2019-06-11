package jotun.seo;
import haxe.Json;
import js.Browser;
import js.html.ScriptElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class SEO {
	
	public static function sign(o:Dynamic,type:String, ?context:Bool = true):Dynamic {
		if(context) Reflect.setField(o,"@context", "http://schema.org");
		Reflect.setField(o, "@type", type);
		return o;
	}
	
	public var object:ScriptElement;
	
	public var data:Dynamic;
	
	public function new(type:String) {
		data = { };
		Reflect.setField(data, "@context", "http://schema.org/");
		Reflect.setField(data, "@type", type);
		object = Browser.document.createScriptElement();
		object.type = "application/ld+json";
	}
	
	public function publish():Void {
		object.innerHTML = Json.stringify(data);
		if (object.parentElement == null) Browser.document.head.appendChild(object);
	}
	
	public function typeOf():String {
		return Reflect.field(data, "@type");
	}
	
}
