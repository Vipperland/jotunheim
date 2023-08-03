/**
 * ...
 * @author Rafael Moreira
 */
var CLASS_ID = 0;
export default class CoreBehaviour {
	static #_CLASS_ID = 'bhvr:' + (CLASS_ID++);
	get id(){
		return CoreBehaviour.#_CLASS_ID;
	}
	constructor(){
	}
	load(object){
		object.data[this.id] = {};
	}
	unload(object){
		delete object.data[this.id];
	}
	data(object){
		return object.data[this.id];
	}
	update(object){ }
}