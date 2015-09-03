package sirius.data;

/**
 * @author Rafael Moreira
 */

interface IDataSet {
	
	public function get (p:String) : Dynamic;

	public function set (p:String, v:Dynamic) : IDataSet;

	public function exists (p:String) : Bool;

	public function clear () : DataSet;

	public function find (v:String) : Array<String>;

	public function index () : Array<String>;

	public function values () : Array<String>;
	
}