package jotun.seo;
import jotun.seo.Descriptor;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Person extends Descriptor {

	public function new() {
		super("Person");
	}
	
	public function build(name:String, ?social:Array<String>):Void {
		this.name(name);
		this.social(social);
		
	}
	
}