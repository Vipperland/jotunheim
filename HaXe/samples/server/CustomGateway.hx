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
		var hasPulsar:Bool = Jotun.domain.paramAsBool('pulsar');
		GatewayCore.init(
			CustomGateway, 
			hasPulsar ? PulsarOutput : JsonOutput,
			CustomDataAccess, 
			BasicSessionInput,
			CustomDomain, 
			GatewayOptions.ALL
		);
	}
	
	override public function flush():Void {
		_output.mode(_input.paramAsBool('encoded'), 40);
		super.flush();
	}
	
}