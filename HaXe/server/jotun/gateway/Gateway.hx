package jotun.gateway;
import jotun.gateway.domain.Domain;
import jotun.gateway.domain.Input;
import jotun.gateway.domain.Output;
import jotun.gateway.errors.ErrorCodes;
import jotun.utils.SingletonLock;
import php.ErrorException;
import php.Syntax;

/**
 * ...
 * @author Rafael Moreira
 */
class Gateway {

	static private var _ME:Gateway;
	static public function getInstance():Gateway {
		return _ME;
	}
	
	public function new() {
		if (_ME == null){
			_ME = this;
		}else{
			throw new  ErrorException("Gateway is a Singleton");
		}
	}
	
	static public function init(TGateway:Dynamic, TDomain:Dynamic, TDataAccess:Dynamic, log:Bool, logdb:Bool, maintenance:Bool):Void {
		
		Syntax.construct(TGateway);
		
		Jotun.header.access();
		
		// Enable Database IO log
		if (logdb){
			Jotun.gate.enableLog();
		}
		
		// Enable ZoneService IO log
		if (log){
			Output.ME.enableLog();
		}
		
		Syntax.construct(TDataAccess);
		
		// Init INPUT interface
		Input.ME;
		
		// Init OUTPUT interface
		Output.ME;
		
		// If functional mode, init domain services
		if (!maintenance){
			Syntax.construct(TDomain);
		}else{
			Output.ME.error(ErrorCodes.MAINTENANCE_MODE);
		}
		
		// 
		Output.ME.flush();
		
	}
	
}