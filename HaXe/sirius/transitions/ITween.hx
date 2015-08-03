package transitions;
import js.html.svg.Number;

/**
 * @author Rafael Moreira
 */

interface ITween {
	
	public var data:Dynamic;
	public var timeline:Dynamic;
	public var vars:Dynamic;
	
	public function delay(?q:Number):ITween;
	public function duration(?q:Number):ITween;
	public function endTime(?q:Number):ITween;
	public function eventCallback(type:String, ?handler:Dynamic, ?params:Array<Dynamic>):Dynamic;
	public function invalidate():ITween;
	public function isActive():ITween;
	public function kill():ITween;
	public function pause(?q:Number):ITween;
	public function paused(?q:Bool):ITween;
	public function play(?q:Number,?sup:Bool=true):ITween;
	public function progress(?q:Number):ITween;
	public function repeat(?q:Int):ITween;
	public function repeatDelay(?q:Number):ITween;
	public function restart(?q:Bool,?sup:Bool=true):ITween;
	public function resume(?q:Int,?sup:Bool=true):ITween;
	public function reverse(?q:Number,?sup:Bool=true):ITween;
	public function reversed(?q:Bool):ITween;
	public function seek(?q:Number,?sup:Bool=true):ITween;
	public function startTime(?q:Number):ITween;
	public function time(?q:Number):ITween;
	public function timeScale(?q:Number):ITween;
	public function totalDuration(?q:Number,?sup:Bool=true):ITween;
	public function totalProgress(?q:Number,?sup:Bool=true):ITween;
	public function totalTime(?q:Number,?sup:Bool=true):ITween;
	public function updateTo(?vars:Dynamic,?reset:Bool=false):ITween;
	public function yoyo(?q:Bool=false):ITween;
	
}