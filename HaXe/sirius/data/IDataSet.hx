package data;

/**
 * @author Rafael Moreira
 */

interface IDataSet {
	public function get(p:String):Dynamic;
	public function set(p:String, v:Dynamic):IDataSet;
	public function exists(p:String):Bool;
}