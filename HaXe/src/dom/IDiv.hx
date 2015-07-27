package sirius.dom;
import sirius.dom.IDisplay;

/**
 * @author Rafael Moreira
 */

interface IDiv extends IDisplay {
  
	public function alignCenter():Void;
	
	public function alignLeft():Void;
	
	public function alignRight():Void;
	
	public function background(?value:String, ?repeat:String, ?position:String, ?attachment:String):String;
	
}