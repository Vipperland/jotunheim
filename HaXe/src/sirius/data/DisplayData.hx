package sirius.data;
import sirius.data.IDataSet;
import sirius.data.DataSet;

/**
 * ...
 * @author Rafael Moreira
 */
class DisplayData extends DataSet implements ArrayAccess<Dynamic> {
	
	public var __data__:IDataSet;
	
	public var __id__:String;
	
	public function new(id:String) {
		__data__ = new DataSet();
		__id__ = id;
		super();
	}
	
	override public function clear():DataSet {
		var d:IDataSet = __data__;
		super.clear();
		__data__ = d;
		return this;
	}
	
}