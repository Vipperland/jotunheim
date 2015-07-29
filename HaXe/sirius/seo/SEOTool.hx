package sirius.seo;
import sirius.bit.BitIO;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("SEO")
class SEOTool{
	
	static public var WEBSITE:UInt = 1 << 0;
	
	static public var BREADCRUMBS:UInt = 1 << 1;
	
	static public var PRODUCT:UInt = 1 << 2;
	
	public var website:WebSite;
	
	public var product:Product;
	
	public var breadcrumbs:Breadcrumbs;
	
	public function new() {
	}
	
	public function init(types:Int = 0):SEOTool {
		if((types == 0 || BitIO.test(types, WEBSITE)) && website == null) website = new WebSite();
		if(BitIO.test(types, BREADCRUMBS) && breadcrumbs == null) breadcrumbs = new Breadcrumbs();
		if (BitIO.test(types, PRODUCT) && product == null) product = new Product();
		return this;
	}
	
	public function publish():Void {
		if (website != null) website.publish();
		if (product != null) product.publish();
		if (breadcrumbs != null) breadcrumbs.publish();
	}
	
}