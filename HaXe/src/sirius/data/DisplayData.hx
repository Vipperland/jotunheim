package sirius.data;
import sirius.data.IDataSet;
import sirius.data.DataSet;
import sirius.dom.IDisplay;
import sirius.events.Dispatcher;
import sirius.events.IDispatcher;

/**
 * ...
 * @author Rafael Moreira
 */
class DisplayData extends DataSet implements ArrayAccess<Dynamic> {
	
	public var __data__:IDataSet;
	
	public var __id__:String;
	
	public var __events__:IDispatcher;
	
	public function new(id:String, q:IDisplay) {
		__data__ = new DataSet();
		__id__ = id;
		__events__ = new Dispatcher(q);
		super();
	}
	
	override public function clear():DataSet {
		var d:IDataSet = __data__;
		super.clear();
		__data__ = d;
		return this;
	}
	
	public function dispose():Void {
		__events__.dispose();
		__data__.clear();
		__events__ = null;
		__data__ = null;
	}
	
}