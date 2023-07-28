/**
 * ...
 * @author Rafael Moreira
 */
import {BiomeUtils} from './BiomeUtils.class.js';
export class BiomeScan {
	data;
	result;
	#_filter;
	#_active;
	#_index;
	#_current;
	constructor(filter){
		this.result = [];
		this.#_filter = filter;
		this.#_active = true;
		this.#_index = 0;
	}
	/*
		If scanner is active
			scan.active;
	*/
	get active(){
		return this.#_active;
	}
	/*
		Calls a fx(value), if filter function does not exists or return result is true, the object will added to scanner result
			scan.add(value);
	*/
	add(value){
		if(this.test(value)){
			this.result.push(value);
		}
	}
	/*
		Check if a condition is true for a value
			scan.test(any);
	*/
	test(value){
		return this.#_filter == null || this.#_filter(value, this) == true;
	}
	/*
		Ignores the filter fuction and add the object into scanner result if not null
			scan.put(value);
	*/
	put(value){
		if(value != null){
			this.add(value);
		}
	}
	/*
		Call filter function for each argument
			scan.call(...values);
	*/
	call(...values){
		if(this.#_filter != null){
			for (let i = 0; i < values.length; i++) {
				if(!this.test(values[i])){
					break;
				}
			}
		}
	}
	/*
		Stop scanner process
			scan.stop();
	*/
	stop(){
		this.#_active = false;
	}
	/*
		Scan each value in result and call fx(value);
			scan.each(function(o){ ... });
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
	remove(...values){
		for (let i = 0; i < values.length; i++) {
			let iof = this.result.indexOf(value);
			if(iof != -1){
				this.result.splice(iof, 1);
			}
		}
	}
	/* 
		Cursor for iteraction
			scan.next;
	*/
	get next(){
		if(this.#_index < this.result.length){
			this.#_current = this.result[this.#_index++];
			return true;
		}else {
			return false;
		}
	}
	/* 
		Current value in the cursor
			scan.current;
	*/
	get current(){
		return this.#_current;
	}
}