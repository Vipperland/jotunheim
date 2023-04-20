package ;
import jotun.gateway.database.objects.ZoneCoreObject;
import jotun.gateway.domain.Domain;

/**
 * ...
 * @author Rafael Moreira
 */
class CustomZoneCoreObject extends ZoneCoreObject {
	
	private var _domain(get, null):CustomDomain;
	private function get__domain():CustomDomain {
		return Domain.getInstance();
	}
	
	
}