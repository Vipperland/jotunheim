package sirius.dom;
import js.Browser;
import sirius.tools.Utils;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Head")
class Head extends Display{
	
	static public function get(q:String):Head {
		return cast Sirius.one(q);
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
						s = new Style(); 
						content = content.split("<style>").join("").split("</style>").join("");
					}
					case 'javascript', 'script': { 
						s = new Script(); 
						content = content.split("<script>").join("").split("</script>").join("");
					}
					default : {
						s = null;
					}
				}
				if (s != null) {
					s.attribute('module-id', Utils.isValid(id) ? id : '');
					s.writeHtml(content);
					addChild(s);
					return s;
				}
			}
		}
		return null;
	}
	
}