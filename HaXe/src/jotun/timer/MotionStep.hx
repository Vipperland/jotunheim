package jotun.timer;
import jotun.dom.Displayable;

/**
 * ...
 * @author Rafael Moreira
 */
typedef MotionStep = {
	var ?css:String;
	var ?delay:Float;
	var ?callback:Displayable->Void;
}