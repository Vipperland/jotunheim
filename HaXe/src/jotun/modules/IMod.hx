package jotun.modules;

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

interface IMod {
	/**
	 * Name of [this] mod, a.k.a unique id, if not a instruction, mods with same name will be overrided
	 * Can be a instruction to buffer custom data into an array, use [] as name to push this data into Jotun.resources.data.buffer[]
	 * If type is data and [this] has a name, use Jotun.resources.object(name), and if is null, will try to parse a default mod instead.
	 */
	public var name:String;
	/**
	 * Import module to [this]
	 * [this] mod need to have the {{@include:MODNAME}} to import a module
	 * Alternative way to require a mod and fill with custom data is {{@include:MODNAME,data:{<JSON DATA>}}}
	 * 
	 */
	public var require:Array<String>;
	/**
	 * Inject [this] in another module
	 * Receiving mods need to have {{@inject:MODNAME}} to receive [this]
	 * Alternative way to inject a mod and fill with custom data is {{@inject:MODNAME,data:{<JSON DATA>}}}
	 */
	public var inject:Array<String>;
	/**
	 * The type content of [this] Mod.
	 * Possible values are: 
	 * 	"data", 
	 * 	'style'	Will be added to HEAD
	 * 	'script'	Will be added to HEAD 
	 * 	'image'	Jotun.resources.image(name)
	 */
	public var type:String;
	/**
	 * Replace contents
	 */
	public var replace:Array<Array<String>>;
	/**
	 * Fill [this] mod content with custom data on parsing phase
	 */
	public var data:Dynamic;
	/**
	 * Automatically build [this] in the target (css selector) when all mod data is ready
	 * Pass an object to define child index {"query":"target-selector", "index":0}
	 */
	public var target:Array<IModTarget>;
}

interface IModTarget {
	var query:String;
	var index:Int;
}