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
		return DataAccess.current;
	}
	
	private function error(id:Int):Bool {
		output.error(id);
		return false;
	}
	
	public function new() {
		super();
	}
	
	private function RunSQL(handler:Dynamic):Dynamic {
		return database != null ? database.execute(handler) : null;
	}
	
}