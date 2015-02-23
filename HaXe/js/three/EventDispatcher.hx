package js.three;

import js.html.*;

/**
 * JavaScript events for custom objects
 *
 * # Example
 *     var Car = function() {
 *
 *         EventDispatcher.call(this);
 *         this.start = function() {
 *
 *             this.dispatchEvent( { type: 'start', message: 'vroom vroom!' } );
 *
 *         };
 *
 *     };
 *
 *     var car = new Car();
 *     car.addEventListener('start', function(event) {
 *
 *         alert(event.message);
 *
 *     } );
 *     car.start();
 *
 * @source src/core/EventDispatcher.js
 */
@:native("THREE.EventDispatcher")
extern class EventDispatcher
{
	/**
	 * Creates eventDispatcher object. It needs to be call with '.call' to add the functionality to an object.
	 */
	function new() : Void;

	/**
	 * Adds a listener to an event type.
	 * @param type The type of the listener that gets removed.
	 * @param listener The listener function that gets removed.
	 */
	function addEventListener(type:String, listener:Dynamic->Void) : Void;

	/**
	 * Adds a listener to an event type.
	 * @param type The type of the listener that gets removed.
	 * @param listener The listener function that gets removed.
	 */
	function hasEventListener(type:String, listener:Dynamic->Void) : Void;

	/**
	 * Removes a listener from an event type.
	 * @param type The type of the listener that gets removed.
	 * @param listener The listener function that gets removed.
	 */
	function removeEventListener(type:String, listener:Dynamic->Void) : Void;

	/**
	 * Fire an event type.
	 * @param type The type of event that gets fired.
	 */
	function dispatchEvent(event: { type: String, target:Dynamic }) : Void;
}