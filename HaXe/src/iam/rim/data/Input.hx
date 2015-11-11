package iam.rim.data;
import sirius.data.Fragments;
import sirius.data.IFragments;
import sirius.Sirius;

/**
 * ...
 * @author Rafael Moreira
 */
class Input{
	
	static public var services:IFragments;
	
	static public var head(get, null):String;
	static private function get_head():String {
		if (services == null) services = new Fragments(Sirius.domain.params.service, "/");
		return services.first;
	}
	
}