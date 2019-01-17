package sirius.draw;

/**
 * ...
 * @author Rim Project
 */
@:expose("sru.draw.Book")
class Book {
	
	public var pages:Dynamic;
	
	public function new() {
		pages = {};
	}
	
	public function create(name:String):Paper {
		return add(name, new Paper());
	}
	
	public function add(name:String, page:Paper):Paper {
		Reflect.setField(pages, name, page);
		return page;
	}
	
	public function get(name:String):Paper {
		return Reflect.getProperty(pages, name);
	}
	
	public function remove(name:String):Paper {
		var p:Paper = get(name);
		Reflect.deleteField(pages, name);
		return p;
	}
	
}