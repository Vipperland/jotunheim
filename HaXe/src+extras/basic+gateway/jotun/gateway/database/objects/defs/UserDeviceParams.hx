package jotun.gateway.database.objects.defs;
import jotun.gateway.domain.InputCore;
import jotun.tools.Utils;
import jotun.utils.Omnitools;
import jotun.utils.Validator;

/**
 * ...
 * @author Rafael Moreira
 */
class UserDeviceParams {

	public var device:String;
	
	public function new(data:InputCore) {
		device = data.string("device");
	}
	
}