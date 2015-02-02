package gate.sirius.isometric.layout {
	import gate.sirius.isometric.data.BiomeEntry;
	import gate.sirius.isometric.matter.BiomeMatter;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public interface IBiomeLayout {
		
		function sort(objects:Vector.<BiomeMatter>):Vector.<BiomeMatter>;
		
		function clear():void;
		
	}
	
}