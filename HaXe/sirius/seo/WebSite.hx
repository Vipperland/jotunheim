package sirius.seo;

/**
 * ...
 * @author Rafael Moreira
 */
class WebSite extends SEO {
	
	private var _d:IWebSite;
	
	public function new() {
		super("WebSite");
		_d = cast data;
	}
	
	public function name(q:String):String {
		if (q != null) _d.name = q;
		return _d.name;
	}
	
	public function alt(q:String):String {
		if (q != null) _d.alternateName = q;
		return _d.alternateName;
	}
	
	public function url(q:String):String {
		if (q != null) _d.url = q;
		return _d.url;
	}
	
	public function build(name:String, url:String, ?alt:String):IWebSite {
		this.name(name);
		this.url(url);
		this.alt(alt);
		return _d;
	}
	
}