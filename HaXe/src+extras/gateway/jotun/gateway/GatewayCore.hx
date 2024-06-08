package jotun.gateway;
import jotun.gateway.database.DataAccess;
import jotun.gateway.domain.InputCore;
import jotun.gateway.domain.OutputCore;
import jotun.gateway.domain.zones.DomainZoneCore;
import jotun.gateway.errors.ErrorCodes;
import jotun.gateway.flags.GatewayOptions;
import jotun.logical.Flag;
import php.ErrorException;
import php.Syntax;

/**
 * ...
 * @author Rafael Moreira
 */
class GatewayCore {

	static private var _instance:GatewayCore;
	static public function getInstance():GatewayCore {
		return _instance;
	}
	
	/**
	 * Classes will be available in this order: Gateway > Output > DataAccess > Input > Domain. 
	 * @param	TGateway
	 * @param	TOutput
	 * @param	TDataAccess
	 * @param	TInput
	 * @param	TDomain			The param services will carry along domain zones (?services=hello/world)
	 * @param	maintenance
	 * @param	onInit
	 */
	static public function init(TGateway:Class<GatewayCore>, TOutput:Class<OutputCore>, TDataAccess:Class<DataAccess>, TInput:Class<InputCore>, TDomain:Class<DomainZoneCore>, options:UInt):Void {
		
		var gateway:GatewayCore = cast Syntax.construct(TGateway);
		
		Jotun.header.access();
		
		// Init OUTPUT interface
		gateway._output = Syntax.construct(TOutput);
		
		// If functional mode, init domain services
		if (!Flag.FTest(options, GatewayOptions.MAINTENANCE)){
			
			// Init INPUT interface
			gateway._input = Syntax.construct(TInput);
			gateway._output.setOptions(options);
			gateway._database = Syntax.construct(TDataAccess);
			gateway._database.setOptions(options);
			gateway._domain = Syntax.construct(TDomain);
			
		}else{
			
			gateway._output.error(ErrorCodes.MAINTENANCE_MODE);
			
		}
		
		if(Flag.FTest(options, GatewayOptions.ENCODED_OUTPUT)){
			gateway._output.mode(true, 64);
		}
		
		// Output all parsed data frm zone services
		gateway.flush();
		
	}
	
	private var _database:DataAccess;
	private var _domain:DomainZoneCore;
	private var _input:InputCore;
	private var _output:OutputCore;
	
	public function new() {
		if (_instance == null){
			_instance = this;
		}else{
			throw new  ErrorException("Gateway is a Singleton");
		}
	}
	
	public function flush():Void {
		_output.flush();
	}
	
}