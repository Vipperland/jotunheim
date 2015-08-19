package seo;
import sirius.seo.Descriptor;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Organization extends Descriptor {

	public function new() {
		super("Organization");
	}
	
	public function build(name:String, url:String, logo:String, ?social:Array<String>):Void {
		this.name(name);
		this.url(url);
		this.logo(logo);
		this.social(social);
	}
	
}