/**
 * ...
 * @author Rafael Moreira
 */
import {BiomeUtils} from './BiomeUtils.class.js';
export class BiomeScan {
	data;
	max;
	result;
	#_length;
	#_filter;
	#_active;
	constructor(filter, max){
		this.result = [];
		this.#_filter = filter;
		this.#_length = 0;
		this.#_active = true;
		this.max = max || 0;
	}
	/*
		If scanner is active
	*/
	get active(){
		return this.#_active;
	}
	/*
		Result count
	*/
	get length(){
		return this.#_length;
	}
	/*
		Calls a fx(value), if filter function does not exists or return result is true, the object will added to scanner result
	*/
	add(value){
		if(this.test(value)){
			this.result[this.#_length] = value;
			++this.#_length;
			if(this.#_length == this.max){
				this.stop();
			}
		}
	}
	/*
		Check if a condition is true for a value
	*/
	test(value){
		return this.#_filter == null || this.#_filter(value, this) == true;
	}
	/*
		Ignores the filter fuction and add the object into scanner result if not null
	*/
	put(value){
		if(value != null){
			this.add(value);
		}
	}
	/*
		Call filter function for each argument
	*/
	call(...args){
		if(this.#_filter != null){
			for (let i = 0; i < args.length; i++) {
				if(!this.test(value)){
					break;
				}
			}
		}
	}
	/*
		Stop scanner process
	*/
	stop(){
		this.#_active = false;
	}
	/*
		Scan each value in result and call fx(value);
	*/
	each(filter){
		filter = BiomeUtils.scanner(filter);
		for (let i = 0; i < this.result.length; i++) {
			filter.add(this.result[i]);
			if(!filter.active){
				break;
			}
		}
		return filter;
	}
	get(index){
		return this.result[index];
	}
}