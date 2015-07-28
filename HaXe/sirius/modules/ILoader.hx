package sirius.modules;
import sirius.dom.IDisplay;

/**
 * @author Rafael Moreira
 */

interface ILoader {
	
	/**
	 * Read the content of an loaded module
	 */
	public function get (module:String, ?data:Dynamic = null) : String;
	
	/**
	 * Draws a module in a DOMElement
	 * @param	module
	 * @param	data
	 * @return
	 */
	public function build (module:String, ?data:Dynamic = null) : IDisplay;
	
	/**
	 * Load a list of files
	 * @param	files
	 * @param	complete
	 * @param	error
	 * @return
	 */
	public function loadAll (files:Array<String>, complete:Dynamic, error:Dynamic):ILoader;
	
	/**
	 * Init Loader proccess
	 * @return
	 */
	public function start():ILoader;

}