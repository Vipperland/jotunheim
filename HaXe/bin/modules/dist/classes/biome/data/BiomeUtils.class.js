/**
 * ...
 * @author Rafael Moreira
 */
import {BiomeScan} from './BiomeScan.class.js';
export class BiomeUtils {
	/*
		Create a BiomeScanner interface if filter is a function or null
			BiomeUtils.scanner(function | scanner);
	*/
	static scanner(filter){		
		if(filter == null || !(filter instanceof BiomeScan)){
			return new BiomeScan(filter);
		} else{
			return filter;
		}
	}
}