package jotun.gateway.domain;
import jotun.gateway.database.DataAccess;
import jotun.gateway.objects.OutputCoreCarrier;

/**
 * ...
 * @author 
 */
class DomainServicesCore extends OutputCoreCarrier {

	public var database(get, null):DataAccess;
	private function get_database():DataAccess {
		return DataAccess.getInstance();
	}
	
	private function error(id:Int):Bool {
		output.error(id);
		return false;
	}
	
	public function new() {
		super();
	}
	
}