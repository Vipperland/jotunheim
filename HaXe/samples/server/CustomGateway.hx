package ;
import jotun.gateway.Gateway;
import jotun.gateway.domain.Domain;

/**
 * ...
 * @author Rafael Moreira
 */
class CustomGateway extends Gateway {

	static function main() {
		Gateway.init(CustomGateway, CustomDomain, CustomDataAccess, true, true, false);
	}
	
}