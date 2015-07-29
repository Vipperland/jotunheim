package sirius.utils;
import js.html.Element;
import sirius.dom.IDisplay;

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

interface ITable {
	
	/**
	 * List of Sirius Display object
	 */
	public var content:Array<IDisplay>;
	
	/**
	 * List of DOM elements
	 */
	public var elements:Array<Element>;
	
	/**
	 * Run a method on each element with Dice.Values(h,c)
	 * @param	h
	 * @param	c
	 * @return
	 */
	public function flush(handler:Dynamic, ?complete:Dynamic):ITable;
	
	/**
	 * Get the first element
	 * @return
	 */
	public function first():IDisplay;
	
	/**
	 * Get the last element
	 * @return
	 */
	public function last():IDisplay;
	
	/**
	 * Get an element by index
	 * @param	i
	 * @return
	 */
	public function obj(i:Int):IDisplay;
	
	/**
	 * Add a selector to each element
	 * @param	styles
	 * @return
	 */
	public function css(styles:String):ITable;
	
	/**
	 * Run a method to each element Dice.Values(h)
	 * @param	handler
	 * @return
	 */
	public function each(handler:Dynamic):ITable;
	
	/**
	 * Current content count
	 * @return
	 */
	public function length ():Int;
	
	/**
	 * Call a method in each content element
	 * @param	method
	 * @param	args
	 * @return
	 */
	public function call(method:String, ?args:Array<Dynamic>):ITable;
	
	/**
	 * Add event to all table elements
	 * @param	name
	 * @param	handler
	 * @param	capture
	 * @return
	 */
	public function onEvent(name:String, handler:Dynamic, ?capture:Bool):ITable;
	
	/**
	 * Join one or more Tables in one or clone current Table
	 * @param	tables
	 * @return
	 */
	public function merge(?tables:Array<Table>):Table;
	
}