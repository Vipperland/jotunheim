/**
 * ...
 * @author Rafael Moreira
 */
import {BiomeScan} from './BiomeScan.class.js';
export class BiomeUtils {
	static concat(){
		var result = [];
		var args = Array.from(arguments);
		for(var i in args){
			result = result.concat(args[i]);
		}
		return result;
	}
	static scanner(from){		
		if(from == null || !(from instanceof BiomeScan)){
			from = new BiomeScan(from);
		}
		return from;
	}
}