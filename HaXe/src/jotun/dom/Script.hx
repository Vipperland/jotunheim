package jotun.dom;
import jotun.Jotun;
import jotun.dom.Displayable;
import jotun.events.Activation;
import jotun.net.IRequest;
import jotun.utils.Filler;
import js.Browser;
import js.html.ScriptElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("Jtn.Script")
class Script extends Display {
	
	static public function get(q:String):Script {
		return cast Jotun.one(q);
	}
	
	static public function fromUrl(q:String, ?data:Dynamic, ?handler:Script->Void):Void {
		Jotun.request(q, data, 'GET', function(r:IRequest){
			var js:Script = null;
			if(r.success){
				js = fromString(r.data).publish();
				js.attribute('source', q);
			}
			if (handler != null){
				handler(js);
			}
		});
	}
	
	static public function fromString(q:String, ?data:Dynamic):Script {
		var js:Script = new Script();
		js.writeHtml(Filler.to(q, data));
		return js;
	}
	
	/**
	 * Load a list of Script elements and append its to document.head
	 * @param	url
	 * @param	handler
	 */
	static public function require(url:Dynamic, ?handler:Void->Void) {
		if (!Std.isOfType(url, Array)){
			url = [url];
		}
		if (url.length > 0) {
			var file:String = url.shift();
			if (file != null) {
				var s:Script = new Script();
				s.publish();
				s.src(file, function(e:Activation) {
					Script.require(url, handler);
				});
			}
		}else if(handler != null){
			handler();
		}
	}
	
	public var object:ScriptElement;
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createScriptElement();
		super(q, null);
		object = cast element;
	}
	
	public function type(q:String):Displayable {
		object.type = q;
		return this;
	}
	
	public function src(url:String, ?handler:Activation->Void):Void {
		object.src = url;
		if (handler != null) {
			events.load(handler, 1);
		}
	}
	
	public function async():Void {
		object.async = true;
	}
	
	override public function writeText(q:Dynamic):Displayable {
		this.object.text = q;
		return this;
	}
	
	override public function appendText(q:Dynamic):Displayable {
		this.object.text = this.object.text + q;
		return this;
	}
	
	override public function writeHtml(q:Dynamic):Displayable {
		this.object.text = q;
		return this;
	}
	
	override public function appendHtml(q:Dynamic):Displayable {
		this.object.text = this.object.text + q;
		return this;
	}
	
	public function publish():Script {
		Jotun.document.head.addChild(this);
		return this;
	}
	
}