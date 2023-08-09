package jotun.dom;
import jotun.Jotun;
import jotun.dom.IDisplay;
import jotun.events.IEvent;
import jotun.net.IRequest;
import jotun.utils.Filler;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_Style")
class Style extends Display {
	
	static public function get(q:String):Style {
		return cast Jotun.one(q);
	}
	
	static public function fromUrl(q:String, ?data:Dynamic, ?handler:Style->Void):Void {
		Jotun.request(q, null, 'GET', function(r:IRequest){
			var css:Style = null;
			if(r.success){
				css = cast fromString(r.data).addToBody();
			}
			if (handler != null){
				handler(css);
			}
		});
	}
	
	static public function fromString(q:String, ?data:Dynamic):Style {
		var css:Style = new Style();
		css.writeHtml(Filler.to(q, data));
		return css;
	}
	
	static public function require(url:Dynamic, handler:Dynamic) {
		if (!Std.isOfType(url, Array)){
			url = [url];
		}
		if (url.length > 0) {
			var file:String = url.shift();
			if (file != null) {
				var s:Link = new Link();
				s.href(file, function(e:IEvent) {
					Style.require(url, handler);
				});
				Jotun.document.head.addChild(s);
			}
		}else if(handler != null){
			handler();
		}
	}
	
	override public function mount(q:String, ?data:Dynamic, ?at:Int = -1):IDisplay {
		if (Jotun.resources.exists(q)){
			writeHtml(Jotun.resources.get(q, data));
		}else {
			writeHtml('/* <!> mod:' + q + ' not found */');
		}
		return this;
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createStyleElement();
		super(q, null);
		(cast element).type = "text/css";
	}
	
	override public function addToBody():IDisplay {
		Browser.document.head.appendChild(cast element);
		return this;
	}
	
}