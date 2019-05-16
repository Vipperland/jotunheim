package gate.sirius.isometric.matter {
	
	import flash.display.DisplayObject;
	import gate.sirius.isometric.Biome;
	import gate.sirius.isometric.behaviours.MatterBehaviours;
	import gate.sirius.isometric.data.BiomeEntry;
	import gate.sirius.isometric.math.BiomeAllocation;
	import gate.sirius.isometric.math.BiomeBounds;
	import gate.sirius.isometric.math.BiomeFlexPoint;
	import gate.sirius.isometric.math.BiomePoint;
	
	
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public interface IBiomeMatter {
		
		/**
		 * Current Biome
		 */
		function get parent():Biome;
		function set parent(value:Biome):void;
		
		/**
		 * Unique matter name in biome
		 */
		function get name():String;
		
		/**
		 * Allocation bounds on Biome
		 */
		function get allocation():BiomeAllocation;
		
		/**
		 * Current Matter location on Biome
		 * Need call matter.post() after location change
		 */
		function get location():BiomeFlexPoint;
		
		/**
		 * Location entry
		 */
		function get tile():BiomeEntry;
		
		/**
		 * Render depth
		 */
		function get depth():uint;
		
		/**
		 * Displayable content
		 * Can be any value
		 */
		function get content():DisplayObject;
		function set content(value:DisplayObject):void;
		
		/**
		 * Internal object behaviours
		 */
		function get behaviours():MatterBehaviours;
		
		/**
		 * Depth info for sorting
		 */
		function get depthInfo():DepthInfo;
		
		/**
		 * Cancel location and bounds changes
		 */
		function revert():void;
		
		/**
		 * Mark the matter to be updated on next tick
		 */
		function post():void;
		
		/**
		 * Activation Update queue
		 */
		function hasPendingActivation():Boolean;
		
		/**
		 * Cancel any pending update call
		 */
		function cancelPendingActivation():void;
		
		/**
		 *
		 * @param nearLocation
		 *   Search on a Biome ocuppation based on current matter location, even if not updated
		 * @return
		 */
		function getCollision(nearLocation:BiomePoint = null, optbounds:BiomeBounds = null, filter:Function = null):Vector.<BiomeMatter>
		
		/**
		 *
		 * @param	nextLocation
		 * @return
		 */
		function isOutOfBounds(nearLocation:BiomePoint, optbounds:BiomeBounds = null):Boolean;
		
		/**
		 *
		 */
		function recyclerDump():void;
		
		/**
		 *
		 * @param	...args
		 */
		function recyclerCollect(... args:Array):void;
		
		/**
		 * Destroy the instance and free memory
		 * @param	recycle		If true, the matter will be sent to recycler for post usage
		 */
		function dispose(recycle:Boolean):void;
		
		/**
		 *
		 * @param	options
		 * @param	mirror
		 * @return
		 */
		function clone(options:uint = 0, mirror:Boolean = false):BiomeMatter;
		
		/**
		 * Blank method for implementation
		 */
		function activate(phase:uint, from:BiomeMatter, data:*):void;
		
		/**
		 * Remove matter from current Biome
		 */
		function removeFromBiome():void;
		
		/**
		 * Request update to all conected neighbors
		 * @param	hash
		 * @param	phase
		 */
		function activateNeighbors(hash:uint, phase:uint, filter:Function, level:uint = 1, data:* = null, delay:uint = 0, bounds:BiomeBounds = null):void;
		
		function toString():String;
	
	}

}