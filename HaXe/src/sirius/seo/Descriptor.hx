package sirius.seo;
import sirius.seo.IAddress;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Descriptor extends SEO {
	
	private var _d:IDescriptor;
	
	public function new(q:String) {
		super(q);
		_d = cast data;
	}
	
	public function name(?q:String):String {
		if (q != null) _d.name = q;
		return _d.name;
	}
	
	public function url(?q:String):String {
		if (q != null) _d.url = q;
		return _d.url;
	}
	
	public function logo(?q:String):String {
		if (q != null) _d.logo = q;
		return _d.logo;
	}
	
	public function email(?v:String):String {
		if (v != null) _d.email = v;
		return _d.email;
	}
	
	public function address(?country:String, ?state:String, ?city:String, ?street:String, ?code:String):IAddress {
		if (_d.address == null) _d.address = SEO.sign({},"PostalAddress",false);
		if (country != null) _d.address.addressCountry = country;
		if (state != null) _d.address.addressRegion = state;
		if (city != null) _d.address.addressLocality = city;
		if (street != null) _d.address.streetAddress = street;
		if (code != null) _d.address.postalCode = code;
		return _d.address;
	}
	
	public function social(?q:Array<String>):Array<String> {
		if (q != null) {
			if(_d.sameAs == null) _d.sameAs = [];
			Dice.Values(q, function(v:String) {
				if (_d.sameAs.indexOf(v) == -1) {
					_d.sameAs[_d.sameAs.length] = v;
				}
			});
		}
		return _d.sameAs;
	}
	
}