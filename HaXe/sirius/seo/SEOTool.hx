package sirius.seo;
import haxe.Log;
import sirius.bit.BitIO;

/**
 * ...
 * @author Rafael Moreira
 */
class SEOTool{
	
	static public var WEBSITE:UInt = 1 << 0;
	
	static public var BREADCRUMBS:UInt = 1 << 1;
	
	static public var LEVEL_1:UInt = WEBSITE | BREADCRUMBS;
	
	static public var PRODUCT:UInt = 1 << 2;
	
	static public var LEVEL_2:UInt = LEVEL_1 | PRODUCT;
	
	public var website:WebSite;
	
	public var product:Product;
	
	public var breadcrumbs:Breadcrumbs;
	
	public function new() {
	}
	
	public function init(types:Int = 0):SEOTool {
		Sirius.log("Sirius::SEO --INITIALIZED", 10);
		if((types == 0 || BitIO.test(types, WEBSITE)) && website == null) website = new WebSite();
		if(BitIO.test(types, BREADCRUMBS) && breadcrumbs == null) breadcrumbs = new Breadcrumbs();
		if (BitIO.test(types, PRODUCT) && product == null) product = new Product();
		return this;
	}
	
	public function publish():Void {
		if (website != null) website.publish();
		if (product != null) product.publish();
		if (breadcrumbs != null) breadcrumbs.publish();
		Sirius.log("Sirius::SEO --PUBLISH", 10);
	}
	
}