package gate.sirius.isometric.recycler {
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public interface IRecyclable {
		
		function onDump():void;
		function onCollect():void;
	
	}

}