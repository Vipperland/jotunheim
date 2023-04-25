package jotun.gateway.domain.zones.session;
import jotun.gateway.domain.BasicSessionInput;

/**
 * ...
 * @author 
 */
class SessionVerifyZone extends DomainZoneCore {
	
	public function new() {
		super();
		setEndZone();
	}
	
	private function _fetchData(data:Array<String>):Void {
		if (data != null && data.length > 0){
			var param:String = data.shift();
			switch (param){
				case '+refresh' : {
					cast (input, BasicSessionInput).session.refresh();
				}
				case '+user' : {
					cast (input, BasicSessionInput).session.exposeCarrier();
				}
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