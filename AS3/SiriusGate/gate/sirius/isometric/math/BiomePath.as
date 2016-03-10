package gate.sirius.isometric.math {
	
	
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public class BiomePath {
		
		private var _location:BiomePoint;
		
		public function BiomePath(location:BiomePoint) {
			_location = location;
		}
		
		
		public function get location():BiomePoint {
			return _location;
		}
	
	}

}