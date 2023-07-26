/**
 * ...
 * @author Rafael Moreira
 */
export class BiomeTile {
	#_x;
	#_y;
	#_objects;
	constructor(x,y){
		this.#_x = x;
		this.#_y = y;
		this.#_objects = {};
	}
	get x(){
		return this.#_x;
	}
	get y(){
		return this.#_y;
	}
	objects(fn, max){
		for(var object in this.#_objects){
			fn(this.#_objects[object]);
			if(max != null && --max <= 0){
				break;
			}
		}
	}
	load(object){
		this.#_objects[object.id] = object;
	}
	unload(object){
		delete this.#_objects[object.id];
	}
}