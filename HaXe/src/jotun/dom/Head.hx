package jotun.dom;
import jotun.Jotun;
import js.Browser;
import jotun.tools.Utils;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("jtn.dom.Head")
class Head extends Display{
	
	static public function get(q:String):Head {
		return cast Jotun.one(q);
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createHeadElement();
		super(q,null);
	}
	
	public function bind(content:String, type:String, ?id:String):IDisplay {
		if(content != null){
			var s:IDisplay;
			if (content.length > 1) {
				switch(type) {
					case 'css', 'style': { 
						s = Style.fromString(content.split("<style>").join("").split("</style>").join(""));
					}
					case 'javascript', 'script': { 
						s = Script.fromString(content.split("<script>").join("").split("</script>").join(""));
					}
					default : {
						s = null;
					}
				}
				if (s != null) {
					s.attribute('module-id', Utils.isValid(id) ? id : '');
					addChild(s);
					return s;
				}
			}
		}
		return null;
	}
	
}