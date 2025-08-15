package jotun.net;
import jotun.net.DataSource;

/**
 * ...
 * @author Rafael Moreira
 */
class MultiDataSource extends DataSource {
	
	public function new(data:Dynamic) {
		if(!Std.isOfType(data, Array)){
			data = [data];
		}
		super(data);
	}
	
}