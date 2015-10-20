package sirius.dom;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Head")
class Head extends Display{
	
	public static function get(q:String, ?h:IDisplay->Void):Head {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Dynamic, ?d:String = null) {
		if (q == null) q = Browser.document.createHeadElement();
		super(q,null,d);
	}
	
	public function bind(content:String, type:String):IDisplay {
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
				if(s != null){
					s.build(content);
					addChild(s);
					return s;
				}
			}
		}
		return null;
	}
	
}