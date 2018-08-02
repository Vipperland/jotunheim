package sirius.gaming.actions;
import sirius.Sirius;
import sirius.gaming.actions.IEventContext;
import sirius.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
class EventController implements Dynamic {
	
	public var events:Dynamic;
	
	public static function CONTEXT(data:Dynamic):IEventContext {
		return cast {
			log:[],
			ident:0,
			ticks:0,
			origin:data,
		};
	}
	
	public function new(data:Dynamic) {
		events = cast Sirius.resources.getObj("core.data.Events");
		Dice.All(events, function(p:String, v:Dynamic){
			Events.patch(this); 
		});
	}

	public function call(name:String, ?data:Dynamic):Void {
		if (Reflect.hasField(events, name)){
			Reflect.field(events, name).run(CONTEXT(data));
		}else{
		}
	}
	
}