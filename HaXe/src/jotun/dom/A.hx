package jotun.dom;
import haxe.DynamicAccess;
import jotun.Jotun;
import jotun.utils.Dice;
import js.Browser;
import js.html.AnchorElement;


/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("Jtn.A")
class A extends Display {
	
	static public function get(q:String):A {
		return cast Jotun.one(q);
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createAnchorElement();
		super(q,null);
	}
	
	public function href(?url:String):String {
		if(url != null)
			attribute('href', url);
		return path();
	}
	
	public function path():String {
		return attribute('href').split(Jotun.domain.host).pop();
	}
	
	public function url():String {
		return (cast element:AnchorElement).pathname;
	}

	public function link():Dynamic {
		var ae:DynamicAccess<String> = cast element;
		var uri:DynamicAccess<String> = {};
		Dice.Values(['href', 'protocol', 'host', 'hostname', 'port', 'pathname', 'search', 'hash'], function(v:String){
			uri.set(v, ae.get(v));
		});
		return uri;
	}
	
	public function target(?q:String):String {
		if(q != null)
			attribute('target', q);
		return attribute('target');
	}
	
}