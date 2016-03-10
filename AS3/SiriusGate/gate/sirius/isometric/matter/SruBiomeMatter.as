package gate.sirius.isometric.matter {
	import gate.sirius.isometric.math.BiomeBounds;
	import gate.sirius.isometric.math.BiomePoint;
	import gate.sirius.serializer.hosts.IStartable;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class SruBiomeMatter extends BiomeMatter implements IStartable {
		
		public function SruBiomeMatter() {
			super(null);
		}
		
		public function setName(name:String):void {
			_name = name || "SruMatter" + (MATTER_COUNT++);
		}
		
		public function setBounds(... values:Array):void {
			_allocation.bounds.push(BiomeBounds.STRING(values.join(";")));
		}
		
		public function setLocation(x:int, y:int, z:int):void {
			_location.moveToLocation(x, y, z);
		}
		
		/* INTERFACE gate.sirius.serializer.hosts.IStartable */
		
		public function onParseOpen():void {
		
		}
		
		public function onParseClose():void {
		
		}
	
	}

}