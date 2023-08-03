/**
 * ...
 * @author Rafael Moreira
 */
let Scanner = biome.cores.Scanner;
export default class AdvScanner extends Scanner {
	constructor(filter){
		super(filter);
	}
	/*
		Calls a fx(value), if filter function does not exists or return result is true, the object will added to scanner result
			scan.add(value);
	*/
	add(value){
		if(value != null && this.test(value)){
			this.result.push(value);
		}
	}
}