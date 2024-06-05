package ;
import jotun.Jotun;
import jotun.gateway.GatewayCore;
import jotun.gateway.domain.BasicSessionInput;
import jotun.gateway.domain.DomainAccessCore;
import jotun.gateway.domain.JsonOutput;
import jotun.gateway.domain.OutputCore;
import jotun.gateway.domain.PulsarOutput;
import jotun.gateway.flags.GatewayOptions;

/**
 * ...
 * @author Rafael Moreira
 */
class CustomGateway extends GatewayCore {

	static function main() {
		var enablePulsar:Bool = Jotun.domain.paramAsBool('pulsar');
		var encodedOutput:Bool = Jotun.domain.paramAsBool('encoded');
		GatewayCore.init(
			CustomGateway, 
			enablePulsar ? PulsarOutput : JsonOutput,
			CustomDataAccess, 
			BasicSessionInput,
			CustomDomain, 
			encodedOutput ? GatewayOptions.ALL_ENCODED : GatewayOptions.ALL
		);
	}
	
}