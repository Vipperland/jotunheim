package jotun.gateway;
import jotun.gateway.database.DataAccess;
import jotun.gateway.domain.DomainAccessCore;
import jotun.gateway.domain.InputCore;
import jotun.gateway.domain.OutputCore;
import jotun.gateway.errors.ErrorCodes;
import jotun.tools.Utils;
import jotun.utils.SingletonLock;
import php.ErrorException;
import php.Syntax;

/**
 * ...
 * @author Rafael Moreira
 */
class GatewayCore {

	static private var _ME:GatewayCore;
	static public function getInstance():GatewayCore {
		return _ME;
	}
	
	public function new() {
		if (_ME == null){
			_ME = this;
		}else{
			throw new  ErrorException("Gateway is a Singleton");
		}
	}
	
	/**
	 * Classes will be available in this order: Gateway > Output > DataAccess > Input > Domain. 
	 * @param	TGateway
	 * @param	TOutput
	 * @param	TDataAccess
	 * @param	TInput
	 * @param	TDomain
	 * @param	maintenance
	 */
	static public function init(TGateway:Dynamic, TOutput:Dynamic, TDataAccess:Dynamic, TInput:Dynamic, TDomain:Dynamic, maintenance:Bool):Void {
		
		Syntax.construct(TGateway);
		
		Jotun.header.access();
		
		// Init OUTPUT interface
		Syntax.construct(TOutput);
		
		// If functional mode, init domain services
		if (!maintenance){
			
			if (Utils.boolean(Jotun.domain.params.log)){
				OutputCore.getInstance().enableLog();
			}
			
			Syntax.construct(TDataAccess);
			
			if (Utils.boolean(Jotun.domain.params.dblog)){
				DataAccess.getInstance().enableLog();
			}
			
			// Init INPUT interface
			Syntax.construct(TInput);
			
			Syntax.construct(TDomain);
			
		}else{
			
			OutputCore.getInstance().error(ErrorCodes.MAINTENANCE_MODE);
			
		}
		
		// Output all parsed data frm zone services
		OutputCore.getInstance().flush();
		
	}
	
}