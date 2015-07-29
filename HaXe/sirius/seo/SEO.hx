package sirius.seo;
import haxe.Json;
import haxe.Log;
import js.Browser;
import js.html.ScriptElement;

/**
 * ...
 * @author Rafael Moreira
 */
class SEO {
	
	public var object:ScriptElement;
	
	public var data:Dynamic;
	
	public function new(type:String) {
		data = { };
		Reflect.setField(data, "@context", "http://schema.org/");
		Reflect.setField(data, "@type", type);
		object = Browser.document.createScriptElement();
		object.type = "application/ld+json";
		Sirius.log("Sirius::SEO @" + typeOf() + " --CREATED", 10);
	}
	
	public function publish():Void {
		object.innerHTML = Json.stringify(data);
		if (object.parentElement == null) Browser.document.head.appendChild(object);
	}
	
	public function typeOf():String {
		return Reflect.field(data, "@type");
	}
	
}