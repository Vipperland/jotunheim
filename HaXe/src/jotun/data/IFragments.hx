package jotun.data;
/**
* ...
@author Rafael Moreira
*/
interface IFragments {
	
	public var value : String;
	
	public var pieces : Array<String>;
	
	public var first : String;
	
	public var last : String;

	public function split (separator:String) : IFragments;

	public function glue (value:String) : IFragments;

	public function addPiece (value:String, ?at:Int=-1) : IFragments;

	public function get (i:Int, ?e:Int) : String;
	
	public function set(i:Int, val:String) : IFragments;
	
	public function find (value:String) : Bool;

	public function clear () : IFragments;
}
