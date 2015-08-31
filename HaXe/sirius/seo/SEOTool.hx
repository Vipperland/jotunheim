package sirius.seo;
import sirius.seo.Organization;
import sirius.seo.Person;
import sirius.tools.BitIO;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("SEO")
class SEOTool{
	
	static public var WEBSITE:UInt = 1 << 0;
	
	static public var BREADCRUMBS:UInt = 1 << 1;
	
	static public var PRODUCT:UInt = 1 << 2;
	
	static public var ORGANIZATION:UInt = 1 << 3;
	
	static public var PERSON:UInt = 1 << 4;
	
	public var website:WebSite;
	
	public var product:Product;
	
	public var breadcrumbs:Breadcrumbs;
	
	public var organization:Organization;
	
	public var person:Person;
	
	private var _publish:Array<SEO>;
	
	private function _create(t:String, O:Dynamic):Void {
		if (Reflect.field(this, t) == null) {
			O = untyped __js__("new O()");
			Reflect.setField(this, t, O);
			_publish[_publish.length] = O;
		}
	}
	
	public function new() {
		_publish = [];
	}
	
	public function init(types:Int = 0):SEOTool {
		if ((types == 0 || BitIO.Test(types, WEBSITE))) _create('website', WebSite);
		if (BitIO.Test(types, BREADCRUMBS)) _create('breadcrumbs', Breadcrumbs);
		if (BitIO.Test(types, PRODUCT)) _create('product', Product);
		if (BitIO.Test(types, ORGANIZATION)) _create('organization', Organization);
		if (BitIO.Test(types, PERSON)) _create('person', Person);
		return this;
	}
	
	public function publish():Void {
		Dice.Values(_publish, function(seo:SEO) {
			seo.publish();
		});
	}
	
}