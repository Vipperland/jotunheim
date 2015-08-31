package sirius.data;
import sirius.data.IDataSet;
import sirius.data.DataSet;

/**
 * ...
 * @author Rafael Moreira
 */
class DisplayData extends DataSet {
	
	public var __data__:IDataSet;
	
	public function new() {
		__data__ = new DataSet();
		super();
	}
	
	override public function clear():DataSet {
		var d:IDataSet = __data__;
		super.clear();
		__data__ = d;
		return this;
	}
	
}