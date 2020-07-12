package jotun.thread;

/**
 * ...
 * @author Rafael Moreira <vipperland[at]live.com>
 */
class Worker{

	static public function isAvailable():Bool {
		return untyped __js__('window.Worker') != null;
	}
	
}