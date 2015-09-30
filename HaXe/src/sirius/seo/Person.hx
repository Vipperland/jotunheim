package sirius.seo;
import sirius.seo.Descriptor;
import sirius.utils.Dice;

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