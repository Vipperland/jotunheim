/**
 * ...
 * @author Rafael Moreira
 */

export class BiomeHeart {
	_get(event){
		event = event.toLowerCase();
		if(this.events[event] == null){
			this.events[event] = [];
		}
		return this.events[event];
	}
	execute(fns, data){
		for(var fn in fns){
			fns[fn](data);
		}
	}
	constructor(biome){
		this.events = {};
	}
	call(event, data){
		this.execute(this._get(event), data);
	}
	listen(event, handler){
		this._get(event).push(handler);
	}
	unlisten(event, handler){
		var evts = this._get(event);
		for(var e in evts){
			if(evts[e] == handler){
				evts.splice(e, 1);
				break;
			}
		}
	}
}