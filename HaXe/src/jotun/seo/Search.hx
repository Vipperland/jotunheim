package jotun.seo;
import jotun.seo.ISearchBox;
import jotun.seo.SEO;
import jotun.tools.Utils;

/**
 * ...
 * @author Rafael Moreira
 */
class Search extends SEO {
	
	private var _d:ISearchBox;
	
	public function new() {
		super("WebSite");
		_d = cast data;
	}
	
	public function url(q:String):String {
		if (q != null) _d.url = q;
		return _d.url;
	}
	
	/**
	 * Set the  property name in target value, like {search_term_string}
	 * @param	target
	 * @param	query	Don´t use brackets in prop name
	 * @return
	 */
	public function action(target:String, prop:String):ISearchBox {
		if (_d != null) {
			_d.potentialAction = { "@type":"SearchAction", target:target, "query-input":("required name=" + prop) };
		}
		return _d;
	}
	
	public function build(q:String, target:String, prop:String):Search {
		url(q);
		action(target, prop);
		return this;
	}
	
}