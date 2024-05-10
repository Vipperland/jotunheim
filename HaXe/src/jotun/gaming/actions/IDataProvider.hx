package jotun.gaming.actions;

/**
 * @author Rafael Moreira
 */
interface IDataProvider {
	public function hasVar(name:String):Bool;
	public function getVar(name:String):Dynamic;
	public function getStr(name:String):String;
	public function getInt(name:String):Int;
	public function getFloat(name:String):Float;
	public function getSwitch(name:String):Bool;
	public function setVar(name:String, value:Dynamic):Void;
	public function setStr(name:String, value:Dynamic):Void;
	public function setSwitch(name:String, value:Bool):Void;
}