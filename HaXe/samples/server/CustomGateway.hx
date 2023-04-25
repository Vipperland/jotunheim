package ;
import jotun.gateway.Gateway;
import jotun.gateway.domain.BasicSessionInput;
import jotun.gateway.domain.Domain;
import jotun.gateway.domain.Output;
import jotun.gateway.domain.OutputPulsar;

/**
 * ...
 * @author Rafael Moreira
 */
class CustomGateway extends Gateway {

	static function main() {
		Gateway.init(
			CustomGateway, 
			CustomDomain, 
			CustomDataAccess, 
			BasicSessionInput,
			OutputPulsar,
			false
		);
	}
	
}