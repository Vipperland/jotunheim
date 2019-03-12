package sirius.draw;

/**
 * ...
 * @author Rim Project
 */
@:expose("sru.draw.Book")
class Book {
	
	public var pages:Dynamic;
	
	/**
	   Create a collection for SVG path data
	**/
	public function new() {
		pages = {};
	}
	
	/**
	   Create a new Page
	   @param	name
	   @return
	**/
	public function create(name:String):Paper {
		return add(name, new Paper());
	}
	
	/**
	   Add a new page
	   @param	name
	   @param	page
	   @return
	**/
	public function add(name:String, page:Paper):Paper {
		Reflect.setField(pages, name, page);
		return page;
	}
	
	/**
	   Get a page
	   @param	name
	   @return
	**/
	public function get(name:String):Paper {
		return Reflect.getProperty(pages, name);
	}
	
	/**
	   Get a page d() value for SVG path
	   @param	name
	   @return
	**/
	public function getDVal(name:String):String {
		var p:Paper = get(name);
		if (p != null){
			return p.dVal();
		}else{
			return '';
		}
	}
	
	/**
	   Get a page path data
	   @param	name
	   @return
	**/
	public function getVal(name:String):String {
		var p:Paper = get(name);
		if (p != null){
			return p.val();
		}else{
			return '';
		}
	}
	
	/**
	   Remove a page
	   @param	name
	   @return
	**/
	public function remove(name:String):Paper {
		var p:Paper = get(name);
		Reflect.deleteField(pages, name);
		return p;
	}
	
}