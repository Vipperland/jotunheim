/**
 * ...
 * @author Rafael Moreira
 */
let StaticObject = biome.objects.StaticObject;
export default class LiveObject extends StaticObject {
	#_proxy;
	#_frame;
	#_enabled;
	#_behavious;
	#_render(){
		if(this.#_enabled && this.#_frame.active){
			for (let i = 0; i < this.#_behavious.length; i++) {
				this.#_behavious[i].update(this);
			}
		}
	}
	set enabled(value){
		this.#_enabled = value == true;
	}
	get enabled(){
		return this.#_enabled;
	}
	constructor(name, x, y, width, height, options, data){
		super(name, x, y, width, height, options, data);
		this.#_enabled = true;
		this.#_behavious = [];
	}
	load(){
		if(super.load()){
			this.#_proxy = this.#_render.bind(this);
			this.#_frame = this.biome.core.frameChannel;
			this.biome.core.add(this.#_proxy);
		}
	}
	unload(){
		if(super.unload()){
			this.biome.core.remove(this.#_proxy);
			this.#_proxy = null;
		}
	}
	add(behaviour){
		if(behaviour instanceof biome.behaviours.CoreBehaviour && !this.#_behavious.includes(behaviour)){
			this.#_behavious.push(behaviour);
			behaviour.load(this);
		}
	}
	remove(behaviour){
		let iof = this.#_behavious.includes(behaviour);
		if(iof != -1){
			this.#_behavious.splice(iof, 1);
			behaviour.unload(this);
		}
	}
}