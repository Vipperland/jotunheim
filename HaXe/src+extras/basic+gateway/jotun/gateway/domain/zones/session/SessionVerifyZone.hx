package jotun.gateway.domain.zones.session;
import jotun.gateway.domain.BasicSessionInput;
import jotun.gateway.errors.ErrorCodes;
import jotun.utils.Dice;

/**
 * ...
 * @author 
 */
class SessionVerifyZone extends DomainZoneCore {
	
	public function new() {
		super();
		setEndZone();
		setDatabaseRequired();
	}
	
	private function _fetchData(data:Array<String>):Void {
		if (data != null && data.length > 0){
			var param:String = data.shift();
			if (param.substr(0, 1) == '+'){
				var actions:Array<String> = param.substring(1, param.length).split(',');
				Dice.Values(actions, function(v:String):Void {
					switch (v){
						case 'refresh' : {
							cast (input, BasicSessionInput).session.refresh();
						}
						case 'user' : {
							cast (input, BasicSessionInput).session.exposeCarrier();
						}
						default : {
							output.setStatus(ErrorCodes.SERVICE_NOT_ACCEPTABLE);
						}
					}
				});
			}
			_fetchData(data);
		}
	}
	
	override function _execute(data:Array<String>):Void {
		if (cast (input, BasicSessionInput).session != null){
			cast (input, BasicSessionInput).session.exposeCarrier(true);
			_fetchData(data);
		}else{
			error(cast (input, BasicSessionInput).getTokenSatus());
		}
	}
	
}