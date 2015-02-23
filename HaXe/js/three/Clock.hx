package js.three;

import js.html.*;

/**
 * Object for keeping track of time.
 *
 * @see <a href="https://github.com/mrdoob/three.js/blob/master/src/core/Clock.js">src/core/Clock.js</a>
 */
@:native("THREE.Clock")
extern class Clock
{
	/**
	 * @param autoStart Automatically start the clock.
	 */
	function new(?autoStart:Bool) : Void;

	/**
	 * If set, starts the clock automatically when the first update is called.
	 */
	var autoStart : Bool;

	/**
	 * When the clock is running, It holds the starttime of the clock.
	 * This counted from the number of milliseconds elapsed since 1 January 1970 00:00:00 UTC.
	 */
	var startTime : Float;

	/**
	 * When the clock is running, It holds the previous time from a update.
	 * This counted from the number of milliseconds elapsed since 1 January 1970 00:00:00 UTC.
	 */
	var oldTime : Float;

	/**
	 * When the clock is running, It holds the time elapsed between the start of the clock to the previous update.
	 * This parameter is in seconds of three decimal places.
	 */
	var elapsedTime : Float;

	/**
	 * This property keeps track whether the clock is running or not.
	 */
	var running : Bool;

	/**
	 * Starts clock.
	 */
	function start() : Void;

	/**
	 * Stops clock.
	 */
	function stop() : Void;

	/**
	 * Get the seconds passed since the clock started.
	 */
	function getElapsedTime() : Float;

	/**
	 * Get the seconds passed since the last call to this method.
	 */
	function getDelta() : Float;
}