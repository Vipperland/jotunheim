package jotun.dom;
import jotun.Jotun;
import jotun.utils.ITable;
import js.Browser;
import jotun.tools.Utils;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("Jtn.Head")
class Head extends Display{
	
	static public function get(q:String):Head {
		return cast Jotun.one(q);
	}
	
	public function new(?q:Dynamic) {
		if (q == null){
			q = Browser.document.createHeadElement();
		}
		super(q,null);
	}
	
	override public function mount(q:String, ?data:Dynamic, ?at:Int = -1):Displayable {
		if (Jotun.resources.exists(q)){
			Jotun.resources.build(q, data).children().each(cast addChild);
			
		}else {
			writeHtml('/* <!> mod:' + q + ' not found */');
		}
		return this;
	}
	
	public function bind(content:String, type:String, ?id:String):Displayable {
		if(content != null){
			var s:Displayable;
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
					s.attribute('jtn-mod', Utils.getValidOne(id, 'anonymous'));
					addChild(s);
					return s;
				}
			}
		}
		return null;
	}
	
}