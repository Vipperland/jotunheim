package jotun.seo;
import jotun.seo.IContact;
import jotun.seo.IOrgDescriptor;
import jotun.seo.Descriptor;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Organization extends Descriptor {
	
	private var _e:IOrgDescriptor;
	
	public function new() {
		super("Organization");
		_e = cast this.data;
	}
	
	public function build(name:String, url:String, logo:String, email:String, ?social:Array<String>):Void {
		this.name(name);
		this.url(url);
		this.logo(logo);
		this.email(email);
		this.social(social);
	}
	
	/**
	 * customer service
	 * technical support
	 * billing support
	 * bill payment
	 * sales
	 * reservations
	 * credit card support
	 * emergency
	 * baggage tracking
	 * roadside assistance
	 * package tracking
	 * @return
	 */
	public function contact(phone:String, type:String, ?area:Dynamic, ?language:Dynamic, ?options:Dynamic):Organization {
		if (_e.contactPoint == null) _e.contactPoint = [];
		var c:IContact = cast SEO.sign( { }, "ContactPoint", false);
		if (phone != null) c.telephone = phone;
		if (type != null) c.contactType = type;
		if (area != null) c.areaServed = area;
		if (language != null) c.availableLanguage = language;
		if (options != null) c.contactOption = options;
		_e.contactPoint[_e.contactPoint.length] = c;
		return this;
	}
	
}