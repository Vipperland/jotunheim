/**
 * ...
 * @author Rafael Moreira
 */
import {BiomeObject} from './BiomeObject.class.js';
export class BiomeLiveObject extends BiomeObject {
	#_proxy;
	#_frame;
	#_enabled;
	#_render(time){
		if(this.#_enabled && this.#_frame.active){
			this.render(time);
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
	}
	render(){
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
}