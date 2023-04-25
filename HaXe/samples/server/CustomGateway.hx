package ;
import jotun.gateway.GatewayCore;
import jotun.gateway.domain.BasicSessionInput;
import jotun.gateway.domain.DomainAccessCore;
import jotun.gateway.domain.OutputCore;
import jotun.gateway.domain.PulsarOutput;

/**
 * ...
 * @author Rafael Moreira
 */
class CustomGateway extends GatewayCore {

	static function main() {
		GatewayCore.init(
			CustomGateway, 
			PulsarOutput,
			CustomDataAccess, 
			BasicSessionInput,
			CustomDomain, 
			false
		);
	}
	
}