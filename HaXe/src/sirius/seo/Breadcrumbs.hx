package sirius.seo;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Breadcrumbs extends SEO {
	
	public var elements:Array<IItem>;
	
	public function new() {
		super("BreadcrumbList");
		_setup();
	}
	
	private function _setup() {
		elements = [];
		Reflect.setField(data, "itemListElement", elements);
	}
	
	public function add(name:String, ?url:String):Void {
		elements[elements.length] = cast { "@type":"ListItem", position: elements.length, item: { "@id":url, name:name } };
	}
	
	public function reset():Breadcrumbs {
		elements.splice(0, elements.length);
		return this;
	}
	
}