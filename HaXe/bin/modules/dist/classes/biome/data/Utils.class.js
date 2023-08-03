/**
 * ...
 * @author Rafael Moreira
 */
export default class Utils {
	/*
		Create a BiomeScanner interface if filter is a function or null
			BiomeUtils.scanner(function | scanner);
	*/
	static scanner(filter){
		if(filter instanceof Function){
			return new biome.cores.AdvScanner(filter);
		}
		if(filter instanceof biome.cores.Scanner){
			return filter;
		}
		if(filter == null){
			return new biome.cores.Scanner(filter);
		}
		if(filter.deep == true){
			return new biome.cores.AdvScanner(filter.filter);
		}
		if(filter.deep == false){
			return new biome.cores.Scanner(filter.filter);
		}
	}
}